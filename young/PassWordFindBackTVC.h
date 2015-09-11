//
//  PassWordFindBackTVC.h
//  young
//
//  Created by z Apple on 15/5/22.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"
#import "JKCountDownButtonTools.h"

@interface PassWordFindBackTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *checkCode;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *verifyPassWord;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCheckCodeButton;
- (IBAction)save:(id)sender;
- (IBAction)sendCheckButton:(JKCountDownButton *)sender;

@end
