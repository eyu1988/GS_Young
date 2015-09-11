//
//  RegisterController.h
//  young
//
//  Created by z Apple on 15/4/9.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface RegisterController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
- (IBAction)sendCheckCode:(JKCountDownButton*)sender;
- (IBAction)clickCheckedButton:(UIButton *)sender;
- (IBAction)clickWhetherShowButton:(UIButton*)sender;

- (IBAction)clickRegisterButton:(id)sender;


@end
