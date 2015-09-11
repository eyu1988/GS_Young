//
//  RefreashTableViewController.m
//  young
//
//  Created by z Apple on 15/4/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "RefreashTableViewController.h"


@interface RefreashTableViewController ()

@end

@implementation RefreashTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = self.upPullRefreshControl;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor greenColor];
   [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    self.upPullRefreshControl = [ [ UIActivityIndicatorView alloc ]
                                 initWithFrame:CGRectMake(0,0,60,60)];
    [self.upPullRefreshControl setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];    self.upPullRefreshControl.color = [UIColor greenColor];
    self.upPullRefreshControl.hidesWhenStopped = YES;
//    self.tableView.tableFooterView=self.upPullRefreshControl;
    [self.tableView.tableFooterView addSubview:self.upPullRefreshControl];
    _pageNo = 1;
    _dataLoadLock = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.tableView.contentOffset.y >= fmaxf(.0f, self.tableView.contentSize.height - self.tableView.frame.size.height) + 100 &&!self.dataLoadLock) //x是触发操作的阀值
    {
        self.dataLoadLock = YES;
        [self.upPullRefreshControl startAnimating];
        if([self upPullLoadData]){
            [self stopUpPullRefreshAnimating];
        }
        
    }
}
-(void)RefreshViewControlEventValueChanged
{
     NSLog(@"it's refresh.");
    if ([self downPullLoadData]) {
        [self stopDownPullRefreshAnimating];
    }
}
//停止上拉加载动画，在数据加载后调用
-(void)stopUpPullRefreshAnimating
{
    NSLog(@"停止上拉动画");
    _dataLoadLock=NO;
    [self.upPullRefreshControl stopAnimating];
}
//停止下拉刷新动画，在数据加载后调用
-(void)stopDownPullRefreshAnimating
{
     [self.refreshControl endRefreshing];
}

//用作子类覆盖的方法
-(BOOL)downPullLoadData
{
    return YES;
}

//用作子类覆盖的方法
-(BOOL)upPullLoadData
{
    return YES;
}

-(BOOL)isOrNotDataLoadLock:(int)pageNoParameter
{
    return (!self.dataLoadLock && pageNoParameter != 1);
}

@end
