//
//  ComplaintListViewController.m
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ComplaintListViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "ComplaintModel.h"
#import "MJRefresh.h"
#import "ComplaintTableViewCell.h"
#import "GSDefine.h"
#import "ComplaintInfoViewController.h"
#import "AddComplaintViewController.h"

#define SELECTCELLBACKGROUND [UIColor lightGrayColor]
#define THEMECOLOR [UIColor colorWithRed:0.30f green:0.64f blue:0.24f alpha:1.00f]
#define TABLEVIEW_BACKGROUNDCOLOR [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f]
#define pageNumber  @"1"
#define pageSize @"10"
#define GetState(X) {[@[@"", @"举证协商阶段", @"判定阶段", @"公示结果"] objectAtIndex:X]}
//#define GetResult(X) {[@[@"等待审核", @"审核通过", @"审核未通过"] objectAtIndex:X]}

@interface ComplaintListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSMutableArray * typeArray;
@property (nonatomic) int selectedIndex;

@property (nonatomic, strong)UITableView * selectionTV;

@property (nonatomic) int reqCurPage;
@property (nonatomic) NSString * type;
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * result;

@end

@implementation ComplaintListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedIndex = 0;
    _type = nil;
    _state = nil;
    _result = nil;
    
//    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [addButton setTitle:@"我要投诉" forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//    [self.navigationItem setRightBarButtonItem:rightItem];
    
   /* 
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!%f", _tableView.frame.size.width);
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_TypeBar.frame.size.width/2-_BtnJBState.frame.size.width, 3, 1, _TypeBar.frame.size.height-10)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [_TypeBar addSubview:lineView1];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_TypeBar.frame.size.width/2+_BtnJBState.frame.size.width, 3, 1, _TypeBar.frame.size.height-10)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [_TypeBar addSubview:lineView2];
    */
    [_BtnJBType setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [_BtnJBState setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [_BtnJBResult setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    self.navigationItem.title = @"投诉信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [_tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
    
    _dataArray = [[NSMutableArray alloc] init];
    
  
    NSArray * JBTypeArray = @[@"全部", @"垃圾广告",@"TA要求我线下交易",@"雇主涉嫌作弊",@"雇主审标不合理",@"雇主要求不合理",@"雇主拒绝赏金",@"服务商未按时完成工作", @"服务商拒绝修改作品", @"服务商要求追加赏金", @"服务商无能力完成要求"];
    NSArray * JBStateArray = @[@"全部", @"举证协商阶段", @"判定阶段", @"公示结果"];
    NSArray * JBResultArray = @[@"全部", @"等待审核", @"审核未通过"];
    
    _typeArray = [NSMutableArray arrayWithArray:@[@[],JBTypeArray, JBStateArray, JBResultArray]];

    _selectionTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _TypeBar.frame.origin.y+_TypeBar.frame.size.height-300, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    _selectionTV.dataSource = self;
    _selectionTV.delegate = self;
    _selectionTV.backgroundColor = [UIColor whiteColor];
//    _selectionTV.scrollEnabled = NO;
    [self.view addSubview:_selectionTV];
    
    [self.view bringSubviewToFront:_TypeBar];
    _TypeBar.backgroundColor = THEMECOLOR;
    
    [self tableViewHeaderRereshing];
}

- (void)tableViewHeaderRereshing{
    self.reqCurPage = 1;
    [self requestComplaintListData];
}
- (void)tableViewFooterRereshing{
    self.reqCurPage ++;
    [self requestComplaintListData];
}

//- (void)addClick
//{
//    AddComplaintViewController * acv = [[AddComplaintViewController alloc] init];
//    acv.isNewComplaint = YES;
//    [self.navigationController pushViewController:acv animated:YES];
//}

#pragma mark - tableview
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return [_dataArray count];
    }
    else if (tableView == _selectionTV){
        return [[_typeArray objectAtIndex:_selectedIndex] count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString * cellName = @"ComplaintCell";
        ComplaintTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ComplaintTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        ComplaintModel * cm = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = cm.title;
      
//        cell.stateLabel.text = [NSString stringWithFormat:@"%@", (NSString *)GetState([cm.state intValue])];
        
        if ([cm.result intValue] == -1) {
            cell.resultLabel.text = @"等待审核";
        }
        else if ([cm.result intValue] == 1) {
            cell.resultLabel.text = @"审核未通过";
        }
        else {
            cell.resultLabel.text = [NSString stringWithFormat:@"%@", (NSString *)GetState([cm.state intValue])];//@"审核通过";
        }
//        cell.resultLabel.text = [NSString stringWithFormat:@"%@", (NSString *)GetResult([cm.result intValue]+1)];
        cell.timeLabel.text =  cm.time;
        
        return cell;

    }
    else if (tableView == _selectionTV){
        static NSString * cellName = @"selectCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        
        switch (_selectedIndex) {
            case 1:
                if (!_type && indexPath.row==0 ) {
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }
                else if (indexPath.row == [_type intValue]){
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }
                break;
                
            case 2:
                if (!_state && indexPath.row==0 ) {
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }
                else if (indexPath.row == [_state intValue]){
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }

                break;
            case 3:
                if (!_result && indexPath.row==0 ) {
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }
                else if (indexPath.row == 1 && [_result intValue] == -1){
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }
                else if (indexPath.row == 2 && [_result intValue] == 1){
                    cell.backgroundColor = SELECTCELLBACKGROUND;
                }

                break;
                
            default:
                break;
        }
        
        
        cell.textLabel.text = [[_typeArray objectAtIndex:_selectedIndex]objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ComplaintInfoViewController * ci = [[ComplaintInfoViewController alloc]initWithNibName:@"ComplaintInfoViewController" bundle:[NSBundle mainBundle]];
        ComplaintModel * cm = [_dataArray objectAtIndex:indexPath.row];
//        ci.complaintID = cm.complaintID;
//        ci.titleName = cm.title;
        ci.complaintModel = cm;
        [self.navigationController pushViewController:ci animated:YES];
    }
    else if (tableView == _selectionTV){
        if (_selectedIndex == 1) {
            if (indexPath.row == 0) {
                _type = nil;
            }
            else{
                _type = [NSString stringWithFormat:@"%ld", indexPath.row];
            }
        }
        else if (_selectedIndex == 2) {
            if (indexPath.row == 0) {
                _state = nil;
            }
            else{
                _state = [NSString stringWithFormat:@"%ld", indexPath.row];
            }
        }
        else if (_selectedIndex == 3) {
            if (indexPath.row == 0) {
                _result = nil;
            }
            else if (indexPath.row == 1) {
                _result = @"-1";
            }
            else if (indexPath.row == 2) {
                _result = @"1";
            }

        }
        NSLog(@"%@%@%@", _type, _state, _result);
        
        [self selectionTVMoveUp];
        [self tableViewHeaderRereshing];
        
        _BtnJBType.selected = NO;
        _BtnJBState.selected = NO;
        _BtnJBResult.selected = NO;
    }
}


#pragma mark - ComplaintListDataRequest
- (void)requestComplaintListData
{
    NSDictionary * para;
    if (_type && _state) {
         para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", _type, @"jb_lx_id", _state, @"zbZht", _result, @"shenhezht",nil];
    }
    else if (!_type&&_state){
        para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", _state, @"zbZht", _result, @"shenhezht",nil];
    }
    else if (_type&&!_state){
        para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", _type, @"jb_lx_id", _result, @"shenhezht",nil];
    }
    else if (!_type&&!_state){
         para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", _result, @"shenhezht",nil];
    }
    
    NSLog(@"\ncomplaint list:\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createComplaintListUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"\ncomplaint list:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"投诉列表 - 数据获取失败");
                          if (self.reqCurPage > 1 ) {
                              self.reqCurPage--;
                          }
                          [_tableView headerEndRefreshing];
                          [_tableView footerEndRefreshing];
                          return ;
                      }
                      
                      NSLog(@"投诉列表 - 数据获取成功");
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSArray * list = [dataDict objectForKey:@"list"];

                      if (self.reqCurPage == 1) {
                          [_dataArray removeAllObjects]; //重置数据源
                      }

                      for (NSDictionary * subDict in list) {
                          
                          ComplaintModel * cm = [[ComplaintModel alloc] init];
                          cm.complaintID = [subDict objectForKey:@"id"];
                          cm.informerName = [subDict objectForKey:@"jbr"];
                          cm.time =  [subDict objectForKey:@"lrsj"];
                          cm.defendantName = [subDict objectForKey:@"bjbr"];
                          cm.state = [subDict objectForKey:@"jb_zht"];
                          cm.result = [subDict objectForKey:@"shen_he_zt"];
                          cm.title = [subDict objectForKey:@"jb_bt"];
                          [_dataArray addObject:cm];
    
                      }
                      
                      [_tableView headerEndRefreshing];
                      [_tableView footerEndRefreshing];

                      [_tableView reloadData];
                      
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [_tableView headerEndRefreshing];
                         [_tableView footerEndRefreshing];
                     }];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.layoutMargins = UIEdgeInsetsZero;
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 按钮动作
- (IBAction)ActionJBType:(id)sender {
    _selectedIndex = 1;
    [_selectionTV reloadData];
    UIButton * btn = sender;
    if (btn.selected) {
        [self selectionTVMoveUp];
        btn.selected = NO;
    }
    else{
        [self selectionTVMoveDown];
        btn.selected = YES;
    }
 
    _BtnJBState.selected = NO;
    _BtnJBResult.selected = NO;
}

