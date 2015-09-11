//
//  ComplaintInfoViewController.m
//  young
//
//  Created by Lucas on 15/8/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ComplaintInfoViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "GSDefine.h"
#import "ComplaintInfoTableViewCell.h"
#import "AddComplaintViewController.h"

#define CELLHEIGHT 120.f

@interface ComplaintInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * informerDataSource;
@property (nonatomic, strong) NSMutableArray * defendantDataSource;

@end

@implementation ComplaintInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestComplaintData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    
    if ([_complaintModel.state intValue] == 1) {//举证协商阶段
        UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [addButton setTitle:@"追加证据" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    _userBar.backgroundColor = THEMECOLOR;
    _titleLabel.text = _complaintModel.title;
    if ([_complaintModel.result intValue] == -1) {
        _stateLabel.text = @"状       态:      等待审核";
    }
    else if ([_complaintModel.result intValue] == 1) {
        _stateLabel.text = @"状       态:      审核未通过";
    }
    else {
        _stateLabel.text =  [NSString stringWithFormat:@"状       态:      %@", (NSString *)GetState([_complaintModel.state intValue])];
    }
    
//    _dataArray = [[NSMutableArray alloc] init];
    _informerDataSource = [[NSMutableArray alloc] init];
    _defendantDataSource = [[NSMutableArray alloc] init];
    
    _informationTV.dataSource = self;
    _informationTV.delegate = self;
    _informationTV.tableFooterView = [[UIView alloc] init];
    _informationTV.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];

    [_btnJB setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [_btnBJB setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    _btnJB.selected = YES;
    _btnBJB.selected = NO;
    
//    [self requestComplaintData];
}

- (void) addClick
{
    NSLog(@"追加举证");
    AddComplaintViewController * acv = [[AddComplaintViewController alloc] init];
    acv.isNewComplaint = NO;
    acv.complaintTitle = _complaintModel.title;
    acv.complaintID = _complaintModel.complaintID;
    ComplaintModel * cm = _informerDataSource[0];
    acv.complaintType = cm.type;
    acv.userType = cm.userType;
    
    [self.navigationController pushViewController:acv animated:YES];
}

#pragma mark - ComplaintDataRequest
- (void)requestComplaintData
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", _complaintModel.complaintID, @"jubaoId",nil];
    
    NSLog(@"\ncomplaint :\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createComplaintInfoUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"\ncomplaint :\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"投诉 - 数据获取失败");
                          return ;
                      }
                      
                      NSLog(@"投诉 - 数据获取成功");
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSDictionary * tousuInfo = [dataDict objectForKey:@"tousuInfo"];
                      
                      if ([_complaintModel.result intValue] == 0) {
                          NSDictionary * deadline = [tousuInfo objectForKey:@"pd_jzrq"];
                          NSString * timeStamp = [deadline objectForKey:@"time"];
                          NSString * time = [self dateToStringWithTimeStamp:timeStamp];
                          NSLog(@"%@", time);
                          _timeLable.text = [NSString stringWithFormat:@"截止日期:      %@", time];
                       }
                      else{
                          _timeLable.text = @"";
                      }
                      
//                      cm.proofTitle = [tousuInfo objectForKey:@"ddmc"];
                      [_informerDataSource removeAllObjects];
                      NSDictionary * informerList = [dataDict objectForKey:@"zjJubao"];
                      for (NSDictionary * subDict in informerList) {
                          ComplaintModel * cm = [[ComplaintModel alloc] init];
                          cm.defendantName = [tousuInfo objectForKey:@"bjbr_name"];
                          cm.informerName = [tousuInfo objectForKey:@"jbr_name"];
                          cm.time = [subDict objectForKey:@"scsj"];
                          cm.title = [subDict objectForKey:@"ju_bao_nei_rong"];
                          cm.downLoadFiles = [subDict objectForKey:@"jz_res_ids"];
                          cm.type = [tousuInfo objectForKey:@"jb_lx_id"];
                          cm.userType = [subDict objectForKey:@"ren_lei_xing"];
                          [_informerDataSource addObject:cm];
                      }
                      
                      [_defendantDataSource removeAllObjects];
                      NSDictionary * defendantList = [dataDict objectForKey:@"zjBeijubao"];
                      for (NSDictionary * subDict in defendantList) {
                          ComplaintModel * cm = [[ComplaintModel alloc] init];
                          cm.defendantName = [tousuInfo objectForKey:@"bjbr_name"];
                          cm.informerName = [tousuInfo objectForKey:@"jbr_name"];
                          cm.time = [subDict objectForKey:@"scsj"];
                          cm.title = [subDict objectForKey:@"ju_bao_nei_rong"];
                          cm.downLoadFiles = [subDict objectForKey:@"jz_res_ids"];
                          cm.type = [tousuInfo objectForKey:@"jb_lx_id"];
                          cm.userType = [subDict objectForKey:@"ren_lei_xing"];
                          [_defendantDataSource addObject:cm];
                      }


//                      _informerDataSource = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
//                      _defendantDataSource = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3", @"4"]];

//                      _dataArray = _informerDataSource;
                      
                      CGFloat height = _userBar.frame.size.height/44.f*CELLHEIGHT*[_informerDataSource count];
                      if (height <_userBar.frame.size.height/44.f*274.f) {
                          _informationTV.scrollEnabled = NO;
                      }
                      else{
                          _informationTV.scrollEnabled = YES;
                      }
                      
                      [_informationTV reloadData];
                      
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                     }];
}

