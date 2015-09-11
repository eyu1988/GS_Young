//
//  DataBaseManager.m
//  young
//
//  Created by Lucas on 15/8/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "DataBaseManager.h"
#import "GSMegModel.h"
#import "FMDatabase.h"
#import "GlobleLocalSession.h"
#import "GSDefine.h"
#import "FMDatabaseAdditions.h"

#define DATA_BASE_NAME  @"user_chat_db"
#define TABLE_NAME [GlobleLocalSession getLoginId]

#define ID @"id"
#define RECEIVER_NAME @"receiver_name"
#define RECEIVER_ID @"receiver_id"
#define TIME_STAMP @"time_stamp"
#define MESSAGE @"message"
#define SEND_BY_RECEIVER @"send_by_receiver"
#define IS_READ @"is_read"
#define IS_NEW_DATA @"is_new_data"
#define news_sub_id


#define NUM_PER_PAGE 10


@implementation DataBaseManager

#pragma mark - 单例
static DataBaseManager * _dataBaseManager;
+ (instancetype)sharedDataBaseManager
{
    if (!_dataBaseManager) {
        _dataBaseManager = [[DataBaseManager alloc] init];
    }
    return _dataBaseManager;
}

#pragma mark - 创建登录用户的数据库列表
- (void)createDataBase
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能建数据库!");
        return;
    }
    
    NSLog(@"打开数据库的当前用户id: %@", [GlobleLocalSession getLoginId]);
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER,'%@' INTEGER,'%@' INTEGER)",TABLE_NAME,ID,RECEIVER_NAME, RECEIVER_ID, TIME_STAMP, MESSAGE, SEND_BY_RECEIVER, IS_READ, IS_NEW_DATA];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        
        [db close];
    }
}

#pragma mark - 逐条保存数据模型中的数据到当前用户的数据列表中
- (void)saveDataWithMegModel:(GSMegModel *)mm
{
    
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能存储数据!");
        return;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {

        NSString * newStr = [self htmlEntityEncode:mm.megText];
        
        NSString *insertSql= [NSString stringWithFormat:
                            @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                              TABLE_NAME, RECEIVER_NAME, RECEIVER_ID, MESSAGE, TIME_STAMP, SEND_BY_RECEIVER,IS_READ, IS_NEW_DATA, mm.userName, mm.userID, newStr, mm.megDate,[NSNumber numberWithBool:mm.isReceiver], [NSNumber numberWithBool:mm.isRead], [NSNumber numberWithBool:mm.isNewData]];
        
        BOOL res = [db executeUpdate:insertSql];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];
        
    }
    
/*     浏览数据列表
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:
                              @"SELECT * FROM '%@' ",TABLE_NAME];
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                int Id = [rs intForColumn:ID];
                NSString * name = [rs stringForColumn:RECEIVER_NAME];
                NSString * userId = [rs stringForColumn:RECEIVER_ID];
                NSString * date = [rs stringForColumn:TIME_STAMP];
                NSString * message = [rs stringForColumn:MESSAGE];
                NSString *isReceiver = [rs stringForColumn:SEND_BY_RECEIVER];
                NSLog(@"\nid = %d\nname = %@\nuserId = %@\ndate = %@\nmessage = %@\nisReceiver= %@", Id, name, userId, date, message, isReceiver);
            }
            [db close];
        }
  */
}

