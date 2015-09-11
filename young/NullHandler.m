//
//  NullHandler.m
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "NullHandler.h"
#import "PrimaryTools.h"

@implementation NullHandler

+(BOOL)isNullOrNilOrNSNull:(id)obj
{
    return (obj==nil||obj==NULL||[obj isKindOfClass:[NSNull class]]);
}

+(BOOL)ifLengthEqualZeroThenAlert:(UIView*)uiView alertMsg:(NSString*)msg
{
    if(!uiView){
        [PrimaryTools alert:msg];
        return YES;
    }else if ([uiView isKindOfClass:[UIButton class]]) {
        if (((UIButton*)uiView).titleLabel.text.length==0) {
            [PrimaryTools alert:msg];
             return YES;
        }
       
    }else if ([uiView isKindOfClass:[UITextField class]]) {
        if (((UITextField*)uiView).text.length==0) {
            [PrimaryTools alert:msg];
             return YES;
        }
 
    }else if ([uiView isKindOfClass:[UILabel class]]) {
        if (((UILabel*)uiView).text.length==0) {
            [PrimaryTools alert:msg];
             return YES;
        }
    }  else @throw @"type is error，unkown type.";
    return NO;
}



+(NSString*)ifEqualNilReturnNullStringElseReturnOriginalString:(NSString*)str
{
    if(nil==str
       ||[NSNull null]==(NSNull *)str
       ||NULL==str)
        return @"";
    else
        return str;
}
//需要先判断receiver的属性是否是强指针类型
+(BOOL)NotNil:(NSString*)supplier AssignTo:(NSString*)receiver
{
    if(receiver)
        receiver = [self ifEqualNilReturnNullStringElseReturnOriginalString : supplier];
    NSLog(@"%@",receiver);
    return YES;
}

+(BOOL)NotNil:(NSString*)supplier AssignToUiReceiver:(UIView*)uiReceiver
{
    if(!uiReceiver)return YES;
    supplier = [self ifEqualNilReturnNullStringElseReturnOriginalString: supplier];
    if ([uiReceiver isKindOfClass:[UIButton class]]) {
        [(UIButton*)uiReceiver setTitle:supplier forState:UIControlStateNormal];
    }else if ([uiReceiver isKindOfClass:[UITextField class]]) {
        ((UITextField*)uiReceiver).text = supplier;
    }else if ([uiReceiver isKindOfClass:[UILabel class]]) {
        ((UILabel*)uiReceiver).text = supplier;
    }  else @throw @"type is error，unkown type.";

    return YES;
}

+(NSString*)connectNotNullString:(NSString*)str1,...NS_REQUIRES_NIL_TERMINATION
{
    NSString* eachArg;
    NSString* strResult = [self ifEqualNilReturnNullStringElseReturnOriginalString:str1];
    
    va_list argList;
    if (str1)
    {
        va_start(argList, str1);
        while ((eachArg = va_arg(argList, NSString*))!=nil){
            strResult = [NSString stringWithFormat:@"%@%@",strResult,[self ifEqualNilReturnNullStringElseReturnOriginalString:eachArg]];
        }
        
        va_end(argList);
    }
//    NSLog(@"strResult:%@",strResult);
    return strResult;
}


@end
