//
//  SortTableViewController.m
//  young
//
//  Created by z Apple on 15/4/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "SortTableViewController.h"
#import "CLTree.h"
#import "AppDelegate.h"
#import "CrowdSourcingTableViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "ReleaseRequirementFormTVC.h"
#import "Message.h"
#import "WorkTypeTools.h"

@interface SortTableViewController ()
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组

@end

@implementation SortTableViewController
NSString *threeLevelImageName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.dataArray count]==0){
        CGRect tableViewFrame = CGRectMake(0, 25, self.view.frame.size.width, self.view.frame.size.height);
        self.tableView.frame = tableViewFrame;
        [self addTreeData];
    }
}


-(BOOL)downPullLoadData
{
    return YES;
}

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addTreeData
{
    
    [ZSyncURLConnection request:[UrlFactory createRequirementTypeTreeUrl] completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            self.dataArray = [[NSMutableArray alloc] init];
//            NSLog(@"data-tree:%@",[[dict objectForKey:@"data"] objectForKey:@"tree" ]);
            [self setTreeDate:[[dict objectForKey:@"data"] objectForKey:@"tree" ]];
            [self reloadDataForDisplayArray];//初始化将要显示的数据
            
        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
}

-(void)setTreeDate:(NSArray*)treeArray
{
    for (NSDictionary* dic in  treeArray) {
        NSArray *children = [dic objectForKey:@"children"];
        CLTreeViewNode *node0 = [self createLevelZeroModel:dic];
              if ([children count]!=0) {
                [self setTreeFirstLevel:children firstNode:node0];
              }
        [_dataArray addObject:node0];
    }
}

-(void)setTreeFirstLevel:(NSArray*)firstArray firstNode :(CLTreeViewNode*)firstNode
{
    for (NSDictionary* dic in  firstArray) {
        NSArray *children = [dic objectForKey:@"children"];
        CLTreeViewNode *node1 = [self createLevelOneModel:dic];
        if ([children count]!=0) {
            [self setTreeSecendLevel:children secendNode:node1];
          
        }
        [firstNode.sonNodes addObject:node1];
        
    }
}

-(void)setTreeSecendLevel:(NSArray*)secendArray secendNode :(CLTreeViewNode*)secendNode
{
    for (NSMutableDictionary* dic in  secendArray) {
        CLTreeViewNode *node1 = [self createLevelTwoModel:dic];
        [secendNode.sonNodes addObject:node1];
    }
}

-(CLTreeViewNode*)createLevelZeroModel:(NSDictionary*)dic
{
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 0;
    node0.type = 0;
    node0.sonNodes = [[NSMutableArray alloc] init];
    node0.isExpanded = false;
    CLTreeView_LEVEL0_Model *tmp0 =[[CLTreeView_LEVEL0_Model alloc]init];
    tmp0.name = [dic objectForKey:@"mc"];
//    tmp0.headImgPath = @"type_first_level.png";
    tmp0.headImgPath = [WorkTypeTools workTypeImageNamebyworkType:tmp0.name];
    threeLevelImageName = tmp0.headImgPath;
    tmp0.headImgUrl = nil;
    node0.nodeData = tmp0;
    return node0;
}

-(CLTreeViewNode*)createLevelOneModel:(NSDictionary*)dic
{
    CLTreeViewNode *node1 = [[CLTreeViewNode alloc]init];
    node1.nodeLevel = 1;
    node1.type = 1;
    node1.sonNodes = [[NSMutableArray alloc] init];
    node1.isExpanded = false;
    CLTreeView_LEVEL1_Model *tmp1 =[[CLTreeView_LEVEL1_Model alloc]init];
    tmp1.name = [dic objectForKey:@"mc"];
    tmp1.sonCnt = [NSString stringWithFormat:@"%lu",(unsigned long)[[dic objectForKey:@"children"] count]];
    node1.nodeData = tmp1;
    
    return node1;
}

-(CLTreeViewNode*)createLevelTwoModel:(NSMutableDictionary*)dic
{
    CLTreeViewNode *node2 = [[CLTreeViewNode alloc]init];
    node2.nodeLevel = 2;
    node2.type = 2;
    node2.sonNodes =nil;
    node2.isExpanded = FALSE;
    CLTreeView_LEVEL2_Model *tmp2 =[[CLTreeView_LEVEL2_Model alloc]init];
    tmp2.name = [dic objectForKey:@"mc"];
//    tmp2.headImgPath = @"contacts_major.png";
    tmp2.headImgPath = threeLevelImageName;
    tmp2.headImgUrl = nil;

    tmp2.identifer = [dic objectForKey:@"id"];
    tmp2.infoDict = dic;
    node2.nodeData = tmp2;
    
    return node2;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        if(nodeData.headImgPath != NULL && nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        ((CLTreeView_LEVEL2_Cell*)cell).identifer = nodeData.identifer;
        ((CLTreeView_LEVEL2_Cell*)cell).infoDict = nodeData.infoDict;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
}


/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
         CLTreeView_LEVEL2_Cell *cell = (CLTreeView_LEVEL2_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([self.navigationItem.title isEqualToString:@"选择服务分类"]) {
                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                CrowdSourcingTableViewController *cstvc= [self.navigationController.viewControllers objectAtIndex:index-1];
                [cstvc.servicetypeButton setTitle:cell.name.text forState:UIControlStateNormal];
                cstvc.entryParamter= [NSMutableDictionary
                                  dictionaryWithObjectsAndKeys:cell.identifer,@"lbid", nil];
            
                [self.navigationController popToViewController:cstvc animated:YES];
            
        }else [self.navigationController pushViewController:[self getJumpToVC:cell ] animated:YES];
  }
    else{
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI_2];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }
}

-(UIViewController*)getJumpToVC:(CLTreeView_LEVEL2_Cell*)cell
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    if([self.navigationItem.title isEqualToString:@"发布需求"]){
        ReleaseRequirementFormTVC *cv =[mainStoryboard   instantiateViewControllerWithIdentifier:@"ReleaseRequirementFormTVC"];
//        cv.navigationItem.title=cell.name.text;
        cv.typeIdentifier = cell.identifer;
        cv.dealMode = [cell.infoDict objectForKey:@"jiaoyi_moshi"];
        NSLog(@"cv.dealMode:%@",cv.dealMode);
        
        return cv;
    } else{
        CrowdSourcingTableViewController *cv =[mainStoryboard   instantiateViewControllerWithIdentifier:@"CrowdSourcingTableViewController"];
        cv.navigationItem.title=cell.name.text;
        cv.serviceTypeName = cell.name.text;
        cv.entryParamter= [NSMutableDictionary
                               dictionaryWithObjectsAndKeys:cell.identifer,@"lbid", nil];
        return cv;
    }
    
}


/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

@end
