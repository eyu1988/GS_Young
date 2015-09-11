//
//  Session.h
//  young
//
//  Created by z Apple on 15/3/31.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobleLocalSession : NSObject
+(NSDictionary*)getAttribute:(NSString*)attrName;
+(NSDictionary*)getLoginUserInfo;
+(void)checkLoginState:(UIViewController *)vc;
+(void)setLoginUserInfo:(NSDictionary*)userInfo;
+(NSString*)getPushToken;
+(void)initUserInfoByNet:(void (^)(NSData *data)) handler;
+(NSString*)getLoginId;
+(NSMutableSet*)getGoodAtJobWorkType;
+ (BOOL)isLogin;
@end
