//
//  EnterpriseStatusVerifyTVC.m
//  young
//
//  Created by z Apple on 15/5/20.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "EnterpriseStatusVerifyTVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@interface EnterpriseStatusVerifyTVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property NSString *businessLicensePhotoId;
@property NSString *businessLicenseWithCommonSealPhotoId;
@property NSString *organizationCodeCertificatePhotoId;
@property (weak, nonatomic) UIButton *currentlyButton;
@property UIView *myView;

@end

@implementation EnterpriseStatusVerifyTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


- (IBAction)save:(id)sender {
    if (self.companyName.text.length==0) {
        [PrimaryTools alert:@"请填写公司全称。"];
        return;
    }else if (!self.businessLicensePhotoButton.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传营业执照照片。"];
        return;
    }else  if (!self.businessLicenseWithCommonSealPhotoButton.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传加盖公章的营业执照照片。"];
        return;
    }else  if (!self.organizationCodeCertificatePhotoButton.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传组织机构代码证的照片。"];
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
    
    
    
    [ZSyncURLConnection upload:@"file" filename:@"businessLicense" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.businessLicensePhotoButton.currentBackgroundImage)] parmas:formParamter
                        strUrl:[UrlFactory createVerifyUploadFileUrl]
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                     NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileid"]) {
                             self.businessLicensePhotoId = [dateDict objectForKey:@"fileid"];
                             [self submit];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"营业执照上传失败。"];
                     }
                 }else{
                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"营业执照上传失败。"];
                 }
             }];
    
        [ZSyncURLConnection upload:@"file" filename:@"businessLicenseWithCommonSeal.png" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.businessLicenseWithCommonSealPhotoButton.currentBackgroundImage)] parmas:formParamter
                            strUrl:[UrlFactory createVerifyUploadFileUrl]
                 completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                     if (data) {
                         NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                         NSLog(@"result:%@",result);
                         if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                             NSDictionary *dateDict =[result objectForKey:@"data"];
                             if ([dateDict objectForKey:@"fileid"]) {
                                 self.businessLicenseWithCommonSealPhotoId = [dateDict objectForKey:@"fileid"];
                                 [self submit];
                             }
                         }else{
                             [self.myView removeFromSuperview];
                             [PrimaryTools alert:@"加盖公章的营业执照上传失败。"];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"加盖公章的营业执照上传失败。"];
                     }
                 }];

    [ZSyncURLConnection upload:@"file" filename:@"organizationCodeCertificate.png" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.organizationCodeCertificatePhotoButton.currentBackgroundImage)] parmas:formParamter
                        strUrl:[UrlFactory createVerifyUploadFileUrl]
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                     NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileid"]) {
                             self.organizationCodeCertificatePhotoId = [dateDict objectForKey:@"fileid"];
                             [self submit];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"组织结构代码证的照片上传失败。"];
                     }
                 }else{
                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"组织结构代码证的照片上传失败。"];
                 }
             }];

    
}

-(void)submit
{
    if (self.businessLicensePhotoId==nil
        ||self.businessLicenseWithCommonSealPhotoId==nil
        ||self.organizationCodeCertificatePhotoId==nil) {
        return;
    }
    NSMutableDictionary *formParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id"
                                         ,self.companyName.text,@"gongsimingcheng"
                                         ,self.businessLicensePhotoId ,@"yingyezhizhao_fileid",
        self.businessLicenseWithCommonSealPhotoId ,@"yingyezhizhao_jiagongzhang_fileid",
        self.organizationCodeCertificatePhotoId ,@"zuzhijigoudaimazheng_fileid",
                                         nil];

    
    NSLog(@"formParamter:%@",formParamter);
    [ZSyncURLConnection request:[UrlFactory createEnterpriseStatusVerifyUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"submitResult:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [PrimaryTools backLayer:self backNum:1];
            }else{
                self.businessLicensePhotoId = nil;
                self.businessLicenseWithCommonSealPhotoId = nil;
                self.organizationCodeCertificatePhotoId = nil;
                [PrimaryTools alert:@"上传失败"];
            }
            [self.myView removeFromSuperview];
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
        [self.myView removeFromSuperview];
    }];
}


- (IBAction)choosePhoto:(UIButton *)sender {
    
    self.currentlyButton = sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照",@"相册",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex<2){
        UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
        uiipc.delegate = self;
        uiipc.mediaTypes=@[(NSString*)kUTTypeImage];
        uiipc.allowsEditing=YES;
        if (buttonIndex == 0) {;
            uiipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1) {
            uiipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:uiipc animated:YES completion:NULL];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *headImage =info[UIImagePickerControllerEditedImage];
    
    if(!headImage)
        headImage=info[UIImagePickerControllerOriginalImage];
    
    [self.currentlyButton setBackgroundImage:headImage forState:UIControlStateNormal];
    
    [NSData dataWithData:UIImagePNGRepresentation(headImage)];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0){
        return self.tableView.frame.size.width;
    }
    return 46;
}

@end
