//
//  PersonalProfileTVC.h
//  young
//
//  Created by z Apple on 8/10/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalProfileTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *birthdayButton;
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
//@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UITextField *qqTextField;

@property (weak, nonatomic) IBOutlet UITextField *telephoneNumberTextField;

- (IBAction)chooseSex:(id)sender;
- (IBAction)chooseBirthday:(id)sender;
- (IBAction)chooseProvince:(id)sender;


- (IBAction)save:(id)sender;

@end
