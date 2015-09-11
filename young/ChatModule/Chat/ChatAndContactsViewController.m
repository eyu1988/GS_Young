//
//  ChatAndContactsViewController.m
//  young
//
//  Created by Lucas on 15/8/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ChatAndContactsViewController.h"
#import "GSBuddy.h"
#import "ChineseToPinyin.h"
#import "GSDefine.h"
#import "UrlFactory.h"
#import "ZSyncURLConnection.h"
#import "GlobleLocalSession.h"
#import "DataBaseManager.h"
#import "GSMegModel.h"
#import "PrimaryTools.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

#define THEMECOLOR [UIColor colorWithRed:0.30f green:0.64f blue:0.24f alpha:1.00f]
#define CELL_BACKGROUNDCOLOR [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]
#define TABLEVIEW_BACKGROUNDCOLOR [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f]
#define pageNumber  @"1"
#define pageSize @"10"

@interface ChatAndContactsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * chatDataSource;

@property (strong, nonatomic) NSMutableArray * contactsDataSource;

@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property  (nonatomic) int reqCurPage;

@end

@implementation ChatAndContactsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([GlobleLocalSession isLogin]) {
        [self chatTVHeaderRereshing];
        [self requestUserList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLayoutSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _chatListTV.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    _chatListTV.tableFooterView = [[UIView alloc] init];
    _chatListTV.dataSource = self;
    _chatListTV.delegate = self;
    _chatListTV.hidden = NO;
    [_chatListTV addHeaderWithTarget:self action:@selector(chatTVHeaderRereshing)];
    [_chatListTV addFooterWithTarget:self action:@selector(chatTVFooterRereshing)];

    
    _contactsTV.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    _contactsTV.tableFooterView = [[UIView alloc] init];
    _contactsTV.dataSource = self;
    _contactsTV.delegate = self;
    _contactsTV.hidden = YES;
    [_contactsTV addHeaderWithTarget:self action:@selector(requestUserList)];
    [_contactsTV addFooterWithCallback:^{
        NSLog(@"加载联系人列表");
        [self requestChatListData];
        [_contactsTV footerEndRefreshing];
    }];
    
    _chatDataSource = [[NSMutableArray alloc] init];
    _contactsDataSource = [[NSMutableArray alloc] init];
    _sectionTitles = [[NSMutableArray alloc] init];
    
    [_chatBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [_contactsBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    _leftUnderLine.backgroundColor = [UIColor orangeColor];
    _rightUnderLine.backgroundColor = [UIColor lightGrayColor];

    _chatBtn.selected = YES;
//    [_chatBtn setBackgroundColor:THEMECOLOR];
    _contactsBtn.selected = NO;
    
    [[DataBaseManager sharedDataBaseManager] createDataBase];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChat) name:@"refreshChat" object:nil];
    
    NSLog(@"chatTV: %f\n contactTV: %f", _chatListTV.frame.size.width, _contactsTV.frame.size.width);
}

- (void)refreshChat
{
    NSLog(@"聊天列表 - refreshChat");
    [self chatTVHeaderRereshing];
}

- (void)chatTVHeaderRereshing{
    self.reqCurPage = 1;
    [self requestChatListData];
}
- (void)chatTVFooterRereshing{
    self.reqCurPage ++;
    [self requestChatListData];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _chatListTV.layoutMargins = UIEdgeInsetsZero;
    [_chatListTV setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    
    _contactsTV.layoutMargins = UIEdgeInsetsZero;
    [_contactsTV setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    
//    [_contactsTV reloadData];
}

- (IBAction)btnChat:(id)sender
{
//    NSLog(@"会话列表");
    _chatBtn.selected = YES;
    _contactsBtn.selected = NO;
//    [_chatBtn setBackgroundColor:THEMECOLOR];
//    [_contactsBtn setBackgroundColor:[UIColor lightGrayColor]];
    _chatListTV.hidden = NO;
    _contactsTV.hidden = YES;
    _leftUnderLine.backgroundColor = [UIColor orangeColor];
    _rightUnderLine.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)btnContacts:(id)sender
{
//    NSLog(@"通讯录列表");
    _chatBtn.selected = NO;
    _contactsBtn.selected = YES;
//    [_contactsBtn setBackgroundColor:THEMECOLOR];
//    [_chatBtn setBackgroundColor:[UIColor lightGrayColor]];
    _chatListTV.hidden = YES;
    _contactsTV.hidden = NO;
    _leftUnderLine.backgroundColor = [UIColor lightGrayColor];
    _rightUnderLine.backgroundColor = [UIColor orangeColor];
}

#pragma mark - ChatListDataRequest
- (void)requestChatListData
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", nil];
//    NSLog(@"\nuser list:\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createChatListUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                      NSLog(@"\nchat list:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"会话用户列表 - 数据获取失败");
                          if (self.reqCurPage > 1 ) {
                              self.reqCurPage--;
                          }
                          [_chatListTV headerEndRefreshing];
                          [_chatListTV footerEndRefreshing];
                          return ;
                      }
                      
                      NSLog(@"会话用户列表 - 数据获取成功");
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSArray * list = [dataDict objectForKey:@"list"];
                      
                      if (self.reqCurPage == 1) {
                          [_chatDataSource removeAllObjects]; //重置数据源
                      }
            
                      for (NSDictionary * subDict in list) {
                          
                          GSBuddy * buddy = [[GSBuddy alloc] init];
                          buddy.username = [subDict objectForKey:@"nick_name"];
                          buddy.userNo = [subDict objectForKey:@"user_no"];
                          buddy.newestTime =  [subDict objectForKey:@"newest_time"];
                          buddy.unreadNum = [subDict objectForKey:@"unread_num"];
                          [_chatDataSource addObject:buddy];
//                          [_chatDataSource insertObject: buddy atIndex:0];
                          
                      }

                      [self requestMegListData];
                      
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [_chatListTV headerEndRefreshing];
                         [_chatListTV footerEndRefreshing];
                     }];
}

