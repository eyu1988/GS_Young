//
//  CrowdSourcingViewDetailCommonControl.m
//  young
//
//  Created by z Apple on 15/3/23.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "CrowdSourcingViewDetailCommonControl.h"
#import "NullHandler.h"
#import "ViewInfoByWebUIController.h"
#import "PrimaryTools.h"
#import "CrowdSourcing.h"
#import "CrowdSourcingBiddingViewController.h"
#import "GlobleLocalSession.h"

@implementation CrowdSourcingViewDetailCommonControl

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initData];
    
}

-(void)initData
{
    self.requirementDic = [self.allDataDic objectForKey:@"xuqiuInfo"];

    [NullHandler NotNil:[self.requirementDic objectForKey:@"xqmc"] AssignToUiReceiver:self.requirementTitle];
//    [NullHandler NotNil:(NSString*)[self.requirementDic objectForKey:@"nick_name"] AssignToUiReceiver:self.userName];
    [NullHandler NotNil:[self.requirementDic objectForKey:@"xqnr"] AssignToUiReceiver:self.introductionButton];
    self.introductionButton.titleLabel.numberOfLines=6;
    
    self.targetPeopleNum.text =
    [NullHandler connectNotNullString:@"目标人数: ",[self.requirementDic objectForKey:@"zbrssx"], nil];
    self.targetEndDate.text =
    [NullHandler connectNotNullString:@"",[self.requirementDic objectForKey:@"zbjzrq"], nil];
    
    self.endDate.text =
    [NullHandler connectNotNullString:@"",[self.requirementDic objectForKey:@"jhwcrq"], nil];
    
    self.requirementType.text =
    [NullHandler connectNotNullString:@"",[self.requirementDic objectForKey:@"lbmc"], nil];
    
    self.issueData.text =
    [NullHandler connectNotNullString:@"",[self.requirementDic objectForKey:@"fbsj"], nil];
    
    self.contactWay.text =
    [NullHandler connectNotNullString:@"",[self.requirementDic objectForKey:@"lxfs"], nil];
    
    
    [self setRequirementStateAndBidTitle];
    
    self.budget.text =[NSString stringWithFormat:@"￥%@", [self.requirementDic objectForKey:@"sjje"]];
    self.bidderSum.text=[NSString stringWithFormat:@"一共%@个交稿的服务商，您可以直接找他们做类似的需求：",[[self.allDataDic objectForKey:@"xuqiu_dongtai"] objectForKey:@"fws_count"]];
//  [PrimaryTools setHeadImage:self.headerImage userNo:[self.requirementDic objectForKey:@"yh_id"]];
}


-(void)setRequirementStateAndBidTitle{
    NSString *title = [NullHandler connectNotNullString:@"",[CrowdSourcing getRequirementState:self.requirementDic], nil];
    if ([title isEqualToString:@"等你抢"]) {
        [self.requirementStateAndBid setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.requirementStateAndBid.enabled = YES;
    }else{
        [self.requirementStateAndBid setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.requirementStateAndBid.enabled = NO;
    }
    
    [self.requirementStateAndBid setTitle:title forState:UIControlStateNormal];
}

- (IBAction)intoWebView:(id)sender {


    ViewInfoByWebUIController
    *cv = [[ViewInfoByWebUIController alloc] initWithNibName:@"BaseWebUI" bundle:nil];
 
    NSString* htmlString = [NSString stringWithFormat:
                            @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 16pt; color: red;'><B>%@</B><br></div><div style='width: 100%%; text-align: left; font-size: 12pt; color: black;'><br>&nbsp&nbsp&nbsp&nbsp%@</div></body></html>",self.requirementTitle.text,
                            [self.introductionButton.titleLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]];
    
   
    
    cv.strHtml = htmlString;
    [self.navigationController pushViewController:cv animated:YES];
    

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toBid"]){
        CrowdSourcingBiddingViewController *c = [segue destinationViewController];
//        NSLog(@"_requirementDic:%@",_requirementDic);
//        NSLog(@"_allDataDic:%@",_allDataDic);
        c.requirementId = [_requirementDic objectForKey:@"id"];
        c.allDataDic = _allDataDic;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"toBid"]){
        if ([[[GlobleLocalSession getLoginUserInfo] objectForKey:@"is_check"] intValue] != 2) {
            [PrimaryTools alert:@"您还未实名认证，请在我的中心中进行实名认证后，再抢需求。"];
            return NO;
        }
        __block BOOL isAlreadyBid = NO;
        [[_allDataDic objectForKey:@"xqfwsList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
