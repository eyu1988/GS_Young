//
//  JsonHandler.h
//  young
//
//  Created by z Apple on 15/4/10.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHandler : NSObject
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithObject:(id) object;
@end
