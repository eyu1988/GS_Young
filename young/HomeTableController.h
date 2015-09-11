//
//  HomeTableController.h
//  young
//
//  Created by z Apple on 15/3/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{

    NSMutableArray *imageArray;//存放图片
    NSTimer *myTimer;//定时器
  
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain,nonatomic) NSMutableArray *crowdSourcingList;
- (IBAction)pageTurn:(UIPageControl *)sender;

- (IBAction)downPullRefresh:(id)sender;
@end
