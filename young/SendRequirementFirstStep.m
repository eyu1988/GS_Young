//
//  SendRequirementFirstStep.m
//  young
//
//  Created by z Apple on 15/5/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "SendRequirementFirstStep.h"
#import "SortTableViewController.h"

@implementation SendRequirementFirstStep

-(void)viewDidLoad
{
    [super viewDidLoad];

}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//     SortTableViewController *c = [segue destinationViewController];
//     c.jumpWhere = @"toSendRequirement";
//    if([segue.identifier isEqualToString:@"myRequirementList"]){
//        
//        
//    }else if([segue.identifier isEqualToString:@"quickGrabCrowdSourcing"]){
//        
//        
//    }else {
//        
//        
//    }

}


@end
