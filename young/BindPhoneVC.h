//
//  BindPhoneVC.h
//  young
//
//  Created by z Apple on 15/4/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface BindPhoneVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *checkCode;

- (IBAction)sendCheckButton:(JKCountDownButton *)sender;
- (IBAction)bindClick:(id)sender;

@end
