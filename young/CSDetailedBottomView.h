//
//  CSDetailedBottomView.h
//  young
//
//  Created by z Apple on 8/24/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDetailedBottomView : UIView

@property (strong,nonatomic)NSString *requireId;
@property (strong,nonatomic)NSString *userId;
@property (weak,nonatomic)UINavigationController *nc;
- (IBAction)bidding:(id)sender;
- (IBAction)complainAction:(id)sender;
- (IBAction)contactAction:(id)sender;

@end
