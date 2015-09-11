//
//  DataFormatVerify.m
//  young
//
//  Created by z Apple on 15/5/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "DataFormatVerify.h"

@implementation DataFormatVerify

+(BOOL)isEmailString:(NSString*)string
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

+(BOOL)isNumberString:(NSString*)string
{
    NSString *regex = @"[0-9]*+\\.{0,1}[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

+(BOOL)isPhoneNumberString:(NSString*)string
{
    
    return YES;
}

@end
