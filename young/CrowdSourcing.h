//
//  CrowdSourcing.h
//  young
//
//  Created by z Apple on 15/4/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrowdSourcing : NSObject
+(NSString*)getRequirementState:(NSDictionary*)dic;
+(NSString*)getRequirementBidState:(NSDictionary*)dic;
+(NSMutableDictionary*)createNetRequirementParamter;
@end
