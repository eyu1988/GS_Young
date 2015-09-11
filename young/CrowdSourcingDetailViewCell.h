//
//  CrowdSourcingDetailViewCell.h
//  young
//
//  Created by z Apple on 15/3/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdSourcingDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *bidder;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *bidderIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *bidState;
@end
