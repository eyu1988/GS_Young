//
//  WeiXinSocialShare.m
//  young
//
//  Created by z Apple on 15/6/3.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "WeiXinSocialShare.h"

@implementation WeiXinSocialShare
+(void)sendLinkContent:(NSString*)title description:(NSString*) description image:(UIImage*)image url:(NSString*) url wxShareScene:(WXShareScene) wxShareScene
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    if (image) {
        [message setThumbImage:image];
    }else
        [message setThumbImage:[UIImage imageNamed:@"acquiesceheader.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
//    @"http://www.qingchunhao.com:9100/wxqch/onetag.do?weixinID=";
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    req.message = message;
    req.scene = wxShareScene;
    [WXApi sendReq:req];

}
@end
