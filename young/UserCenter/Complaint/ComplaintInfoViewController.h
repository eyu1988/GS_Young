//
//  ComplaintInfoViewController.h
//  young
//
//  Created by Lucas on 15/8/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplaintModel.h"

@interface ComplaintInfoViewController : UIViewController


//@property (nonatomic, strong) NSString * complaintID;
//@property (nonatomic, strong) NSString * titleName;
@property (nonatomic, strong) ComplaintModel * complaintModel;

@property (weak, nonatomic) IBOutlet UIView *userBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UITableView *informationTV;
@property (weak, nonatomic) IBOutlet UIButton *btnJB;
- (IBAction)ActionJB:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBJB;
- (IBAction)ActionBJB:(id)sender;
@end
