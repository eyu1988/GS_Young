//
//  LoginController.h
//  young
//
//  Created by z Apple on 15/3/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)colseMySelf:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)loginCheck:(id)sender;

@end
