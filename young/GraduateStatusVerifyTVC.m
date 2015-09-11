//
//  GraduateStatusVerifyTVC.m
//  young
//
//  Created by z Apple on 15/5/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "GraduateStatusVerifyTVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@interface GraduateStatusVerifyTVC()

@property NSString *graduateId;
@property UIView *myView;
@end

@implementation GraduateStatusVerifyTVC

- (IBAction)choosePhoto:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照",@"相册",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

}

- (IBAction)save:(id)sender {
    if (!self.graduatePhoto.currentBackgroundImage) {
        [PrimaryTools alert:@"请上传先上传毕业证再提交。"];
        return;
    }
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"] ,@"login_id" , nil];

    UIView* myView = [[UIView alloc] initWithFrame:self.view.frame];
    
    myView.backgroundColor =[UIColor grayColor];
    myView.alpha = 0.5;
    CGRect activityRect = CGRectMake(self.view.center.x,self.view.center.y,0 ,0);
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:activityRect];

    [iv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [iv setColor:[UIColor greenColor]];
    [iv startAnimating];
    self.myView = myView;
    [myView addSubview:iv];
    [self.navigationController.view addSubview:myView];
    
    
    
    [ZSyncURLConnection upload:@"file" filename:@"frontImage.png" mimeType:@"image/png" data:[NSData dataWithData:UIImagePNGRepresentation(self.graduatePhoto.currentBackgroundImage)] parmas:formParamter
                        strUrl:[UrlFactory createVerifyUploadFileUrl]
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                     NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileid"]) {
                             self.graduateId = [dateDict objectForKey:@"fileid"];
                             [self submit];
                         }
                     }else{
                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"毕业证上传失败。"];
                     }
                 }else{
                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"毕业证上传失败。"];
                 }
             }];
    
    
}

-(void)submit
{
    if (self.graduateId==nil) {
        return;
    }
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id",self.graduateId,@"byz1_fileid" , nil];
    
    NSLog(@"formParamter:%@",formParamter);
    [ZSyncURLConnection request:[UrlFactory createGraduateStatusVerifyUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"submitResult:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [PrimaryTools backLayer:self backNum:1];
            }else{
                self.graduateId = nil;
                [PrimaryTools alert:@"上传失败"];
            }
            [self.myView removeFromSuperview];
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
        [self.myView removeFromSuperview];
    }];
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
    
    [self.graduatePhoto setBackgroundImage:headImage forState:UIControlStateNormal];
    
    [NSData dataWithData:UIImagePNGRepresentation(headImage)];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.tableView.frame.size.width;
    
}

@end
