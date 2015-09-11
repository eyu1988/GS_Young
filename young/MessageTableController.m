//
//  MessageTableController.m
//  young
//
//  Created by z Apple on 15/3/24.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "MessageTableController.h"
#import <CoreData/NSFetchedResultsController.h>
#import "AppDelegate.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "MessageCell.h"
#import "MessageDetailVC.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import "Message.h"

@interface MessageTableController ()
@property (nonatomic) int  page;
@property (nonatomic) BOOL lock;
@end

@implementation MessageTableController

- (void) viewDidLoad{

    _lock = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage:)
                                                 name:@"clearMessage" object:nil];
    [self initdata];
    [super viewDidLoad];
}
- (void)clearMessage:(NSNotification *)aNotification
{
    self.messages =[[NSMutableArray alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([GlobleLocalSession getLoginUserInfo]==nil){
        self.messages =[[NSMutableArray alloc] init];
        [self.tableView reloadData];
    }else if([self.messages count]==0){
        [self initdata];
    }
}

-(void)initdata
{
    _page = 1;
    [self searchData:[[NSMutableDictionary alloc] init]];
}

-(void)searchData:(NSMutableDictionary*)formParamter
{

    if([GlobleLocalSession getLoginUserInfo]==nil){
        self.messages =[[NSMutableArray alloc] init];
        [self.tableView reloadData];
        [GlobleLocalSession checkLoginState:self];
        return;
    }
    
    [self netWork:formParamter completeBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.messages = [NSMutableArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"list"]];
                [self.tableView reloadData];
            }
            
        });
    }];
}


-(void)netWork:(NSMutableDictionary*)formparamter completeBlock:(CompleteBlock_t)compleBlock
{
    NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];
    [formparamter setObject:loginId forKey:@"login_id"];

    [ZSyncURLConnection request:[UrlFactory createMessageListUrl] requestParameter:formparamter  completeBlock:compleBlock errorBlock:^(NSError *error) {
//        NSLog(@"error %@",error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *noMessageCellid = @"sessionnomessageCellidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 100.0f)];
            noMsgLabel.text = @"暂无消息";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    
    static NSString *SimpleTableIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  SimpleTableIdentifier];
    NSDictionary *dict =  self.messages[indexPath.row];
    cell.senderName.text=[dict objectForKey:@"sender_user_name"];
    cell.messageTitle.text=[dict objectForKey:@"title"];
    cell.sendTime.text = [dict objectForKey:@"create_time"];
    
    if ([[dict objectForKey:@"is_read"] intValue]==0) {
         cell.redTag.image = [UIImage imageNamed:@"bpush_message_prompt.png"];
        
    }else{
         cell.redTag.image =nil;
    }
    
    [PrimaryTools setHeadImage:cell.headImage userNo:[dict objectForKey:@"sender_user_no"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([self.messages count]==0) {
        return 1;
    }
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
}

-(void) appendData
{
    if(_lock)return;
    NSMutableDictionary *subParamter = [[NSMutableDictionary alloc] init];
    
    [subParamter setObject:[NSString stringWithFormat:@"%d",(++_page)] forKey:@"page"];
    [self netWork:subParamter completeBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                NSMutableArray *addArray = [[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]] objectForKey:@"list" ];
//                NSLog(@"addArray:%@",addArray);
                [self.messages addObjectsFromArray:addArray];
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


- (IBAction)downPullFresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [self initdata];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count==0) {
        return;
    }
    MessageCell *mCell =  (MessageCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"ChatStoryboard" bundle:nil];
    MessageDetailVC *cv =[mainStoryboard   instantiateViewControllerWithIdentifier:@"MessageDetailVC"];
    NSDictionary *dict =  self.messages[indexPath.row];
    cv.messageDic = dict;
    cv.messageId = [dict objectForKey:@"id"];
    [self reduceUnreadNum:mCell];
   
    [mCell.redTag setHidden:YES];
    [self.navigationController pushViewController:cv animated:YES];
    
}

-(void)reduceUnreadNum:(MessageCell *)cell
{
    if (![cell.redTag isHidden]) {
        long num =[UIApplication sharedApplication].applicationIconBadgeNumber -1;
        if(num >= 0 ){
            [UIApplication sharedApplication].applicationIconBadgeNumber = num;
            ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",num];
        }
    }
}

@end
