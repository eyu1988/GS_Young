//
//  CrowdSourcingTableViewController.h
//  young
//
//  Created by z Apple on 15/3/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdSourcingTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (retain,nonatomic) NSMutableArray *crowdSourcingList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *upPullRefreshControl;
- (IBAction)downPullFresh:(id)sender;
@property int flag;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)NSMutableDictionary *searchParamter;
@property (nonatomic,strong)NSMutableDictionary *entryParamter;
@property (weak, nonatomic) IBOutlet UIButton *projectStateButton;
@property (weak, nonatomic) IBOutlet UIButton *servicetypeButton;
@property (weak, nonatomic) IBOutlet UIButton *releaseTimeButton;
@property (strong,nonatomic) NSString *serviceTypeName;

@end