#pragma mark - MegListDataRequest
- (void)requestMegListData
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", [NSString stringWithFormat:@"%d",self.reqCurPage],@"pageNumber", nil];
//    NSLog(@"\nmeg list:\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createMegListUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"\nmeg list:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"新消息 - 数据获取失败");
                          [_chatListTV headerEndRefreshing];
                          [_chatListTV footerEndRefreshing];
                          [_chatListTV reloadData];
                          return ;
                      }
                      
                      NSLog(@"新消息 - 数据获取成功");
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSArray * list = [dataDict objectForKey:@"list"];
                      
                      NSMutableArray * news_ids = [[NSMutableArray alloc] init];
                      for (NSDictionary * subDict in list) {
                          
                          NSString * content = [subDict objectForKey:@"content"];
                          NSNumber * new_data = [subDict objectForKey:@"new_data"];
//                          NSString * receive_user_no = [subDict objectForKey:@"receive_user_no"];
                          NSString * send_user_no = [subDict objectForKey:@"send_user_no"];
                          NSString * time = [subDict objectForKey:@"time"];
                          NSString * news_sub_id = [subDict objectForKey:@"news_sub_id"];
                          
                          GSMegModel * mm = [[GSMegModel alloc] initWithUserName:@"receiver" andUserID:send_user_no andMegText:content andMegDate:time andAsReceiver:YES andIsRead:NO andIsNewData:[new_data intValue]];
                          
                          [news_ids addObject:news_sub_id];
                          
                          [[DataBaseManager sharedDataBaseManager] saveDataWithMegModel:mm];
                      }
                      
                      if ([news_ids count] > 0) {
                           [self requestHasReadWithIds:news_ids];
                      }
                      
                     
                      NSInteger allNum = [[DataBaseManager sharedDataBaseManager] getALLNumOfUnread];
                      
                      [UIApplication sharedApplication].applicationIconBadgeNumber = allNum;
                      
                      if (allNum!= 0) {
                          ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",allNum];
                      }
                      else{
                          ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = nil;
                      }

                      
                      [_chatListTV headerEndRefreshing];
                      [_chatListTV footerEndRefreshing];
                      [_chatListTV reloadData];
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"listLoadDone" object:nil];
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [_chatListTV headerEndRefreshing];
                         [_chatListTV footerEndRefreshing];
                     }];
    
}

#pragma mark - 设置已读请求
- (void)requestHasReadWithIds:(NSArray *)news_Ids
{
    NSMutableString * newsIdStr = [[NSMutableString alloc] init];
    for (int i = 0; i < news_Ids.count; i++) {
        [newsIdStr appendFormat:@"%@, ",news_Ids[i] ];
    }
    
//    NSLog(@"news ids str: %@", newsIdStr);
    
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", newsIdStr, @"news_sub_ids", nil];
//    NSLog(@"\nhas read:\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createHasReadUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                      NSLog(@"\nread list:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"设置已读消息 - 数据获取失败");
                          return ;
                      }
                      
                      NSLog(@"设置已读成功");
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                     }];

}

