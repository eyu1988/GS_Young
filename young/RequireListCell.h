//
//  RequireListCell.h
//  young
//
//  Created by z Apple on 8/15/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *workTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *requireTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
-(void)setCellValueFrom:(NSDictionary*)dic;
@end
