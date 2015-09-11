//
//  BindPhoneVC.m
//  young
//
//  Created by z Apple on 15/4/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "BindPhoneVC.h"
#import "NSUserDefaultsHandle.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "PrimaryTools.h"

@implementation BindPhoneVC

- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    if(self.phoneNum.text.length==0){
        [self alert:@"请先输入手机号码"];
        return;
    }
    
    NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text,@"newPhone",
                       [NSUserDefaultsHandle getLoginId],@"login_id", nil];
    [ZSyncURLConnection request:[UrlFactory createSendBindPhoneCheckCode] requestParameter:p   completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [self disableSendButton:sender];
                [self alert:@"验证码发送成功,请耐心等待"];
            }else{
                [self alert:@"验证码发送失败,请重新发送"];
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


- (IBAction)bindClick:(id)sender {
    if(self.phoneNum.text.length==0)
        [self alert:@"手机号码不能为空"];
    else  if(self.checkCode.text.length==0){
        [self alert:@"验证码不能为空"];
    }else{
        NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text,@"newPhone",
                           self.checkCode.text,@"bindphone_code",
                           [NSUserDefaultsHandle getLoginId],@"login_id", nil];
        [ZSyncURLConnection request:[UrlFactory createBindPhoneUrl] requestParameter:p   completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                    [PrimaryTools backLayer:self backNum:1];

                    [self alert:@"绑定成功"];
                }else{
                    if([@"code_not_valid" isEqualToString:[result objectForKey:@"msg"]]){
                        [self alert:@"无效的验证码"];
                    }else [self alert:@"绑定失败"];
                }
            });
        } errorBlock:^(NSError *error) {
//            NSLog(@"error %@",error);
        }];
    }
}

-(void)disableSendButton:(JKCountDownButton*)sender
{
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
    }];
}

@end
