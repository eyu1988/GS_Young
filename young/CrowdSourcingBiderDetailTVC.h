//
//  CrowdSourcingBiderDetailTVC.h
//  young
//
//  Created by z Apple on 8/25/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdSourcingBiderDetailTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *requireTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *biderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodAtWork;
@property (weak, nonatomic) IBOutlet UILabel *projectNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *positiveRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireDetailLabel;
@property (strong,nonatomic) NSString *bidId;

@property (strong, nonatomic) NSString * buserNo; /**< 被关注人ID */
@end
