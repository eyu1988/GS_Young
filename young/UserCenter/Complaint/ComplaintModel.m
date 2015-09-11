//
//  ComplaintModel.m
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ComplaintModel.h"

@implementation ComplaintModel

- (id)init
{
    self = [super init];
    if (self) {
        self.downLoadFiles = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
