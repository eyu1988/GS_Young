//
//  CrowdSourcingDetailContentSectionCell.h
//  young
//
//  Created by z Apple on 8/23/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdSourcingDetailContentSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailContantLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *employerLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLimit;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *closeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneDateLabel;
@property (assign, nonatomic) NSInteger *isOverDue;

- (IBAction)postpone:(id)sender;

- (void)initData:(NSDictionary*) dict;
@property (weak, nonatomic) IBOutlet UIButton *applyForPostpone;

@end
