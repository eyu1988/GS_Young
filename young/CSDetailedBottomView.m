//
//  CSDetailedBottomView.m
//  young
//
//  Created by z Apple on 8/24/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "CSDetailedBottomView.h"
#import "PrimaryTools.h"
#import "CrowdSourcingBiddingViewController.h"
#import "AddComplaintViewController.h"
@implementation CSDetailedBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)bidding:(id)sender {
    CrowdSourcingBiddingViewController *vc = [PrimaryTools createVcByMainStoryBoardIdentifier:@"CrowdSourcingBiddingViewController"];
    vc.requirementId = self.requireId;
    [self.nc showViewController:vc sender:nil];
}

- (IBAction)complainAction:(id)sender {
    
    if ([self.requireId intValue] == -1) {
        [PrimaryTools alert:@"您还没有对此需求抢单, 不能添加投诉!"];
        return;
    }
    AddComplaintViewController * acv = [[AddComplaintViewController alloc] init];
    acv.isNewComplaint = YES;
    acv.orderID = self.requireId;
    NSLog(@" requiredId %@", self.requireId);
    [self.nc showViewController:acv sender:nil];
//    [self.navigationController pushViewController:acv animated:YES];
}

- (IBAction)contactAction:(id)sender {
    
}
@end
