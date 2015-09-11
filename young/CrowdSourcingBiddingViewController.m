//
//  CrowdSourcingBiddingViewController.m
//  young
//
//  Created by z Apple on 15/3/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "CrowdSourcingBiddingViewController.h"
#import "GlobleLocalSession.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "DataFormatVerify.h"

@interface CrowdSourcingBiddingViewController()
@property (weak,nonatomic)NSString *code;
@end

@implementation CrowdSourcingBiddingViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createCode];
}

-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

- (IBAction)save:(id)sender {

    if (self.biderIntroduction.text.length==0) {
        [self alert:@"请填写竞争优势。"];
        return ;
    }else if (![DataFormatVerify isNumberString:self.money.text]) {
        [self alert:@"投标价格必须填写数字。"];
        return ;
    }else if (self.authCode.text.length==0) {
        [self alert:@"请输入验证码。"];
        return ;
    }else if (![self.authCode.text isEqualToString:self.code]) {
        [self alert:@"验证码错误，请确认后重新输入。"];
        return ;
    }


    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys: _requirementId,@"xuqiuId",self.money.text,@"zbbj",self.biderIntroduction.text,@"ys",[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id",nil];
    [ZSyncURLConnection request:[UrlFactory createBidUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.allDataDic = [dict objectForKey:@"data"];
                long index=[[self.navigationController viewControllers]indexOfObject:self];
                CrowdSourcingBiddingViewController *vc = [self.navigationController.viewControllers objectAtIndex:index-1];
                [self.navigationController popToViewController:vc animated:YES];
                
            }else{
                if ([[dict objectForKey:@"msg"] isEqualToString:@"user_not_identify"]) {
                    [self alert:@"抢单失败，您的账户还未认证,请在我的中心中进行实名认证后再抢单。"];
                }else if ([[dict objectForKey:@"msg"] isEqualToString:@"user_qiang_guo"]) {
                    [self alert:@"抢单失败，此单您已抢过。"];
                }else if ([[dict objectForKey:@"msg"] isEqualToString:@"xuqiu_isover"]) {
                    [self alert:@"抢单失败，此单已经被他人抢走。"];
                }else [self alert:@"抢单失败,请重试！"];
            }
        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
}



-(NSString*)loginName
{
    return [[GlobleLocalSession getLoginUserInfo] objectForKey:@"loginName" ];
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    if (self.biderIntroduction.text.length == 0) {
        _viewTextPlaceHolder.text=@"介绍一下自己的团队，提升中标率";
    }else{
        _viewTextPlaceHolder.text=@"";
    }
    
}

-(NSString*)getRandomNumber:(int)from to:(int)to

{
    return [[NSString alloc] initWithFormat:@"%u",(from + (arc4random() % (to-from + 1)))];
}
- (IBAction)clickAuthCode:(UIButton *)sender {
    [self createCode];
}

-(void) createCode
{
    NSString *codeTemp = [self getRandomNumber:1000 to:9999];
    self.code =codeTemp;
    [self.codeButton setTitle:codeTemp forState:UIControlStateNormal ];
}

@end