#pragma mark - 请求联系人列表
- (void)requestUserList
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", pageSize, @"pageSize", pageNumber,@"pageNumber", nil];
    //    NSLog(@"\nuser list:\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createListAttentUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"\nuser list:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"联系人列表 - 数据获取失败");
                          return ;
                      }
                      
                      NSLog(@"联系人列表 - 数据获取成功");
                      
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSArray * userAttent = [dataDict objectForKey:@"userAttent"];
                      
                      [self.contactsDataSource removeAllObjects];
                      NSMutableArray * contacts = [[NSMutableArray alloc] init];
                      for (NSDictionary * subDict in userAttent) {
                          GSBuddy * buddy = [[GSBuddy alloc] init];
                          buddy.username = [subDict objectForKey:@"user_name"];
                          buddy.userNo = [subDict objectForKey:@"buser_no"];
                          buddy.mobile_phone = [subDict objectForKey:@"mobile_phone"];
                          buddy.input_date = [subDict objectForKey:@"input_date"];
                          buddy.jibie = [subDict objectForKey:@"jibie"];
                          buddy.seller_hpl = [subDict objectForKey:@"seller_hpl"];
                          [contacts addObject:buddy];
                      }
                      
                      [self.contactsDataSource addObjectsFromArray:[self sortDataArray:contacts]];
                      
                      [_contactsTV headerEndRefreshing];
                      [_contactsTV reloadData];
                  }
                  errorBlock:^(NSError *error) {
                      NSLog(@"error %@",error);
                  }];

}

#pragma mark - 时间戳转时间字符串
- (NSString *)dateToStringWithTimeStamp:(NSString *)timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"]; //直接输出的话是机器码
    //或者是手动设置样式[formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _chatListTV) {
        return 1;
    }
    else if (tableView == _contactsTV)
    {
        return [self.contactsDataSource count] + 1;
    }
    else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chatListTV) {
//        NSLog(@"%ld", [_chatDataSource count]);
        return [self.chatDataSource count];
    }
    else if (tableView == _contactsTV)
    {
        if (section == 0) {
            return 2;
        }
        
        return [[self.contactsDataSource objectAtIndex:(section - 1)] count];
    }
    else{
        return 0;
    }
}

- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _chatListTV) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatListCell"];
        cell.backgroundColor = CELL_BACKGROUNDCOLOR;
        
        GSBuddy * buddy = [_chatDataSource objectAtIndex:indexPath.row];
        
        UIImageView * headIV = (UIImageView *)[cell viewWithTag:101];
        headIV.layer.cornerRadius = 5;
        headIV.clipsToBounds = YES;
        
        headIV.image = nil;
