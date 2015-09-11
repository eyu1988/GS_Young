//
//  NullHandler.h
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexCommonCell.h"
#if !defined(NS_REQUIRES_NIL_TERMINATION)
#if TARGET_OS_WIN32
#define NS_REQUIRES_NIL_TERMINATION
#else
#if defined(__APPLE_CC__) && (__APPLE_CC__ >= 5549)
#define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel(0,1)))
#else
#define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel))
#endif
#endif
#endif
@interface NullHandler : NSObject
+(NSString*)ifEqualNilReturnNullStringElseReturnOriginalString:(NSString*)str;

+(BOOL)NotNil:(NSString*)supplier AssignTo:(NSString*)receiver;
+(BOOL)isNullOrNilOrNSNull:(id)obj;
+(BOOL)NotNil:(NSString*)supplier AssignToUiReceiver:(UIView*)uiReceiver;
+(NSString*)connectNotNullString:(NSString*)str1,...NS_REQUIRES_NIL_TERMINATION;
+(BOOL)ifLengthEqualZeroThenAlert:(UIView*)uiView alertMsg:(NSString*)msg;
@end
