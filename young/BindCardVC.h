//
//  BindCardVC.h
//  young
//
//  Created by z Apple on 15/7/2.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface BindCardVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cardCode;

@property (weak, nonatomic) IBOutlet UITextField *checkCode;

- (IBAction)sendCheckButton:(JKCountDownButton *)sender;
- (IBAction)bindClick:(id)sender;

- (IBAction)cancelAction:(id)sender;
@end
