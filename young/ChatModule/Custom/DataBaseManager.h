//
//  DataBaseManager.h
//  young
//
//  Created by Lucas on 15/8/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSMegModel;

@interface DataBaseManager : NSObject

+ (instancetype)sharedDataBaseManager;

- (void)createDataBase;

- (void)saveDataWithMegModel:(GSMegModel *)mm;

- (NSMutableArray *)getDataWithUserID:(NSString *)userID andPage:(int)page;

- (GSMegModel *)getReceiverLastDataWithUserID:(NSString *)userID;

- (NSInteger)getNumOfUnreadWithUserID:(NSString *)userID;

- (NSInteger)getALLNumOfUnread;

- (void)readAllDataFromUserID:(NSString *)userID;

@end