#pragma mark - 按页读取相应对话者的聊天记录数据
- (NSMutableArray *)getDataWithUserID:(NSString *)userID andPage:(int)page
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能读取数据!");
        return nil;
    }
    
    NSLog(@"提取id号为%@的数据列表", userID);
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM '%@' WHERE %@ = %@ ORDER BY %@ ASC",TABLE_NAME, RECEIVER_ID, userID,TIME_STAMP];
        FMResultSet * rs = [db executeQuery:sql];
        
        int totalNum = 0;
        while ([rs next]) {
            totalNum ++;
        }
        
        int indexNum = (totalNum - NUM_PER_PAGE * page) > 0 ? (totalNum - NUM_PER_PAGE * page) : 0 ;
        NSMutableArray * dataSource = [[NSMutableArray alloc] init];
        
        int i = 0;
        rs = [db executeQuery:sql]; //将指针位置重置
        
        while ([rs next]) {
            
            if (i >= indexNum) {
                NSString * name = [rs stringForColumn:RECEIVER_NAME];
                NSString * userId = [rs stringForColumn:RECEIVER_ID];
                NSString * date = [rs stringForColumn:TIME_STAMP];
                NSString * message = [self htmlEntityDecode:[rs stringForColumn:MESSAGE]];
                NSString * isReceiver = [rs stringForColumn:SEND_BY_RECEIVER];
                NSString * isRead = [rs stringForColumn:IS_READ];
                NSString * isNewData = [rs stringForColumn:IS_NEW_DATA];
                
                GSMegModel * mm = [[GSMegModel alloc] initWithUserName:name andUserID:userId andMegText:message andMegDate:date andAsReceiver:[isReceiver intValue] andIsRead:[isRead intValue] andIsNewData:[isNewData intValue]];
                [dataSource addObject:mm];
                NSLog(@"%@", mm.megText);
            }
            else{
                i++;
            }
        }
        
        [db close];
        
        NSLog(@"total: %d     indexNum: %d", totalNum,indexNum);
        return dataSource;
    }
    
    NSLog(@"error");
    return nil;
}

- (GSMegModel *)getReceiverLastDataWithUserID:(NSString *)userID
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能读取数据!");
        return nil;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM '%@' WHERE %@ = %@ AND %@ = 1 ORDER BY %@ DESC",TABLE_NAME, RECEIVER_ID, userID, SEND_BY_RECEIVER, TIME_STAMP];
        FMResultSet * rs = [db executeQuery:sql];
        
        GSMegModel * mm;


        if ([rs next]) {
            NSString * name = [rs stringForColumn:RECEIVER_NAME];
            NSString * userId = [rs stringForColumn:RECEIVER_ID];
            NSString * date = [rs stringForColumn:TIME_STAMP];
            NSString * message = [self htmlEntityDecode:[rs stringForColumn:MESSAGE]];
            NSString *isReceiver = [rs stringForColumn:SEND_BY_RECEIVER];
            NSString * isRead = [rs stringForColumn:IS_READ];
            NSString * isNewData = [rs stringForColumn:IS_NEW_DATA];
            
            mm = [[GSMegModel alloc] initWithUserName:name andUserID:userId andMegText:message andMegDate:date andAsReceiver:[isReceiver intValue] andIsRead:[isRead intValue] andIsNewData:[isNewData intValue]];
            
//            NSLog(@"提取id号为%@的数据列表, 获取最新一条: %@", userID, message);
        }
        else{
//            NSLog(@"提取id号为%@的数据列表, 无最新一条", userID);
        }
        
        [db close];
        
        return mm;
    }
    
    return nil;
}

- (NSInteger)getNumOfUnreadWithUserID:(NSString *)userID
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能读取数据!");
        return 0;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT count(*) FROM '%@' WHERE %@ = %@ AND %@ = 0",TABLE_NAME, RECEIVER_ID, userID, IS_READ];
   
        NSUInteger count = [db intForQuery:sql];
        
//        NSLog(@"提取id号为%@的数据列表, 获取未读消息数:%ld", userID, count);
        
        [db close];
        return count;
    }
    
    return 0;
}

- (NSInteger)getALLNumOfUnread
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能读取数据!");
        return 0;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT count(*) FROM '%@' WHERE %@ = 0",TABLE_NAME, IS_READ];
        
        NSUInteger count = [db intForQuery:sql];
        
        //        NSLog(@"提取id号为%@的数据列表, 获取未读消息数:%ld", userID, count);
        
        [db close];
        return count;
    }
    
    return 0;
}

- (void)readAllDataFromUserID:(NSString *)userID
{
    if (![GlobleLocalSession isLogin]) {
        NSLog(@"未登录, 不能修改数据!");
        return;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",[self docPath],DATA_BASE_NAME]];
    
    if ([db open]) {
        NSString *sql= [NSString stringWithFormat:
                              @"UPDATE '%@' SET %@ = 1 where %@ = 0",
                              TABLE_NAME, IS_READ, IS_READ];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }

        [db close];
    }
}

#pragma mark - 富文本处理
- (NSString *)htmlEntityEncode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;" ];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    NSLog(@"str: %@", string);
    return string;
}

- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

#pragma mark - 获取沙盒中文档目录
- (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
