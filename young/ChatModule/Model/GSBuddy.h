//
//  GSBuddy.h
//  ChatDemo
//
//  Created by Lucas on 15/8/5.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMegModel.h"

@interface GSBuddy : NSObject

/*!
 @property
 @brief 好友的username
 */
//@property (copy, nonatomic, readonly)NSString *username;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * userNo;
@property (nonatomic, strong) NSString * newestTime;
@property (nonatomic, strong) NSNumber * unreadNum;
@property (nonatomic, strong) NSNumber * seller_hpl;
@property (nonatomic, strong) NSString * mobile_phone;
@property (nonatomic, strong) NSString * jibie;
@property (nonatomic, strong) NSString * input_date;

//@property (nonatomic, strong) NSMutableArray * megArray;

/*!
 @property
 @brief 好友列表(由EMBuddy对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *buddyList;

/*!
 @property
 @brief 好友黑名单列表(由EMBuddy对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *blockedList;

/*!
 @method
 @brief 通过username初始化一个EMBuddy对象
 @param username 好友的username
 @discussion
 @result EMBuddy实例对象
 */
+ (instancetype)buddyWithUsername:(NSString *)username;

@end
