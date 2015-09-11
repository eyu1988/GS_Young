//
//  UIViewController+PowerVerify.m
//  young
//
//  Created by z Apple on 15/4/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "UIViewController+PowerVerify.h"
#import "GlobleLocalSession.h"
//maybe the class is a trouble maker whit you.
@implementation UIViewController (PowerVerify)
//Override the 'shouldPerformSequeWithIdntifier:(NSString *)identifier sender:(id)sender' method of the UIViewController.
//This is a dengerous mode.We should never do that.

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"//no warning
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
        if(![GlobleLocalSession getLoginUserInfo]){
            if ([identifier isEqualToString:@"See Photo"]
                ||[identifier isEqualToString:@"myCrowdSourcingUnderWay"]
                ||[identifier isEqualToString:@"myCrowdSourcingDone"]
                ||[identifier isEqualToString:@"myRequirementList"]
                ||[identifier isEqualToString:@"myBidList"]
                ||[identifier isEqualToString:@"bid"]
                ) {
                
                UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [self.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier:
                                                               @"Login"] animated:YES];
                return NO;
            }
           
        }
    
    return YES;
}
@end