#pragma mark - 时间戳转时间字符串
- (NSString *)dateToStringWithTimeStamp:(NSString *)timeStamp
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //直接输出的话是机器码
    //或者是手动设置样式[formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSString *string = [formatter stringFromDate:date];
    
    return string;
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_btnJB.selected) {
//        NSLog(@"%ld", [_informerDataSource count]);
        return [_informerDataSource count];
    }
    else if (_btnBJB.selected){
//        NSLog(@"%ld",  [_defendantDataSource count]);
        return [_defendantDataSource count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"ComplaintInfoCell";
    ComplaintInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ComplaintInfoTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    if (_btnJB.selected) {
        ComplaintModel * cm = [_informerDataSource objectAtIndex:indexPath.row];
        cell.titleLabel.text = @"举报人陈述时间: ";
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@", cm.informerName];
        cell.contentLabel.text = [NSString stringWithFormat:@"陈述理由: %@  ", cm.title];
        cell.timeLabel.text = cm.time;
//        NSLog(@"%@", cm.downLoadFiles);
//        if (cm.downLoadFiles && [cm.downLoadFiles count] > 0) {
//            cell.proofBtn.hidden = NO;
//        }
//        else{
//            cell.proofBtn.hidden = YES;
//        }
    }
    else if (_btnBJB.selected){
        ComplaintModel * cm = [_defendantDataSource objectAtIndex:indexPath.row];
        cell.titleLabel.text = @"被举报人自辩时间: ";
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@", cm.defendantName];
        cell.contentLabel.text = [NSString stringWithFormat:@"陈述理由: %@  ", cm.title];
        cell.timeLabel.text = cm.time;
//        NSLog(@"%@", cm.downLoadFiles);
        //        if (cm.downLoadFiles && [cm.downLoadFiles count] > 0) {
        //            cell.proofBtn.hidden = NO;
        //        }
        //        else{
        //            cell.proofBtn.hidden = YES;
        //        }
    }
    
    return cell;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _informationTV.layoutMargins = UIEdgeInsetsZero;
    [_informationTV setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
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

- (IBAction)ActionJB:(id)sender {
    UIButton * btn = sender;
    btn.selected = YES;
    _btnBJB.selected = NO;
    
//    _dataArray = _informerDataSource;
    
    CGFloat height = _userBar.frame.size.height/44.f*CELLHEIGHT*[_informerDataSource count];
    if (height <_userBar.frame.size.height/44.f*274.f) {
        _informationTV.scrollEnabled = NO;
    }
    else{
        _informationTV.scrollEnabled = YES;
    }

    [_informationTV reloadData];
}
- (IBAction)ActionBJB:(id)sender {
    UIButton * btn = sender;
    btn.selected = YES;
    _btnJB.selected = NO;
    
//    _dataArray = _defendantDataSource;
    
    CGFloat height = _userBar.frame.size.height/44.f*CELLHEIGHT*[_defendantDataSource count];
    if (height <_userBar.frame.size.height/44.f*274.f) {
        _informationTV.scrollEnabled = NO;
    }
    else{
        _informationTV.scrollEnabled = YES;
    }

    [_informationTV reloadData];
}
@end
