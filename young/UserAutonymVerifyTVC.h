//
//  UserAutonymVerifyTVC.h
//  young
//
//  Created by z Apple on 15/5/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAutonymVerifyTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *autonym;
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)chooseImage:(UIButton *)sender;

- (IBAction)save:(id)sender;

@end
