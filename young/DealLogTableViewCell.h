//
//  DealLogTableViewCell.h
//  young
//
//  Created by z Apple on 7/31/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dealName;
@property (weak, nonatomic) IBOutlet UILabel *dealAccount;
@property (weak, nonatomic) IBOutlet UILabel *dealMoney;
@property (weak, nonatomic) IBOutlet UILabel *dealTime;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *dealDetail;

@end
