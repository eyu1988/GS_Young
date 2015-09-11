//
//  ComplaintInfoTableViewCell.h
//  young
//
//  Created by Lucas on 15/8/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *proofBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;

@end
