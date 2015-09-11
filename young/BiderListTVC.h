//
//  BiderListTVC.h
//  young
//
//  Created by z Apple on 8/21/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreashTableViewController.h"

@interface BiderListTVC : UITableViewController
//@interface BiderListTVC : UITableViewController
@property (weak,nonatomic)NSString *requirementId;
@property (nonatomic,copy)NSDictionary *dataDictionary;
@property (nonatomic,copy)NSArray *dataList;
- (void)initData;
@end
