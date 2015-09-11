//
//  NSUserDefaultsHandle.m
//  young
//
//  Created by z Apple on 15/4/4.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "NSUserDefaultsHandle.h"

@implementation NSUserDefaultsHandle
+(void)setHeadImage:(id)targetView
{
    if ([targetView isKindOfClass:[UIImageView class]]) {
        ((UIImageView*)targetView).image=[NSUserDefaultsHandle getHeadImage];
    }else if([targetView isKindOfClass:[UIButton class]]) {
        [((UIButton*)targetView) setImage:[NSUserDefaultsHandle getHeadImage] forState:UIControlStateNormal];
    }
}



+(UIImage*)getHeadImage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefaults dataForKey:@"myHeadImage"];
    UIImage *contactImage;
  
    contactImage = imageData ?
                    [UIImage imageWithData:imageData]
                        :[UIImage imageNamed:@"acquiesceheader.png"];
    return contactImage;
}

+(NSString*)getLoginId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"login_id"];
}

+(void)clearNSUserDefaults{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

}


@end
