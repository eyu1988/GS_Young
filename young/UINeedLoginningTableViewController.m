//
//  UINeedLoginningTableViewController.m
//  young
//
//  Created by z Apple on 15/3/31.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "UINeedLoginningTableViewController.h"
#import "GlobleLocalSession.h"
@implementation UINeedLoginningTableViewController


//-(void) viewDidAppear:(BOOL)animated
//{
//    [GlobleLocalSession getLoginUserInfo:self];
//}


//- (void)viewWillAppear:(BOOL)animated
//{
//    if(![GlobleLocalSession getAttribute:@"userInfo"]){
//        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        [self.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier:
//                                                       @"Login"] animated:YES];
//    }
//}

//-(void) viewDidLoad
//{
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    if(![GlobleLocalSession getAttribute:@"userInfo"]){
//        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        [self.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier:
//                                                       @"Login"] animated:YES];
//    }
//    [super viewDidLoad];
//}
@end
