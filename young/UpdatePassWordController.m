//
//  UpdatePassWordController.m
//  young
//
//  Created by z Apple on 15/3/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "UpdatePassWordController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@implementation UpdatePassWordController

-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

-(NSString*)createPassWordParameterByMd5:(NSString*)pwd{
    return [PrimaryTools md5HexDigest:
            [NSString stringWithFormat:@"%@%@",[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_name" ]
             ,pwd]];
}

- (IBAction)save:(id)sender {
    
//    self.oldPassWord
    if (self.oldPassWord.text.length==0) {
        [self alert:@"请输入原密码。"];
        return ;
    }else if (self.nowPassWord.text.length==0) {
        [self alert:@"请输入新密码。"];
        return ;
    }else if (self.confirmPassWord.text.length==0) {
        [self alert:@"请输入新密码确认。"];
        return ;
    }else if (![self.confirmPassWord.text isEqualToString:self.nowPassWord.text]) {
        [self alert:@"新密码与确认密码不匹配，请检查后重新输入。"];
        return ;
    }
    
    NSString * loginName = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"ln"];
//    NSLog(@"[GlobleLocalSession getLoginUserInfo]:%@",[GlobleLocalSession getLoginUserInfo]);
    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [PrimaryTools md5HexDigest:
                                   [NSString stringWithFormat:@"%@%@",loginName,self.oldPassWord.text]
                                   ] ,@"old"
                                  ,[PrimaryTools md5HexDigest:
                                    [NSString stringWithFormat:@"%@%@",loginName,self.nowPassWord.text]
                                    ],@"new"
                                  ,
                                  [PrimaryTools md5HexDigest:
                                   [NSString stringWithFormat:@"%@%@",loginName,self.confirmPassWord.text]
                                   ]
                                  ,@"confirm_new",[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id",nil];
    
    
    
    [ZSyncURLConnection request:[UrlFactory createUpdatePassWordUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
            
                long index=[[self.navigationController viewControllers]indexOfObject:self];
                UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:index-1];
                [self.navigationController popToViewController:vc animated:YES];
                
            }else{
                [self alert:@"修改密码失败!"];
            }

        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
}

@end
