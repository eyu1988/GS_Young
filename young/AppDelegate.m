//
//  AppDelegate.m
//  young
//
//  Created by z Apple on 15/3/16.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "AppDelegate.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "NSUserDefaultsHandle.h"
#import "MessageTableController.h"
#import "Message.h"
#import "DataFormatVerify.h"
#import "HomeTabBarViewController.h"
#import "HomeTableController.h"
#import "weixin/WXApi.h"
#import "libWeiboSDK/WeiboSDK.h"
#import "GpsTool.h"

#define SINA_WEIBO_APPID @"305120301"       //新浪微博APPID
#define WEIXIN_APPID @"wxd07b3055bad0411d"     //微信APPID

@interface AppDelegate ()
@property (nonatomic) BOOL isLaunchedByNotification;
@end

@implementation AppDelegate

@synthesize wbtoken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification){
        _isLaunchedByNotification = YES;
        
        NSDictionary * aps = [remoteNotification objectForKey:@"aps"];
        NSString * alert = [aps objectForKey:@"alert"];
        NSLog(@"%@", alert);
        
        NSArray * megArray = [alert componentsSeparatedByString:@"："];
        NSLog(@"%@", megArray[0]);
        if ([megArray[0] isEqualToString:@"消息"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController * tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
            [tabViewController setSelectedIndex:2];
        }
    }
    else{
        _isLaunchedByNotification = NO;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)]; //--deprecations
//        [[UIApplication sharedApplication] registerForRemoteNotifications];//instead
        
    }
    [Message markUnreadMessageCount];
    [self autoLoginByNSUserDefaults];
    [WXApi registerApp:WEIXIN_APPID];       //注册微信ID
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SINA_WEIBO_APPID];//注册新浪微博ID
    
    GpsTool *gt = [[GpsTool alloc] init];
    [gt locationManager];
    
    return YES;
}

-(void)autoLoginByNSUserDefaults
{
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[NSUserDefaultsHandle getLoginId],@"login_id" , nil];
    [ZSyncURLConnection request:[UrlFactory createLoginUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSMutableDictionary *user =[result objectForKey:@"data"];
                delegate.loginUser=user;
               [Message markUnreadMessageCount];

            }
        });
    } errorBlock:^(NSError *error) {
//        NSLog(@"error %@",error);
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];

    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];

    self.pushToken = token;
    NSLog(@"My token is:%@", token);
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSString *error_str = [NSString stringWithFormat: @"%@", error];
//    NSLog(@"Failed to get token, error:%@", error_str);
}

//在应用在前台时收到消息调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
    NSDictionary * aps = [userInfo objectForKey:@"aps"];
    NSString * alert = [aps objectForKey:@"alert"];
    NSLog(@"%@", alert);

    NSArray * megArray = [alert componentsSeparatedByString:@"："];
    NSLog(@"%@", megArray[0]);
    if ([megArray[0] isEqualToString:@"消息"]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChat" object:nil];
        
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
       return self.allowRotation ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

#pragma mark -weixin&weibo
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSRange range =[[url description] rangeOfString:@"platformId=wechat"];
    if (range.length) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSRange range =[[url description] rangeOfString:@"platformId=wechat"];
    if (range.length) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
}

#pragma mark -WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
