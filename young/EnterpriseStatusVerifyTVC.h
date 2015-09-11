//
//  EnterpriseStatusVerifyTVC.h
//  young
//
//  Created by z Apple on 15/5/20.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterpriseStatusVerifyTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UIButton *businessLicensePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseWithCommonSealPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *organizationCodeCertificatePhotoButton;
- (IBAction)choosePhoto:(UIButton *)sender;
- (IBAction)save:(id)sender;

@end
