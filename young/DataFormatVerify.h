//
//  DataFormatVerify.h
//  young
//
//  Created by z Apple on 15/5/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFormatVerify : NSObject
+(BOOL)isNumberString:(NSString*)string;
+(BOOL)isEmailString:(NSString*)string;
+(BOOL)isPhoneNumberString:(NSString*)string;
//+(BOOL)isMobliePhoneNumberString:(NSString*)string;


@end
