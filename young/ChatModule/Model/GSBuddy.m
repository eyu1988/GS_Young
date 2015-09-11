//
//  GSBuddy.m
//  ChatDemo
//
//  Created by Lucas on 15/8/5.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#import "GSBuddy.h"

@implementation GSBuddy

+ (instancetype)buddyWithUsername:(NSString *)username
{
    GSBuddy * buddy = [[GSBuddy alloc] init];
    buddy.username = username;
    return buddy;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.megArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
@end
