//
//  DailyBoothViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "DailyBoothViewController.h"
#import "HomeTableController.h"
#import "SortTableViewController.h"
#import "AppDelegate.h"

@implementation DailyBoothViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"青春号" image:[UIImage imageNamed:@"DailyBooth/tab_feed.png"] storyboardIdentifier:@"HomeNavigationBar"],
                            [self viewControllerWithTabTitle:@"分类找" image:[UIImage imageNamed:@"DailyBooth/tab_live"] storyboardIdentifier:@"SortNavigationBar"],
                            [self viewControllerWithTabTitle:@"" image:nil storyboardIdentifier:@"MessageNavigationBar"],
                            [self viewControllerWithTabTitle:@"消息" image:[UIImage imageNamed:@"DailyBooth/tab_messages.png"] storyboardIdentifier:@"MessageNavigationBar"],
                            [self viewControllerWithTabTitle:@"我的中心" image:[UIImage imageNamed:@"DailyBooth/tab_feed_profile.png"] storyboardIdentifier:@"MyCenterNavigationBar"], nil];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.viewControllers =self.viewControllers;
   [self addCenterButtonWithImage:[UIImage imageNamed:@"DailyBooth/requirement_add_button.png"] highlightImage:[UIImage imageNamed:@"DailyBooth/requirement_add_button.png"]];
    self.tabBar.tintColor =[UIColor colorWithRed:75.0/255.0 green:167.0/255.0 blue:66.0/255.0 alpha:1];

}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"DailyBooth/camera_button_take.png"] highlightImage:[UIImage imageNamed:@"DailyBooth/tabBar_cameraButton_ready_matte.png"]];
}


//- (void)tabBar:(UITabBar *)tabBar
// didSelectItem:(UITabBarItem *)item
//{
//      NSLog(@"tabbar");
//    
//}


@end
