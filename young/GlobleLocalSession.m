//
//  Session.m
//  young
//
//  Created by z Apple on 15/3/31.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "GlobleLocalSession.h"
#import "AppDelegate.h"
#import "NSUserDefaultsHandle.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"



@implementation GlobleLocalSession
+(NSDictionary*)getAttribute:(NSString*)attrName
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([ @"userInfo" isEqualToString:attrName]) {
        return delegate.loginUser;
    }
    return nil;
}
+(NSDictionary*)getLoginUserInfo
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(!delegate.loginUser) return nil;
    return delegate.loginUser;
}
+(NSString*)getLoginId
{
    return [[self getLoginUserInfo] objectForKey:@"login_id"];
}
+ (BOOL)isLogin
{
    if ([self getLoginUserInfo]) {
        return YES;
    }else{
        return NO;
    }
}
+(void)setLoginUserInfo:(NSDictionary*)userInfo
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.loginUser= (NSMutableDictionary*)userInfo;
    
}

+(void)checkLoginState:(UIViewController *)vc
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(!delegate.loginUser){
                UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"MyCenterStoryboard" bundle:nil];
                [vc.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier:
                                                            @"Login"] animated:YES];
    }
}

+(NSString*)getPushToken
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return delegate.pushToken;
}


+(void)initUserInfoByNet:(void (^)(NSData *data)) handler
{
    
    if (![GlobleLocalSession getLoginId]) {
        return;
    }
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createGetUserInfoUrl]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [GlobleLocalSession setLoginUserInfo:[result objectForKey:@"data"]];
            }
            handler(data);
            
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}

+(NSMutableSet*)getGoodAtJobWorkType
{
    return [[self getLoginUserInfo] objectForKey:@"goodAtJobType"];
}

@end
