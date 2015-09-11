//
//  CrowdSourcingViewDetailedTVC.h
//  young
//
//  Created by z Apple on 8/21/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreashTableViewController.h"

@interface CrowdSourcingViewDetailedTVC : RefreashTableViewController
@property (strong, nonatomic) IBOutlet UITableView *biderTableView;
@property (weak,nonatomic)NSString *requirementId;

@end
