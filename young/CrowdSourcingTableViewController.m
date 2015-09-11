//
//  CrowdSourcingTableViewController.m
//  young
//
//  Created by z Apple on 15/3/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "CrowdSourcingTableViewController.h"
#import "IndexCommonCell.h"
#import "NullHandler.h"
#import "CrowdSourcingViewDetailedController.h"
#import "AppDelegate.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "CrowdSourcing.h"
#import "ChooserTVC.h"
#import "PrimaryTools.h"
#import "SortTableViewController.h"
#import "RequireListCell.h"
#import "CrowdSourcingViewDetailedTVC.h"

@interface CrowdSourcingTableViewController()
@property (nonatomic) int  page;
@property (nonatomic) BOOL lock;
@property (copy,nonatomic) NSMutableArray *selectTime;


@end

@implementation CrowdSourcingTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    _lock = YES;
    self.searchBar.delegate =self;
    if (self.serviceTypeName) {
        [self.servicetypeButton setTitle:self.serviceTypeName forState:UIControlStateNormal];
    }
//    if(![self.navigationItem.title isEqualToString:@"搜索"])
//        [self initdata];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"selectTime:%@",self.selectTime);
//    [self.tableView reloadData];
    [self initdata];
    
}

-(void)initdata
{
    _page = 1;
    [self.searchParamter setObject:[NSString stringWithFormat:@"%d",(_page)] forKey:@"page"];
    [self searchData:self.searchParamter];
}

-(void)searchData:(NSMutableDictionary*)formParamter
{
    [self netWork:formParamter completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.crowdSourcingList = [NSMutableArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"xuqiuList"]];
                [self.tableView reloadData];
            }
        });
    }];
}


-(void)netWork:(NSMutableDictionary*)formparamter completeBlock:(CompleteBlock_t)compleBlock
{
    //let entryParamet into the formparamter
    [formparamter addEntriesFromDictionary:self.entryParamter];
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingListUrl]
               requestParameter:formparamter  completeBlock:compleBlock errorBlock:^(NSError *error) {
//        NSLog(@"error %@",error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"requireListCell";
    RequireListCell *indexCell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    [indexCell setCellValueFrom:self.crowdSourcingList[indexPath.row]];
    return indexCell;}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.crowdSourcingList count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y >= fmaxf(.0f, self.tableView.contentSize.height - self.tableView.frame.size.height) + 100 &&_lock) //x是触发操作的阀值
    {
        _lock=NO;
        [self runIndicator];
    }
}

-(void)runIndicator
{
    [self.upPullRefreshControl startAnimating];
    [self appendData];
    [self.tableView reloadData];
}

-(void) appendData
{
    if(_lock)return;
    NSMutableDictionary *subParamter = [[NSMutableDictionary alloc] init];

    if(self.searchParamter){
         [self.searchParamter setObject:[NSString stringWithFormat:@"%d",(++_page)] forKey:@"page"];
         subParamter =self.searchParamter;
    }else{
        [subParamter setObject:[NSString stringWithFormat:@"%d",(++_page)] forKey:@"page"];
    }
    [self netWork:subParamter completeBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                NSMutableArray *addArray = [[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]] objectForKey:@"xuqiuList" ];
                [self.crowdSourcingList addObjectsFromArray:addArray];
                if ([addArray count]==0) {
                    --self.page;
                }
                [self.upPullRefreshControl stopAnimating];
                [self.tableView reloadData];
                _lock = YES;
            }else --self.page;
            
        });
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"requirementDetail"]){
        CrowdSourcingViewDetailedTVC *c = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        c.requirementId =[self.crowdSourcingList[indexPath.row] objectForKey:@"id"];
//        c.listIndex = indexPath.row;
//        c.crowdSourcingList = self.crowdSourcingList;
        
    }else if([segue.identifier isEqualToString:@"chooseProjectState"]){
        ChooserTVC *c = [segue destinationViewController];
        [c initBlack:^{
            
            c.dataArray = @[@"没人抢",@"竞标中",@"实施中",@"已结束"];
            c.selectedTitle = self.projectStateButton.titleLabel.text;
        } submitBlack:^{
            if ([c.selectedArray count]!=0) {
                [self.entryParamter setObject:c.selectedArray[0] forKey:@"zht_mingcheng"];
                [self.projectStateButton setTitle:c.selectedArray[0] forState:UIControlStateNormal];
                [self initdata];
            }else{
                [self.projectStateButton setTitle:@"项目状态" forState:UIControlStateNormal];
            }
            [PrimaryTools backLayer:c backNum:1];
        }];
        
    }else if([segue.identifier isEqualToString:@"releaseTime"]){
        ChooserTVC *c = [segue destinationViewController];
        [c initBlack:^{
            c.dataArray = @[@"今天",@"昨天",@"三天内",@"一周内",@"一月内"];
            c.selectedTitle = self.releaseTimeButton.titleLabel.text;
            
        } submitBlack:^{
            if ([c.selectedArray count]!=0) {
                [self.entryParamter setObject:c.selectedArray[0] forKey:@"sjduan"];
                [self.releaseTimeButton setTitle:c.selectedArray[0] forState:UIControlStateNormal];
                [self initdata];
            }else{
                [self.releaseTimeButton setTitle:@"发布时间" forState:UIControlStateNormal];
            }
            [PrimaryTools backLayer:c backNum:1];
            
        }];
        
    }else if([segue.identifier isEqualToString:@"ChooseServiceType"]){
     SortTableViewController *c = [segue destinationViewController];
     c.navigationItem.title = @"选择服务分类";
        
    }
//
}

- (IBAction)downPullFresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [self initdata];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _page=1;
     self.searchParamter = [CrowdSourcing createNetRequirementParamter];
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length!=0) {
        [self.searchParamter setObject:[NSString stringWithFormat:@"%d",(_page)] forKey:@"page"];
        [self.searchParamter setObject:self.searchBar.text forKey:@"quan_wen_jian_suo"];
    }
    [self searchData:self.searchParamter];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    self.searchParamter = nil;
    [self initdata];
    [self.searchBar resignFirstResponder];

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton =YES;
}

-(NSMutableDictionary*)searchParamter
{
    if(!_searchParamter){
        _searchParamter = [CrowdSourcing createNetRequirementParamter];
        if([self.entryParamter objectForKey:@"login_id"]){
            [_searchParamter removeObjectForKey:@"xqzt_weifabu"];
        }
    }
    return _searchParamter;
}

- (NSMutableDictionary*)entryParamter
{
    if(!_entryParamter){
        _entryParamter = [[NSMutableDictionary alloc] init];
    }
    return _entryParamter;
}

@end
