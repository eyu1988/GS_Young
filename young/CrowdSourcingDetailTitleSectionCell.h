//
//  CrowdSourcingDetailTitleSectionCell.h
//  young
//
//  Created by z Apple on 8/23/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdSourcingDetailTitleSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *requireTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *residueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *biderNumLabel;

@end
