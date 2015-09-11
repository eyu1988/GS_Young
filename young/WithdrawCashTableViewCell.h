//
//  WithdrawCashTableViewCell.h
//  young
//
//  Created by z Apple on 7/30/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawCashTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyForDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *overDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end
