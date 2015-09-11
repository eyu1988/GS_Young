//
//  BindZfbVC.h
//  young
//
//  Created by z Apple on 15/7/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface BindZfbVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *zfbAccount;

@property (weak, nonatomic) IBOutlet UITextField *checkCode;

- (IBAction)sendCheckButton:(JKCountDownButton *)sender;
- (IBAction)bindClick:(id)sender;

- (IBAction)cancelAction:(id)sender;

@end
