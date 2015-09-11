//
//  NSUserDefaultsHandle.h
//  young
//
//  Created by z Apple on 15/4/4.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSUserDefaultsHandle : NSObject
+(void)setHeadImage:(id)targetView;
+(UIImage*)getHeadImage;
+(NSString*)getLoginId;
+(void)clearNSUserDefaults;
@end
