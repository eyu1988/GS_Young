//
//  AppDelegate.h
//  young
//
//  Created by z Apple on 15/3/16.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weixin/WXApi.h"
#import "libWeiboSDK/WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *loginUser;
@property (strong, nonatomic) NSString *pushToken;
@property (strong, nonatomic) UINavigationController *navController;
@property BOOL allowRotation;
@property(nonatomic,copy) NSArray *viewControllers;
@property (strong, nonatomic) NSString *wbtoken;

@end

