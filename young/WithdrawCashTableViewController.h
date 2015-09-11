//
//  WithdrawCashTableViewController.h
//  young
//
//  Created by z Apple on 15/6/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface WithdrawCashTableViewController : UITableViewController
- (IBAction)submit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *payPwdField;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
- (IBAction)chooseAccount:(id)sender;
- (IBAction)sendCheckButton:(JKCountDownButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeLabel;

@end
