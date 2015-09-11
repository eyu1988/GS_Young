//
//  ZfbIndexTableViewCell.m
//  young
//
//  Created by z Apple on 15/7/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ZfbIndexTableViewCell.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"

@implementation ZfbIndexTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNotBindView
{
    [self.updateButton setHidden:YES];
    [self.relieveButton setHidden:YES];
    [self.zfbAccountField setHidden:YES];
    [self.zfbBindDate setHidden:YES];
    [self.addZfbAccount setHidden:NO];
    [self.bindDateTitle setHidden:YES];
    [self.accountTitle setHidden:YES];
    self.backgroundView = nil;
}

-(void)setAlreadyBindView
{
    [self.updateButton setHidden:NO];
    [self.relieveButton setHidden:NO];
    [self.zfbAccountField setHidden:NO];
    [self.zfbBindDate setHidden:NO];
    [self.zfbAccountField setEnabled:NO];
    [self.addZfbAccount setHidden:YES];
    [self.bindDateTitle setHidden:NO];
    [self.accountTitle setHidden:NO];
}

- (IBAction)relieveAction:(id)sender {
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定解除已绑定的支付宝账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter show];
    
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
        
        [ZSyncURLConnection request:[UrlFactory createDeleteZfbBindAccountUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                    NSDictionary *dateDict =[result objectForKey:@"data"];
                    [PrimaryTools alert:@"解除绑定成功！"];
                    [self setNotBindView];
                }else{
                    [PrimaryTools alert:@"解除绑定失败,请重试！"];
                }
            });
        } errorBlock:^(NSError *error) {
            //        NSLog(@"error %@",error);
        }];

    }
}

@end