//        [PrimaryTools setHeadImage:headIV userNo:buddy.userNo];
        [PrimaryTools setHeadImageUseCache:headIV userNo:buddy.userNo];
        if (!headIV.image) {
            headIV.image = [UIImage imageNamed:@"acquiesceheader.png"];
        }
        
        UILabel * nameLabel = (UILabel *)[cell viewWithTag:102];
        nameLabel.text = buddy.username;
        
        UILabel * contentLabel = (UILabel *)[cell viewWithTag:103];
        UILabel * timeLabel = (UILabel *)[cell viewWithTag:104];
        
        GSMegModel * mm = [[DataBaseManager sharedDataBaseManager] getReceiverLastDataWithUserID:buddy.userNo];
        
        if (mm) {
            contentLabel.text = [self filterHTML: mm.megText];
            timeLabel.text = [self dateToStringWithTimeStamp:buddy.newestTime];
        }
        else{
            contentLabel.text = @"让我们开始聊天吧";
            timeLabel.text = @"";
        }

        
        UIImageView * redIV = (UIImageView *)[cell viewWithTag:105];
        NSInteger unreadNum = [[DataBaseManager sharedDataBaseManager] getNumOfUnreadWithUserID:buddy.userNo];
        
        [[cell viewWithTag:106] removeFromSuperview]; //清理label
        if (unreadNum) {
            redIV.hidden = NO;
           
            UILabel * numLabel = [[UILabel alloc] initWithFrame:redIV.frame];
            if ([buddy.unreadNum intValue]<100) {
                numLabel.text = [NSString stringWithFormat:@"%ld", (long)unreadNum];
            }
            else{
                numLabel.text = @"99+";
            }
            
            numLabel.font = [UIFont systemFontOfSize:14];
            numLabel.textColor = [UIColor whiteColor];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.tag = 106;
            [cell addSubview:numLabel];
        }
        else{
            redIV.hidden = YES;
        }
        
        cell.layoutMargins = UIEdgeInsetsZero;
        
        return cell;
    }
    else if (tableView == _contactsTV)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell"];
        cell.backgroundColor = CELL_BACKGROUNDCOLOR;
        cell.layoutMargins = UIEdgeInsetsZero;
        
        UIImageView * headIV = (UIImageView *)[cell viewWithTag:201];
        UILabel * nameLabel = (UILabel *)[cell viewWithTag:202];
        UIView * jibieView = (UIView *)[cell viewWithTag:203];
        UIView * starView = (UIView *)[cell viewWithTag:204];
        UILabel * percentageLabel = (UILabel *)[cell viewWithTag:205];
        UILabel * phoneLabel = (UILabel *)[cell viewWithTag:206];
        
        //清理
        headIV.image = nil;
        nameLabel.text = @"";
        percentageLabel.text = @"";
        for (UIView * view in jibieView.subviews) {
            [view removeFromSuperview];
        }

        for (UIView * view in starView.subviews) {
            [view removeFromSuperview];
        }
        percentageLabel.text = @"";
        phoneLabel.text = @"";
        
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                headIV.image = [UIImage imageNamed:@"newFriends"];
                nameLabel.text = @"申请与通知";
            }
            else if (indexPath.row == 1) {
                headIV.image = [UIImage imageNamed:@"groupPrivateHeader"];
                nameLabel.text = @"通讯助手";
            }
        }
        else{
            
            GSBuddy * buddy = [[self.contactsDataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
            

             [PrimaryTools setHeadImageUseCache:headIV userNo:buddy.userNo];
            if (!headIV.image) {
                headIV.image = [UIImage imageNamed:@"acquiesceheader.png"];
            }
            
            headIV.layer.cornerRadius = 5;
            headIV.clipsToBounds = YES;
            
            nameLabel.text = buddy.username;
            
            
            NSInteger  num = [[buddy.jibie substringFromIndex:((NSString *)buddy.jibie).length-1] intValue];
        
            jibieView.frame = CGRectMake(jibieView.frame.origin.x, jibieView.frame.origin.y, 13.f * num, jibieView.frame.size.height);
            UIImageView * jbIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:buddy.jibie]];
            jbIV.frame = jibieView.bounds;
            [jibieView addSubview:jbIV];
            
            
            for (int i = 0; i < 5; i++) {
                UIImageView * starIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_none"]];
                starIV.frame = CGRectMake(starView.frame.size.width/5*i, 0, starView.frame.size.width/5, starView.frame.size.height);
                [starView addSubview:starIV];
            }
            
            UIView * clipView = [[UIView alloc] initWithFrame:starView.bounds];
            for (int i = 0; i < 5; i++) {
                UIImageView * starIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_full"]];
                starIV.frame = CGRectMake(clipView.frame.size.width/5*i, 0, clipView.frame.size.width/5, clipView.frame.size.height);
                [clipView addSubview:starIV];
            }
            
            CGFloat clipWidth = starView.frame.size.width * [buddy.seller_hpl floatValue] / 100.f;
            clipView.frame = CGRectMake(0, 0, clipWidth, clipView.frame.size.height);
            clipView.clipsToBounds = YES;
            [starView addSubview:clipView];

            percentageLabel.text = [NSString stringWithFormat:@"(%@%%)", buddy.seller_hpl];
            phoneLabel.text = [NSString stringWithFormat:@"联系电话: %@",buddy.mobile_phone];
            
        }
        return cell;
    }
    
    else{
        NSLog(@"ERROR");
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _contactsTV) {
        if (section == 0 || [[self.contactsDataSource objectAtIndex:(section - 1)] count] == 0)
        {
            return 0;
        }
        else{
            return 22;
        }
   }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _contactsTV) {
        if (section == 0 || [[self.contactsDataSource objectAtIndex:(section - 1)] count] == 0)
        {
            return nil;
        }
        else{
            return [NSString stringWithFormat:@"    %@", [self.sectionTitles objectAtIndex:(section - 1)]];
        }
    }
    return nil;
}

//不好使
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _contactsTV && indexPath.section != 0) {
            return UITableViewCellEditingStyleDelete;
    }
    else if(tableView == _chatListTV ){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _chatListTV) {
        [self performSegueWithIdentifier:@"chatListSegue" sender:indexPath];
    }
    else if (tableView==_contactsTV && indexPath.section != 0) {
        [self performSegueWithIdentifier:@"contactsSegue" sender:indexPath];
    }
}

#pragma mark - segue传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"注: 对方为receiver, 登录用户为sender");
    
    if ([segue.identifier isEqualToString:@"chatListSegue"]) {
        
        id nextPage = segue.destinationViewController;
        
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        GSBuddy * buddy = [_chatDataSource objectAtIndex:indexPath.row];
        [nextPage setValue:buddy.username forKey:@"receiverName"];
        [nextPage setValue:buddy.userNo forKey:@"receiverID"];
    }
    else if ([segue.identifier isEqualToString:@"contactsSegue"]) {
        
        id nextPage = segue.destinationViewController;
        
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        GSBuddy * buddy = [[self.contactsDataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        [nextPage setValue:buddy.username forKey:@"receiverName"];
        [nextPage setValue:buddy.userNo forKey:@"receiverID"];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

#pragma mark - 通讯录排序

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    //    for (NSString * title in self.sectionTitles) {
    //        NSLog(@"title:%@",title);
    //    }
    
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (GSBuddy * buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString * firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.username];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(GSBuddy *obj1, GSBuddy *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
