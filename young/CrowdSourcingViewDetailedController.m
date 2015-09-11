//
//  CrowdSourcingViewDetailedController.m
//  young
//
//  Created by z Apple on 15/3/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "CrowdSourcingViewDetailedController.h"
#import "CrowdSourcingDetailViewCell.h"
#import "CrowdSourcingViewDetailCommonControl.h"
#import "CrowdSourcingBiddingViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "PrimaryTools.h"
#import "CrowdSourcing.h"
#import "GlobleLocalSession.h"
#import "NullHandler.h"

@implementation CrowdSourcingViewDetailedController

- (void) viewDidLoad{
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
    
    if(!self.allDataDic)
        [self initData];
    ((CrowdSourcingViewDetailCommonControl*)self.childViewControllers[0]).allDataDic = self.allDataDic;
    
    [((CrowdSourcingViewDetailCommonControl*)self.childViewControllers[0]) viewDidLoad];
    [super viewWillAppear:YES];
}

-(void)initData
{
    
    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys:self.requirementId,@"id",nil];
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingDetailUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.allDataDic = [dict objectForKey:@"data"];
                
                _requirementDic = [self.allDataDic objectForKey:@"xuqiuInfo"];
                _bidList=[self.allDataDic objectForKey:@"xqfwsList"];
                 ((CrowdSourcingViewDetailCommonControl*)self.childViewControllers[0]).allDataDic = self.allDataDic;
                [((CrowdSourcingViewDetailCommonControl*)self.childViewControllers[0]) viewWillAppear:YES];
                //refresh crowdsourcing list cell value
                NSMutableDictionary *d =[[NSMutableDictionary alloc] init];
                [d addEntriesFromDictionary:self.crowdSourcingList[self.listIndex]];
                [d setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[_bidList count]] forKey:@"fws_count"];
                self.crowdSourcingList[self.listIndex] = d;
                if ([[_requirementDic objectForKey:@"xqzt_keyiqiang"] intValue]==0
                    ||[[_requirementDic objectForKey:@"login_name"] isEqualToString:
                    [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_name"]]
                    ) {
                    self.navigationItem.rightBarButtonItem=nil;
                   
                }
                [self.tableView reloadData];
            }
        });}
                     errorBlock:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DetailCellIdentifier = @"CrowdSourcingDetailViewCell";
    
   
    CrowdSourcingDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  DetailCellIdentifier];
    if (cell == nil) {
        cell = [[CrowdSourcingDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
    }
    
    cell.bidder.text=[NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[self.bidList[indexPath.row] objectForKey:@"nick_name"]];
//    NSLog(@"bidList:%@",self.bidList);
    cell.bidderIntroduce.text=[self.bidList[indexPath.row] objectForKey:@"ys"];
    cell.date.text=[self.bidList[indexPath.row] objectForKey:@"lrsj"];
     [PrimaryTools setHeadImage:cell.headImage userNo:[self.bidList[indexPath.row] objectForKey:@"yh_id"]];
    
    cell.bidState.text=[CrowdSourcing getRequirementBidState:self.bidList[indexPath.row]];
    
    
    return cell;
    
}

-(NSDictionary *)getRequirementInfoDic
{
    return [_requirementDic objectForKey:@"xuqiuInfo"];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.bidList count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat coefficient = [[self.bidList[indexPath.row] objectForKey:@"ys"] length] /40;
    return 125 + coefficient * 20;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"requriementCommonInfo"]){
//        [self initData];
        CrowdSourcingViewDetailCommonControl *c = [segue destinationViewController];
        c.allDataDic =self.allDataDic;
       
    }else if([segue.identifier isEqualToString:@"bid"]){
        CrowdSourcingBiddingViewController *c = [segue destinationViewController];
        c.requirementId = _requirementId;
        c.allDataDic = _allDataDic;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"bid"]){
        if ([[[GlobleLocalSession getLoginUserInfo] objectForKey:@"is_check"] intValue] != 2) {
            [PrimaryTools alert:@"您还未实名认证，请在我的中心中进行实名认证后，再抢需求。"];
            return NO;
        }
        __block BOOL isAlreadyBid = NO;
        [self.bidList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj objectForKey:@"yh_id"] ==[[GlobleLocalSession getLoginUserInfo] objectForKey:@"user_no"]) {
                *stop = YES;
                isAlreadyBid=YES;
            }
        }];
        if (isAlreadyBid) {
            [PrimaryTools alert:@"您已经抢过此单，不能重复抢单。"];
            return NO;
        }
    }
    return YES;
}

@end
