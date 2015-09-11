//
//  CrowdSourcingViewDetailCommonControl.h
//  young
//
//  Created by z Apple on 15/3/23.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CrowdSourcingViewDetailCommonControl : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *introductionButton;
@property (strong,nonatomic) NSDictionary *allDataDic;
@property (strong,nonatomic) NSDictionary *requirementDic;
@property (weak, nonatomic) IBOutlet UILabel *requirementTitle;
@property (weak, nonatomic) IBOutlet UILabel *budget;
@property (weak, nonatomic) IBOutlet UILabel *bidderSum;
@property (weak, nonatomic) IBOutlet UILabel *targetPeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *targetEndDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *requirementType;
@property (weak, nonatomic) IBOutlet UILabel *issueData;
@property (weak, nonatomic) IBOutlet UILabel *contactWay;
- (IBAction)intoWebView:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *requirementStateAndBid;



@end
