//
//  BankCard.h
//  young
//
//  Created by z Apple on 15/7/6.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCard : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;

@property (weak,nonatomic) IBOutlet UILabel *bankName;
@property (weak,nonatomic) IBOutlet UILabel *cardTypeName;
@property (weak,nonatomic) IBOutlet UILabel *cardCode;
@property (weak,nonatomic) IBOutlet UILabel *bindDate;
@property (weak,nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *bindPhone;

@end
