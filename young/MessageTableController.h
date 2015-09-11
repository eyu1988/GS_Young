//
//  MessageTableController.h
//  young
//
//  Created by z Apple on 15/3/24.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (copy,nonatomic) NSArray *dwarves;
@property (retain,nonatomic)  NSMutableArray *messages;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *upPullRefreshControl;
- (IBAction)downPullFresh:(id)sender;
@property (weak,nonatomic)NSString *messageId;

@end
