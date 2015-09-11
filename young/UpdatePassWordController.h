//
//  UpdatePassWordController.h
//  young
//
//  Created by z Apple on 15/3/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePassWordController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;

@property (weak, nonatomic) IBOutlet UITextField *nowPassWord;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassWord;
- (IBAction)save:(id)sender;

@end
