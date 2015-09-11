//
//  CrowdSourcingViewDetailedTVC.m
//  young
//
//  Created by z Apple on 8/21/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "CrowdSourcingViewDetailedTVC.h"
#import "PrimaryTools.h"
#import "HomeTabBarViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "BiderListTVC.h"
#import "CrowdSourcingDetailContentSectionCell.h"
#import "CrowdSourcingDetailTitleSectionCell.h"
#import "BiderListCell.h"
#import "NullHandler.h"
#import "ColorfulRectAndUILabelTableHeader.h"
#import "CSDetailedBottomView.h"
#import "CrowdSourcingBiderDetailTVC.h"
#import "GSDefine.h"
#import "GlobleLocalSession.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CrowdSourcingViewDetailedTVC ()
@property (strong,nonatomic)UIView *bottomView;
@property (strong,nonatomic)BiderListTVC *biderListTVC;
@property (strong,nonatomic)NSMutableArray *biderListData;
@property (copy,nonatomic)NSDictionary *requireInfoDict;
@property (copy,nonatomic)NSDictionary *dataDict;
@property (strong,nonatomic)CSDetailedBottomView *sView;

@end

@implementation CrowdSourcingViewDetailedTVC

CGFloat cellHeight = 108;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.sView = [PrimaryTools getFristObjectFromNibByNibName:@"CSDetailedBottomView"];
    [self.sView setFrame:CGRectMake(self.sView.frame.origin.x,self.sView.frame.origin.y,WIDTH,self.sView.frame.size.height)];
    _bottomView =self.sView;
    self.sView.nc = self.navigationController;
    
    [self.view addSubview:self.sView];

}
- (void)viewWillAppear:(BOOL)animated
{
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc hideAllTabBar];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc appearAllTabBar];
}
- (void)initData
{
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:self.requirementId,@"id", [GlobleLocalSession getLoginId], @"login_id",nil];
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingDetailUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                self.dataDict =[result objectForKey:@"data"];
                self.requireInfoDict = [self.dataDict objectForKey:@"xuqiuInfo"];
                
                // 用于添加投诉时使用的参数
                NSDictionary * fwsInfo = [self.dataDict objectForKey:@"fwsInfo"];
                if (![fwsInfo isEqual: [NSNull null]]) {
                    _sView.requireId = [fwsInfo objectForKey:@"xqfwsid"];
                    NSLog(@"服务商id: %@", _sView.requireId);
                }
                else{
                    _sView.requireId = @"-1";
                }
                
                
                 [self initBiderList];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
   
}

- (void)initBiderList
{
    [self setupData:1];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==2) {
        ColorfulRectAndUILabelTableHeader *th = nil;
        th =  (ColorfulRectAndUILabelTableHeader*)[PrimaryTools getFristObjectFromNibByNibName:@"ColorfulRectAndUILabelTableHeader"];
        th.titleLabel.text = @"抢单人";
        
        [th setRetract:10];
        return th;
    }else{
        return nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了父cell");
}

#pragma mark - Table view data source

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    CGRect frame = self.bottomView.frame;
    frame.origin.y = self.tableView.contentOffset.y+HEIGHT-self.bottomView.frame.size.height;
    [self.bottomView setFrame:frame];
}

-(BOOL)downPullLoadData
{
    [self initData];
    return YES;
}

-(BOOL)upPullLoadData
{
   
    [self setupData:self.pageNo+1];
    return NO;
}


-(void)setupData:(int)pageNoParameter{
    
    if ([self isOrNotDataLoadLock:pageNoParameter]) return;
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:self.requirementId,@"xuqiuId",[NSString stringWithFormat:@"%d",pageNoParameter],@"pageNumber", nil];
    
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingBiderListUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"initData-result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                NSMutableArray *dataArray = [NSMutableArray arrayWithArray:
                                             [dataDict objectForKey:@"list"]];
                if (pageNoParameter == 1) {
                    self.biderListData = [NSMutableArray arrayWithArray:dataArray];
                    [super stopDownPullRefreshAnimating];
                }else{
                    if ([dataArray count]!=0){
                        self.pageNo++;
                    [self.biderListData addObjectsFromArray:dataArray];
                    }
                  [super stopUpPullRefreshAnimating];
                }
                [self.tableView reloadData];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return [self.biderListData count];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2){
        return 36;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        CrowdSourcingDetailTitleSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdSourcingDetailTitleSectionCell" forIndexPath:indexPath];
        cell.requireTitleLabel.text = [self.requireInfoDict objectForKey:@"xqmc"];
        cell.requireTypeLabel.text = [self.requireInfoDict objectForKey:@"lbmc"];
        cell.releaseTimeLabel.text = [NullHandler connectNotNullString:@"",[[self.requireInfoDict objectForKey:@"fbsj"] componentsSeparatedByString:@" "][0],nil];

        cell.residueTimeLabel.text =[self.requireInfoDict objectForKey:@"zbjzrq_shengyu_format"];
        return cell;
    }else if (indexPath.section==1){
        CrowdSourcingDetailContentSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdSourcingDetailContentSectionCell" forIndexPath:indexPath];
                
        [cell initData:self.requireInfoDict];
        return cell;
    }else{
        
        BiderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BiderListCell" forIndexPath:indexPath];
        cell.nickNameLabel.text = [self.biderListData[indexPath.row] objectForKey:@"nick_name"];
        [PrimaryTools setHeadImage:cell.headImageView userNo:[self.biderListData[indexPath.row] objectForKey:@"yh_id"]];
        
        cell.goodnessLabel.text = [self.biderListData[indexPath.row] objectForKey:@"ys"];
        cell.bidTimeLabel.text = [self.biderListData[indexPath.row] objectForKey:@"lrsj"];
        return cell;

    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CrowdSourcingBiderDetailTVC *c = [segue destinationViewController];
    c.bidId = [self.biderListData[indexPath.row] objectForKey:@"id"];
    
//    self.biderListData[indexPath.row]
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
