//
//  ColorfulRectAndUILabelTableHeader.h
//  young
//
//  Created by z Apple on 7/10/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorfulRectAndUILabelTableHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *rectView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setRetract:(CGFloat) retractFloat;
@end
