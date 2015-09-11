//
//  ErrorMessageDictionary.h
//  young
//
//  Created by z Apple on 7/7/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMessageDictionary : NSObject
+(NSString*)qualificationErrorMessage:(NSString*)errorKey;
+(NSString*)postponeErrorMsg:(NSString *)errorKey;
@end
