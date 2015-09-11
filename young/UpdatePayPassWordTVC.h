//
//  UpdatePayPassWordTVC.h
//  young
//
//  Created by z Apple on 7/13/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKCountDownButton;

@interface UpdatePayPassWordTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPassWordText;

@property (weak, nonatomic) IBOutlet UITextField *currentPassWordText;


@property (weak, nonatomic) IBOutlet UITextField *verifyText;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeText;

- (IBAction)sendCheckButton:(JKCountDownButton *)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *oldPwdCell;
- (IBAction)save:(id)sender;
@property (assign)BOOL isFirstSet;

@end
