//
//  BiderListCell.h
//  young
//
//  Created by z Apple on 8/23/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodnessLabel;

@end