- (IBAction)ActionJBState:(id)sender {
    _selectedIndex = 2;
    [_selectionTV reloadData];
    UIButton * btn = sender;
    if (btn.selected) {
        [self selectionTVMoveUp];
        btn.selected = NO;
    }
    else{
        [self selectionTVMoveDown];
        btn.selected = YES;
    }
    
    _BtnJBType.selected = NO;
    _BtnJBResult.selected = NO;
}

- (IBAction)ActionJBResult:(id)sender {
    _selectedIndex = 3;
    [_selectionTV reloadData];
    UIButton * btn = sender;
    if (btn.selected) {
        [self selectionTVMoveUp];
        btn.selected = NO;
    }
    else{
        [self selectionTVMoveDown];
        btn.selected = YES;
    }
    
    _BtnJBType.selected = NO;
    _BtnJBState.selected = NO;
}

- (void)selectionTVMoveDown
{
    CGFloat height = _TypeBar.frame.size.height/44.f*44.f*[[_typeArray objectAtIndex:_selectedIndex] count] < 300.f ? _TypeBar.frame.size.height/44.f*44.f*[[_typeArray objectAtIndex:_selectedIndex] count] : 300.f;
    [UIView animateWithDuration:0.3 animations:^{
        _selectionTV.frame = CGRectMake(0, _TypeBar.frame.origin.y+_TypeBar.frame.size.height, self.view.frame.size.width, height);
    }];
    if (height < 300.f) {
        _selectionTV.scrollEnabled = NO;
    }
    else{
        _selectionTV.scrollEnabled = YES;
    }
    
}

- (void)selectionTVMoveUp
{
    [UIView animateWithDuration:0.3 animations:^{
        _selectionTV.frame = CGRectMake(0, _TypeBar.frame.origin.y+_TypeBar.frame.size.height-300, self.view.frame.size.width, 300);
    }];
    
}
@end
