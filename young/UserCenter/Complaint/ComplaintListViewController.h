//
//  ComplaintListViewController.h
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *TypeBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *BtnJBType;
@property (weak, nonatomic) IBOutlet UIButton *BtnJBState;
@property (weak, nonatomic) IBOutlet UIButton *BtnJBResult;
- (IBAction)ActionJBType:(id)sender;
- (IBAction)ActionJBState:(id)sender;
- (IBAction)ActionJBResult:(id)sender;

@end
