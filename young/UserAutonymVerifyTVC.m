//
//  UserAutonymVerifyTVC.m
//  young
//
//  Created by z Apple on 15/5/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "UserAutonymVerifyTVC.h"
#import "AVCamViewController.h"
#import "PrimaryTools.h"
#import "GlobleLocalSession.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"

@interface UserAutonymVerifyTVC()

@property (weak, nonatomic) UIButton *currentlyButton;
@property AVCamViewController *avc;
@property NSString *frontId;
@property NSString *backId;
@property UIView *myView;

@end


@implementation UserAutonymVerifyTVC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.avc.image) {
        [self.currentlyButton setBackgroundImage:self.avc.image forState:UIControlStateNormal];
    }
}


- (IBAction)chooseImage:(UIButton *)sender {
    
    self.currentlyButton = sender;
    self.avc = [[AVCamViewController alloc] initWithNibName:@"CameraCard" bundle:nil];
    
    [self presentViewController:self.avc animated:YES completion:NULL];

}

- (IBAction)save:(id)sender {
    
    if (self.autonym.text.length==0) {
        [PrimaryTools alert:@"请填写真实姓名"];
        return;
    }
    if (!self.frontButton.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传身份证正面照片"];
        return;
    }
    if (!self.backButton.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传身份证背面照片"];
        return;
    }
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"] ,@"login_id" , nil];

    UIView* myView = [[UIView alloc] initWithFrame:self.view.frame];
    
    myView.backgroundColor =[UIColor grayColor];
    myView.alpha = 0.5;
    CGRect activityRect = CGRectMake(self.view.center.x,self.view.center.y,0 ,0);
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:activityRect];
    
//    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [iv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [iv setColor:[UIColor greenColor]];
    [iv startAnimating];
    self.myView = myView;
    [myView addSubview:iv];
    [self.navigationController.view addSubview:myView];

//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//          [myView removeFromSuperview];
//    });
   
   [ZSyncURLConnection upload:@"file" filename:@"frontImage.png" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.frontButton.currentBackgroundImage)] parmas:formParamter
                        strUrl:[UrlFactory createVerifyUploadFileUrl]
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                     NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileid"]) {
                             self.frontId = [dateDict objectForKey:@"fileid"];
                             [self submit];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"身份证正面图片上传失败。"];
                     }
                 }else{
                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"身份证正面图片上传失败。"];
                 }
             }];
    
    [ZSyncURLConnection upload:@"file" filename:@"backImage.png" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.backButton.currentBackgroundImage)] parmas:formParamter
                        strUrl:[UrlFactory createVerifyUploadFileUrl]
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                     NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileid"]) {
                             self.backId = [dateDict objectForKey:@"fileid"];
                             [self submit];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"身份证背面图片上传失败。"];
                     }
                 }else{
                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"身份证背面图片上传失败。"];
                 }
             }];
//
    
}


-(void)submit
{
    if (self.backId==nil||self.frontId==nil) {
        return;
    }
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id",self.frontId,@"sfz1_fileid" ,self.backId,@"sfz2_fileid",self.autonym.text,@"xingming" , nil];
    
   
    [ZSyncURLConnection request:[UrlFactory createAutonymVerifyUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"submitResult:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [PrimaryTools backLayer:self backNum:1];
            }else{
                self.frontId = nil;
                self.backId = nil;
                [PrimaryTools alert:@"上传失败"];
            }
            [self.myView removeFromSuperview];
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
        [self.myView removeFromSuperview];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0){
        return self.tableView.frame.size.width/1.5;
    }
    return 46;
}


@end
