//
//  HomeTableController.m
//  young
//
//  Created by z Apple on 15/3/18.
//  Copyright (c) 2015年 z. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HomeTableController.h"
#import "IndexCommonCell.h"
#import "CrowdSourcingTableViewController.h"
#import "AppDelegate.h"
#import "NullHandler.h"
#import "CrowdSourcingViewDetailedController.h"
#import "CrowdSourcing.h"
#import "UrlFactory.h"
#import "ZSyncURLConnection.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import "Message.h"
#import "ColorfulRectAndUILabelTableHeader.h"
#import "AutoLayoutByScale.h"
#import "RequireListCell.h"
#import "CrowdSourcingViewDetailedTVC.h"


#define MAINMENU_SECTION_NO 0

@interface HomeTableController ()
@property (nonatomic,copy)NSArray *adImages;
@end

@implementation HomeTableController

bool mark = true;
- (void) viewDidLoad{
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.navController =  self.navigationController;
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [PrimaryTools versionUpdateCheck:self];
    [self loadAdPic];}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initdata];
}

#pragma mark -initData
-(void)initdata
{
    
    NSMutableDictionary *parameter =[CrowdSourcing createNetRequirementParamter] ;
    [parameter setValue:@"redianxuqiu" forKey:@"1"];
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingListUrl] requestParameter:parameter  completeBlock:^(NSData *data) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.crowdSourcingList = [NSMutableArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"xuqiuList"]];
            }
            [self.tableView reloadData];
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
   
    
}

- (void)loadAdPic{
    [ZSyncURLConnection request:[UrlFactory createAdPicLoadUrl ]  requestParameter: nil  completeBlock:^(NSData *data) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                self.adImages = [dataDict objectForKey:@"imgs"];
                if ([self.adImages count]!=0) {
                    imageArray = [[NSMutableArray alloc] init];
                    
                    [self.adImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.adImages[idx] objectForKey:@"img"]]]];
                        [imageArray addObject:image];
                    }];
                    [self configScrollView];
                }
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}

#pragma mark -tableSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return section==0 ? 1 : [self.crowdSourcingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.section==1){

       static NSString *SimpleTableIdentifier = @"requireListCell";
       RequireListCell *indexCell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
        [indexCell setCellValueFrom:self.crowdSourcingList[indexPath.row]];
        return indexCell;

    }else{
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:
                    @"CrowdMenu"];
        }
    }
      return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==MAINMENU_SECTION_NO ? 0 : 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ColorfulRectAndUILabelTableHeader *th = nil;
    if (section!=MAINMENU_SECTION_NO) {
        th =  (ColorfulRectAndUILabelTableHeader*)[PrimaryTools getFristObjectFromNibByNibName:@"ColorfulRectAndUILabelTableHeader"];
        th.titleLabel.text = @"热点需求";
        [th setRetract:10];
    }
    return th;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(indexPath.section==MAINMENU_SECTION_NO){
        return 100;
    }
    return 60;
}

- (IBAction)downPullRefresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [self initdata];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark -scrollView
-(void)configScrollView
{
    
     //初始化UIScrollView，设置相关属性，均可在storyBoard中设置
    self.scrollView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.delegate=self;
    UIImageView *firstView=[[UIImageView alloc] initWithImage:[imageArray lastObject]];
    CGFloat Width=self.scrollView.frame.size.width;
    CGFloat Height=self.scrollView.frame.size.height;
    firstView.frame=CGRectMake(0, 0, Width, Height);
    [self.scrollView addSubview:firstView];
    //set the last as the first
    
    for (int i=0; i<[imageArray count]; i++) {
        UIImageView *subViews=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        subViews.frame=CGRectMake(Width*(i+1), 0, Width, Height);
        [self.scrollView addSubview: subViews];
    }
    
    UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    lastView.frame=CGRectMake(Width*(imageArray.count+1), 0, Width, Height);
    [self.scrollView addSubview:lastView];
    //set the first as the last
    
    [self.scrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    [self.view addSubview:self.scrollView];
    [self.scrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    //show the real first image,not the first in the scrollView
    
    self.pageControl.numberOfPages=imageArray.count;

    self.pageControl.currentPage=0;
    self.pageControl.enabled=YES;
    
    CGRect pageControlFrame =self.scrollView.frame;
    pageControlFrame =CGRectMake(pageControlFrame.origin.x + (pageControlFrame.size.width/2)-(self.pageControl.frame.size.width/2)
                                  , pageControlFrame.origin.y + (pageControlFrame.size.height-self.pageControl.frame.size.height-5)
                                       , self.pageControl.frame.size.width, self.pageControl.frame.size.height);
    self.pageControl.frame =pageControlFrame;
    
    
    [self.view addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
}


#pragma UIScrollView delegate
-(void)scrollToNextPage:(id)sender
{
    int pageNum=(int)self.pageControl.currentPage;
    CGSize viewSize=self.scrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];//animated mean：It's a switch whether need slide animation.
    pageNum++;
    if (pageNum==imageArray.count) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.scrollView scrollRectToVisible:newRect animated:NO];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.scrollView.frame.size.width;
    int currentPage=floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        self.pageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        self.pageControl.currentPage=0;
    }
    self.pageControl.currentPage=currentPage-1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.scrollView.frame.size.width;
    CGFloat pageHeigth=self.scrollView.frame.size.height;
    int currentPage=floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    
    if (currentPage==0) {
        [self.scrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=imageArray.count-1;
       
        return;
    }else  if(currentPage==[imageArray count]+1){
        [self.scrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=0;
               return;
    }
    self.pageControl.currentPage=currentPage-1;
}

- (IBAction)pageTurn:(UIPageControl *)sender {
    long pageNum=self.pageControl.currentPage;
    CGSize viewSize=self.scrollView.frame.size;
    [self.scrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];

    [myTimer invalidate];
}

#pragma mark -segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if([segue.identifier isEqualToString:@"myRequirementList"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.entryParamter = [[NSMutableDictionary alloc] init];
        [c.entryParamter setObject:@"1" forKey:@"my"];
        NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];
        [c.entryParamter setObject:loginId forKey:@"login_id"];
        c.navigationItem.title = @"我的需求";
    }else if([segue.identifier isEqualToString:@"myBidList"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.entryParamter = [[NSMutableDictionary alloc] init];
        [c.entryParamter setObject:@"1" forKey:@"my_qiang"];
        NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];
        [c.entryParamter setObject:loginId forKey:@"login_id"];
        c.navigationItem.title = @"我的抢单";
    }else if([segue.identifier isEqualToString:@"requirementDetail"]){
        CrowdSourcingViewDetailedController *c = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        c.requirementId =[self.crowdSourcingList[indexPath.row] objectForKey:@"id"];
    }else if([segue.identifier isEqualToString:@"requirementDetailNew"]){
        CrowdSourcingViewDetailedTVC *c = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        c.requirementId =[self.crowdSourcingList[indexPath.row] objectForKey:@"id"];
    }else if([segue.identifier isEqualToString:@"searchCrowdSourcing"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.navigationItem.title = @"搜索";
    }else if([segue.identifier isEqualToString:@"quickGrabCrowdSourcing"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.entryParamter = [[NSMutableDictionary alloc] init];
        [c.entryParamter setObject:@"1`" forKey:@"xqzt_keyiqiang"];
        c.navigationItem.title = @"快来抢";
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
