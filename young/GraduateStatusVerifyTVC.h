//
//  GraduateStatusVerifyTVC.h
//  young
//
//  Created by z Apple on 15/5/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraduateStatusVerifyTVC : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *graduatePhoto;


- (IBAction)choosePhoto:(UIButton *)sender;

@end
