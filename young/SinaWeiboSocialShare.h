//
//  SinaWeiboSocialShare.h
//  young
//
//  Created by z Apple on 15/6/5.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kRedirectURI    @"http://www.qingchunhao.com"
#import "libWeiboSDK/WeiboSDK.h"
@interface SinaWeiboSocialShare : NSObject

+(void)sendTextAndPicture:(NSString*)text pictureData:(NSData*)pictureData;
//+(void)sendShareMessage:(WBMessageObject *)message;
//+(WBMessageObject *)messageToShare:(NSString*)text pictureUrl:(NSString*)pictureUrl;

@end
