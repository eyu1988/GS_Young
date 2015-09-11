//
//  CrowdSourcingBiddingViewController.h
//  young
//
//  Created by z Apple on 15/3/26.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINeedLoginningTableViewController.h"


@interface CrowdSourcingBiddingViewController : UINeedLoginningTableViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *biderIntroduction;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *authCode;
@property (weak, nonatomic) IBOutlet UILabel *viewTextPlaceHolder;
- (IBAction)save:(id)sender;
@property (weak,nonatomic)NSString *requirementId;
@property (weak,nonatomic) NSDictionary *allDataDic;
- (IBAction)clickAuthCode:(UIButton *)sender;
//+ (NSURL *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;


@end
