//
//  LoginController.m
//  young
//
//  Created by z Apple on 15/3/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "NSUserDefaultsHandle.h"
#import "GlobleLocalSession.h"
#import "Message.h"

@implementation LoginController


-(void)viewDidLoad
{
    if(self.navigationController)
        [self.closeButton setHidden:YES];
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([GlobleLocalSession getLoginUserInfo]!=nil) {
        [PrimaryTools backLayer:self backNum:1];
    }
    
}

- (IBAction)colseMySelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)passwordFindBack:(UIButton *)sender {
}

- (IBAction)loginCheck:(id)sender {
    
    if(_loginName.text.length==0){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        
    }else if(_passWord.text.length==0){
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }else  if ([_loginName.text rangeOfString:@" "].length>0||[_passWord.text rangeOfString:@" "].length>0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不应该包含空格" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    else [self check];
}

-(void)check{

    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:self.loginName.text,@"loginname"
                             , nil];
    
    [ZSyncURLConnection request:[UrlFactory createValidateLoginNameUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *originlName =nil;
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                originlName = [[result objectForKey:@"data"] objectForKey:@"ln"];
                NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:originlName,@"phone"
                                              ,[PrimaryTools md5HexDigest:
                                                [NSString stringWithFormat:@"%@%@",originlName,self.passWord.text]
                                                ],@"pwd"
                                              ,[UIDevice currentDevice].identifierForVendor.UUIDString ,@"device_id"
                                              ,[PrimaryTools getIOSDeviceInfo],@"platform"
                                              ,[PrimaryTools getQchVersion],@"version"
                                              ,[GlobleLocalSession getPushToken ],@"push_token"
                                              , nil];
                
                [ZSyncURLConnection request:[UrlFactory createLoginUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"result:%@",result);
                        if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                            NSMutableDictionary *user =[result objectForKey:@"data"];
                            delegate.loginUser=user;
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            
                            [userDefaults setObject:[user objectForKey:@"login_id"] forKey:@"login_id"];
                             //back before layer
                            if(self.navigationController)  
                                [PrimaryTools backLayer:self backNum:1];
                            else
                                [self dismissViewControllerAnimated:YES completion:NULL];
                            [Message markUnreadMessageCount];
                            
                        }else if([[result objectForKey:@"msg"] isEqualToString:@"login_auth_error"]){
                            [self alert:@"用户名或密码错误"];
                        }else [self alert:@"登陆失败"];
                    });
                } errorBlock:^(NSError *error) {
//                    NSLog(@"error %@",error);
                }];
                
            }else{
                [self alert:@"用户名或密码错误"];
            }
        });
    } errorBlock:^(NSError *error) {
//        NSLog(@"error %@",error);
    }];

}

-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}
@end
