//
//  ComplaintModel.h
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplaintModel : NSObject

@property (nonatomic, strong) NSString * complaintID;
@property (nonatomic, strong) NSString * informerName;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * defendantName;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * proofTitle;
@property (nonatomic, strong) NSMutableArray * downLoadFiles;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * userType;

@end
