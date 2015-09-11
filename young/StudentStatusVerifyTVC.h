//
//  StudentStatusVerifyTVC.h
//  young
//
//  Created by z Apple on 15/5/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentStatusVerifyTVC : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *studentPictureIncludePhoto;
@property (weak, nonatomic) IBOutlet UIButton *studentPictureOther;

- (IBAction)choosePicture:(UIButton *)sender;
- (IBAction)save:(id)sender;

@end
