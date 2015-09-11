//
//  ChatAndContactsViewController.h
//  young
//
//  Created by Lucas on 15/8/14.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatAndContactsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *chatListTV;
@property (weak, nonatomic) IBOutlet UITableView *contactsTV;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactsBtn;
@property (weak, nonatomic) IBOutlet UIView *leftUnderLine;
@property (weak, nonatomic) IBOutlet UIView *rightUnderLine;
- (IBAction)btnChat:(id)sender;
- (IBAction)btnContacts:(id)sender;

- (void)chatTVHeaderRereshing;


@end
