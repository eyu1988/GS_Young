//
//  ZfbIndexTableViewCell.h
//  young
//
//  Created by z Apple on 15/7/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZfbIndexTableViewCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *relieveButton;
@property (weak, nonatomic) IBOutlet UITextField *zfbAccountField;
@property (weak, nonatomic) IBOutlet UILabel *zfbBindDate;

- (IBAction)relieveAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addZfbAccount;
@property (weak, nonatomic) IBOutlet UILabel *accountTitle;
@property (weak, nonatomic) IBOutlet UILabel *bindDateTitle;
-(void)setNotBindView;
-(void)setAlreadyBindView;
@end
