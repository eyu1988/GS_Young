//
//  PassWordFindBackTVC.m
//  young
//
//  Created by z Apple on 15/5/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "PassWordFindBackTVC.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"


@interface PassWordFindBackTVC ()
@property (strong,nonatomic)NSString *ln;
@end

@implementation PassWordFindBackTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    if(self.phoneNumber.text.length==0){
        [PrimaryTools alert:@"请先输入手机号码"];
        return;
    }
    
    NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumber.text,@"ln", nil];
    [ZSyncURLConnection request:[UrlFactory createReSetPasswordSms] requestParameter:p   completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
           
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
               
                [JKCountDownButtonTools disableSendButton:sender];
                self.ln =[[result objectForKey:@"data"] objectForKey:@"ln"];
                [PrimaryTools alert:@"验证码发送成功,请耐心等待"];
            }else{
                if([[result objectForKey:@"data"] isEqualToString:@"nophone"]){
                    [PrimaryTools alert:@"您输入的手机号码，并未在青春号注册，请核实。"];
                }else [PrimaryTools alert:@"验证码发送失败,请重新发送"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
}

- (IBAction)save:(id)sender {
    
    if(self.phoneNumber.text.length==0)
        [PrimaryTools alert:@"手机号码不能为空"];
    else  if(self.checkCode.text.length==0){
        [PrimaryTools alert:@"验证码不能为空"];
    }else{
        NSLog(@"pwd before make secrite:%@",[NSString stringWithFormat:@"%@%@",self.ln,self.passWord.text]);
        
        NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumber.text,@"ln",
                           self.checkCode.text,@"code",[PrimaryTools md5HexDigest:[NSString stringWithFormat:@"%@%@",self.ln,self.passWord.text]]
                           ,@"pwd", nil];
        [ZSyncURLConnection request:[UrlFactory createReSetMyPwd] requestParameter:p   completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                    [PrimaryTools backLayer:self backNum:1];
                    [PrimaryTools alert:@"重设密码成功"];
                }else{
                    if([@"code_not_valid" isEqualToString:[result objectForKey:@"msg"]]){
                        [PrimaryTools alert:@"无效的验证码"];
                    }else [PrimaryTools alert:@"重设密码失败"];
                }
            });
        } errorBlock:^(NSError *error) {
            //            NSLog(@"error %@",error);
        }];
    }

    
}

@end
