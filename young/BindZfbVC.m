//
//  BindZfbVC.m
//  young
//
//  Created by z Apple on 15/7/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "BindZfbVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@interface BindZfbVC ()

@end

@implementation BindZfbVC

- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];

    [ZSyncURLConnection request:[UrlFactory createMyBindZfbAndCardMessage ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [self disableSendButton:sender];
                [PrimaryTools alert:@"验证码发送成功,请耐心等待"];
            }else{
                [PrimaryTools alert:@"验证码发送失败,请重新发送"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

    
}

- (IBAction)bindClick:(id)sender {
    if(self.zfbAccount.text.length==0)
        [PrimaryTools alert:@"支付宝账号不能为空"];
    else  if(self.checkCode.text.length==0){
        [PrimaryTools alert:@"验证码不能为空"];
    }else{
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id"
                                      ,self.zfbAccount.text,@"zhifubao"
                                      ,self.checkCode.text,@"code"
                                      , nil];
        
        [ZSyncURLConnection request:[UrlFactory createBindZfbUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                    NSDictionary *dateDict =[result objectForKey:@"data"];
                    [PrimaryTools alert:@"绑定成功!"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [PrimaryTools alert:@"绑定失败请重试!"];
                }
            });
        } errorBlock:^(NSError *error) {
            //        NSLog(@"error %@",error);
        }];

    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
