//
//  RefreashTableViewController.h
//  young
//
//  Created by z Apple on 15/4/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreashTableViewController : UITableViewController
@property (nonatomic) UIActivityIndicatorView *upPullRefreshControl;
@property (nonatomic) int pageNo;
@property (nonatomic) BOOL dataLoadLock;
-(BOOL)downPullLoadData;
-(BOOL)upPullLoadData;
-(void)stopUpPullRefreshAnimating;
-(void)stopDownPullRefreshAnimating;
-(BOOL)isOrNotDataLoadLock:(int)pageNoParameter;

@end
