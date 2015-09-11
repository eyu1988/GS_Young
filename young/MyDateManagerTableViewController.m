//
//  MyDateManagerTableViewController.m
//  young
//
//  Created by z Apple on 15/3/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "MyDateManagerTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "NSUserDefaultsHandle.h"
#import "ZSyncURLConnection.h"
#import "GlobleLocalSession.h"
#import "UrlFactory.h"
#import "PrimaryTools.h"

@interface MyDateManagerTableViewController()

@property BOOL isNeedInitHeadImage;
@end


@implementation MyDateManagerTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.isNeedInitHeadImage = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self initMyInfo];
    
}

-(void)initMyInfo
{
    
    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys: [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"],@"login_id",nil];
    
    [ZSyncURLConnection request:[UrlFactory createGetUserInfoUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                [GlobleLocalSession setLoginUserInfo:[dict objectForKey:@"data"]];
                NSLog(@"dict:%@",dict);
               self.myInviteCode.text = [[dict objectForKey:@"data"] objectForKey:@"invite_code"];
            }else [self alert:@"获取个人信息失败,请重试！"];
            
        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    if(self.isNeedInitHeadImage){
        [PrimaryTools setHeadImage:self.headerButton userNo:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"user_no"]];
    }else{
         self.isNeedInitHeadImage = YES;
    }
    self.jobTypeLabel.text = @"";
    [[[GlobleLocalSession getLoginUserInfo] objectForKey:@"myMajor"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx==0)
            self.jobTypeLabel.text =[[obj objectForKey:@"columns"] objectForKey:@"mc"];
         else
            self.jobTypeLabel.text = [NSString stringWithFormat:@"%@,%@",self.jobTypeLabel.text,[[obj objectForKey:@"columns"] objectForKey:@"mc"]];
        
    }];
    [super viewWillAppear:YES];
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

    [self.headerButton setBackgroundImage:headImage forState:UIControlStateNormal];
    [self.headerButton setImage:headImage forState:UIControlStateNormal];

    NSData *fileData = [NSData dataWithData:UIImagePNGRepresentation(headImage)];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.isNeedInitHeadImage = NO;
    [self.tableView reloadData];
    [ZSyncURLConnection upload:@"file" filename:@"headImage.png" mimeType:@"image/png" data:fileData parmas:@{@"login_id" : [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"]  } strUrl:[UrlFactory createUploadHeadImageUrl] completionHandler:nil];
    
}

- (IBAction)changeImage:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照",@"相册",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}
-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}
@end


