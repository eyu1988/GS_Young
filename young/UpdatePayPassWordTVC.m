//
//  UpdatePayPassWordTVC.m
//  young
//
//  Created by z Apple on 7/13/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "UpdatePayPassWordTVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "JKCountDownButtonTools.h"
#import "PrimaryTools.h"
#import "NullHandler.h"

@interface UpdatePayPassWordTVC ()

@end

@implementation UpdatePayPassWordTVC



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFirstSet) {
        [self.oldPwdCell setHidden:YES];
    }
    
}





- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createSendZfmmCheckCodeUrl]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)save:(id)sender {
    
    if(self.oldPassWordText.text.length==0&&self.oldPwdCell.isHidden == NO){
        [PrimaryTools alert:@"原密码不能为空"];
    }else if(self.currentPassWordText.text.length==0){
        [PrimaryTools alert:@"新密码不能为空"];
    }else if(self.verifyText.text.length==0){
        [PrimaryTools alert:@"再次确认新密码不能为空"];
    }else if(self.checkCodeText.text.length == 0){
        [PrimaryTools alert:@"验证码不能为空"];
    }else if(![self.currentPassWordText.text isEqualToString:self.verifyText.text]){
        [PrimaryTools alert:@"新密码与确认密码不一致，请修改后重试"];
    }else
    {
         NSString * loginName = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"ln"];
        
        NSLog(@"未加密的当前密码：%@",[NSString stringWithFormat:@"%@%@",loginName,self.currentPassWordText.text]);
        NSLog(@"已加密的当前密码：%@",[PrimaryTools md5HexDigest:
                              [NSString stringWithFormat:@"%@%@",loginName,self.currentPassWordText.text]
                              ]);
        NSMutableDictionary *formParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [GlobleLocalSession getLoginId],@"login_id" ,
                                      [PrimaryTools md5HexDigest:
                                       [NSString stringWithFormat:@"%@%@",loginName,self.currentPassWordText.text]
                                       ],@"qianbaoMima",
                                      [PrimaryTools md5HexDigest:
                                       [NSString stringWithFormat:@"%@%@",loginName,self.verifyText.text]
                                       ],@"qianbaoMimaqueren",
                                      self.checkCodeText.text,@"code",
                                      nil];
        
        if (![self.oldPwdCell isHidden]) {
            [formParameter setObject:[PrimaryTools md5HexDigest:[NSString stringWithFormat:@"%@%@",loginName,self.oldPassWordText.text]] forKey:@"old_qianbao_mima"];
        }
        
        [ZSyncURLConnection request:[UrlFactory createUpdateZfmmUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                    NSDictionary *dateDict =[result objectForKey:@"data"];
                    [PrimaryTools alert:@"支付密码设置成功！"];
                    [PrimaryTools backLayer:self backNum:1];
                }else{
                     [PrimaryTools alert:@"支付密码设置失败，请重试！"];
                }
            });
        } errorBlock:^(NSError *error) {
            //        NSLog(@"error %@",error);
        }];

        
    }
    
}
@end
