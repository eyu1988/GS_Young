//
//  WeiXinSocialShare.h
//  young
//
//  Created by z Apple on 15/6/3.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weixin/WXApi.h"

typedef NS_ENUM(NSUInteger, WXShareScene) {
        WXShareSceneSession  = 0,        /**< 聊天界面    */
        WXShareSceneTimeline = 1,        /**< 朋友圈      */
        WXShareSceneFavorite = 2,        /**< 收藏       */
};


@interface WeiXinSocialShare : NSObject
+(void)sendLinkContent:(NSString*)title description:(NSString*) description image:(UIImage*)image url:(NSString*) url wxShareScene:(WXShareScene) wxShareScene;
@end
