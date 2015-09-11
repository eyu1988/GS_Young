//
//  CrowdSourcingViewDetailedController.h
//  young
//
//  Created by z Apple on 15/3/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface CrowdSourcingViewDetailedController : UITableViewController
@property (retain,nonatomic) NSMutableArray *bidList;
@property (weak,nonatomic) NSDictionary *allDataDic;
@property (weak,nonatomic) NSDictionary *requirementDic;
@property (weak,nonatomic) NSString *requirementId;
@property (retain,nonatomic) NSMutableArray *crowdSourcingList;
@property (nonatomic) NSInteger listIndex;//arrayList 中的位置



@end
