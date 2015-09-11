//
//  ReleaseRequirementFormTVC.h
//  young
//
//  Created by z Apple on 15/5/5.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPickView.h"


@interface ReleaseRequirementFormTVC : UITableViewController<ZPickViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dealModel;

- (IBAction)chooseCountUnit:(UIButton *)sender;
@property (strong,nonatomic) NSString *typeIdentifier;
@property (weak, nonatomic) IBOutlet UITextField *titleLable;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *peopleNum;
@property (weak, nonatomic) IBOutlet UIButton *stopDate;
@property (weak, nonatomic) IBOutlet UIButton *overDate;
@property (weak, nonatomic) IBOutlet UISwitch *isTrusteeship;
@property (weak, nonatomic) IBOutlet UITextField *cost;

@property (weak, nonatomic) IBOutlet UITextField *unitCost;

@property (weak, nonatomic) IBOutlet UITextField *workload;
//@property (weak, nonatomic) IBOutlet UITextField *dispenseWay;
- (IBAction)chooseDate:(UIButton *)sender;
@property(nonatomic,strong)ZPickView *pickview;
@property (weak, nonatomic) IBOutlet UIButton *rewardDistribute;
- (IBAction)chooseRewardDistribute:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *optionalTableCells;
@property (weak, nonatomic) IBOutlet UIButton *countUnit;

@property (weak, nonatomic) IBOutlet UITableViewCell *rewardTableCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *detailCell;
@property (strong, nonatomic) NSString *dealMode;
@property (weak, nonatomic) IBOutlet UILabel *detailPlaceHolder;
- (IBAction)chooseDealModel:(id)sender;

- (IBAction)submitForm:(id)sender;
@end
