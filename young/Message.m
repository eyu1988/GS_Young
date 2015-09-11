//
//  Message.m
//  young
//
//  Created by z Apple on 15/5/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "Message.h"
#import "UrlFactory.h"
#import "ZSyncURLConnection.h"
#import "NSUserDefaultsHandle.h"
#import "AppDelegate.h"
#import "PrimaryTools.h"
#import "GlobleLocalSession.h"
#import "DataBaseManager.h"

@implementation Message


+(void)markUnreadMessageCount
{
    if ([GlobleLocalSession getLoginId]==nil) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =0;
        ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue =nil;
        return;
    }
//    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    NSInteger allNum = [[DataBaseManager sharedDataBaseManager] getALLNumOfUnread];
    if (allNum != 0) {
        ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",allNum];
    }
    else{
        ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = nil;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = allNum;
    
    /*
    [ZSyncURLConnection request:[UrlFactory createUnreadMessageCountUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"result:%@",result);
                NSNumber *unreadCount=[[result objectForKey:@"data" ] objectForKey:@"unReadCount"];
            [UIApplication sharedApplication].applicationIconBadgeNumber = [unreadCount intValue];
            
            ([PrimaryTools getMessageViewController]).tabBarItem.badgeValue = [unreadCount intValue]==0 ? nil : [unreadCount stringValue];
            
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
  */


}

@end
