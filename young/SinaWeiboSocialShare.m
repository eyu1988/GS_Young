//
//  SinaWeiboSocialShare.m
//  young
//
//  Created by z Apple on 15/6/5.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "SinaWeiboSocialShare.h"
#import "AppDelegate.h"

@implementation SinaWeiboSocialShare

+(void)sendTextAndPicture:(NSString*)text pictureData:(NSData*)pictureData
{
    [self sendShareMessage:[self messageToShare:text pictureData:pictureData]];
}

+(void)sendShareMessage:(WBMessageObject *)message
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboQingchunhao",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];

}


+ (WBMessageObject *)messageToShare:(NSString*)text pictureData:(NSData*)pictureData
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(text, nil);
    WBImageObject *image = [WBImageObject object];
    image.imageData = pictureData;
    
    message.imageObject = image;
    return message;
}


@end
