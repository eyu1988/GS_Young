//
//  MyCenterTableController.h
//  young
//
//  Created by z Apple on 15/3/24.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Availability.h>
#import <Foundation/Foundation.h>
#import "ZActivity.h"


@interface MyCenterTableController : UITableViewController<UITableViewDataSource,UITableViewDelegate,ZActivityDelegate>

@property (strong, nonatomic) IBOutlet UIButton *headImage;
@property (copy,nonatomic) NSArray *aList;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *intoLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)clickLogout:(id)sender;
@property (assign, nonatomic) int tapIndex;
@end
