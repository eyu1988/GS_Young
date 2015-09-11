//
//  BindCardVC.m
//  young
//
//  Created by z Apple on 15/7/2.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "BindCardVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import "JKCountDownButtonTools.h"
#import "ErrorMessageDictionary.h"

@interface BindCardVC ()

@end

@implementation BindCardVC

- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyBindZfbAndCardMessage ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                [self disableSendButton:sender];
                [JKCountDownButtonTools disableSendButton:sender];
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
    if(self.cardCode.text.length==0)
        [PrimaryTools alert:@"银行卡卡号不能为空"];
    else  if(self.checkCode.text.length==0){
        [PrimaryTools alert:@"验证码不能为空"];
    }else{
        
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id"
                                      ,self.cardCode.text,@"kahao"
                                      , nil];
        
        [ZSyncURLConnection request:[UrlFactory createCardCodeVerifyUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"cardcode verify  result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                    NSDictionary *dateDict =[result objectForKey:@"data"];
                    [self submit];
                }else{
                    [self getErrorMsg:[[result objectForKey:@"msg"] objectForKey:@"errorcode"]];
                    
                }
            });
        } errorBlock:^(NSError *error) {
                    NSLog(@"error %@",error);
        }];
     
    }
}

-(NSString*)getErrorMsg:(NSString *)errorKey
{
    NSDictionary *dicErrorKey = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"卡号无效",@"card_not_valid",
                                 @"卡号在系统中已存在",@"ka_is_exist",
                                 @"银行无效",@"bank_not_valid",
                                 @"卡号无效",@"CARD_BIN_NOT_MATCH", nil];
    if ([dicErrorKey objectForKey:errorKey]) {
        [PrimaryTools alert:[dicErrorKey objectForKey:errorKey]];
    }else
        [PrimaryTools alert:@"未知错误"];
    return [dicErrorKey objectForKey:errorKey];
}

-(void)submit
{
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id"
                                  ,self.cardCode.text,@"kahao"
                                  ,self.checkCode.text,@"code"
                                  , nil];

    [ZSyncURLConnection request:[UrlFactory createAddCardUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                NSDictionary *dateDict =[result objectForKey:@"data"];
                [PrimaryTools alert:@"绑定成功!"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{

                if ([[[result objectForKey:@"msg"] objectForKey:@"errorcode"] isEqualToString:@"need_zige"]) {
                    NSDictionary *d = [[result objectForKey:@"msg"] objectForKey:@"zige"];
                    [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        if([obj intValue]==0){
                            [PrimaryTools alert:[ErrorMessageDictionary qualificationErrorMessage:key]];
                        }
                    }];
                }else [PrimaryTools alert:@"绑定失败请重试!"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
