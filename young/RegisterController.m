//
//  RegisterController.m
//  young
//
//  Created by z Apple on 15/4/9.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "RegisterController.h"
#import "ZSyncURLConnection.h"
#import "PrimaryTools.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "AppDelegate.h"

@interface RegisterController ()
@property BOOL isChoose;
@property BOOL isUnderway;
@property NSString *oringalName;
@end

@implementation RegisterController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isChoose = YES;
    self.isUnderway = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

- (IBAction)sendCheckCode:(JKCountDownButton*)sender {
    
    if(self.phoneNumberField.text.length==0){
        [self alert:@"请先填写手机号码，再点击发送验证码"];
    }else{
        NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumberField.text,@"phone", nil];
        [ZSyncURLConnection request:[UrlFactory createSendCheckCode] requestParameter:p  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                    [self disableSendButton:sender];
                    [self alert:@"验证码发送成功,请耐心等待"];
                    self.oringalName = [[result objectForKey:@"data"] objectForKey:@"ln"];
                }else{
                    if([[result objectForKey:@"msg"] isEqualToString:@"not_unique_phone"]){
                        [self alert:@"您的手机已经注册过，无法再次注册"];

                    }else [self alert:@"验证码发送失败,请重新发送"];
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

- (IBAction)clickCheckedButton:(UIButton *)sender {

    if(self.isChoose)
    {
        [sender setImage:nil forState:UIControlStateNormal];
        self.isChoose = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"orange_ok.png"] forState:UIControlStateNormal];
        self.isChoose = YES;
    }
  
}

- (IBAction)clickWhetherShowButton:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"显示"]) {
        [sender setTitle:@"隐藏" forState:UIControlStateNormal];
        [self.passWordField setSecureTextEntry:NO];
    }else{
        [sender setTitle:@"显示" forState:UIControlStateNormal];
        [self.passWordField setSecureTextEntry:YES];
    }
}

- (IBAction)clickRegisterButton:(id)sender {
    if (self.isUnderway) {
        NSLog(@"正在注册！");
        return;
    }
    if(self.phoneNumberField.text.length==0){
       
        [self alert:@"电话号码不允许为空"];
        //必须为数字
    }else if(self.checkCodeField.text.length==0){
         [self alert:@"验证码不允许为空"];
        //必须为六位数字
        
    }else if(self.passWordField.text.length==0){
        //必须在6-12位之间
        [self alert:@"密码不允许为空"];
    }else{
        self.isUnderway = YES;
        NSMutableDictionary *formParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.phoneNumberField.text,@"phone"
                                      ,[UIDevice currentDevice].identifierForVendor.UUIDString ,@"device_id"
                                      ,[PrimaryTools getIOSDeviceInfo],@"platform"
                                      ,[GlobleLocalSession getPushToken ],@"push_token"
                                      ,[PrimaryTools getQchVersion],@"version"
                                      ,self.oringalName,@"ln"
                                      ,[PrimaryTools md5HexDigest:
                                            [NSString stringWithFormat:@"%@%@",self.oringalName,self.passWordField.text]
                                       ],@"pwd"
                                      ,self.checkCodeField.text,@"code"
                                      , nil];
        if(self.inviteCode.text.length!=0){
            [formParamter setObject:self.inviteCode.text forKey:@"other_invite_code"];
        }
        
        [ZSyncURLConnection request:[UrlFactory createRegisterUrl] requestParameter:formParamter  completeBlock:^(NSData *data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                    AppDelegate *delegate = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
                    NSMutableDictionary *user =[result objectForKey:@"data"];
                    delegate.loginUser = user;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[user objectForKey:@"login_id"] forKey:@"login_id"];
                   
                    [self alert:@"恭喜您,已注册成功"];
                     [PrimaryTools backLayer:self backNum:2];//back two layer to my center.
                }else{
                    
                    [self alert:@"对不起，注册失败"];
                }
                self.isUnderway = NO;
            });
        } errorBlock:^(NSError *error) {
             self.isUnderway = NO;
             [self alert:@"对不起，注册失败"];
//            NSLog(@"error %@",error);
        }];
    }
}
@end
