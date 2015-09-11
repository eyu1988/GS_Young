//
//  HomeTabBarViewController.m
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

#import "HomeTabBarViewController.h"
#import "HomeTableController.h"
#import "SortTableViewController.h"
#import "AppDelegate.h"

@implementation HomeTabBarViewController
//
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"青春号" image:[UIImage imageNamed:@"bottomtabbar/tab_feed.png"]
                                        selectedImage:[UIImage imageNamed:@"bottomtabbar/tab_feed_selected.png"]
                                        storyboardIdentifier:@"HomeNavigationBar" fromStoryboard:@"Main"] ,
                            [self viewControllerWithTabTitle:@"分类找" image:[UIImage imageNamed:@"bottomtabbar/tab_live"]
                              selectedImage:[UIImage imageNamed:@"bottomtabbar/tab_live_selected.png"]
                                        storyboardIdentifier:@"SortNavigationBar" fromStoryboard:@"SortStoryboard"],
                            [self viewControllerWithTabTitle:@"" image:nil
                              selectedImage:nil
                                        storyboardIdentifier:@"MyCenterNavigationBar" fromStoryboard:@"MyCenterStoryboard"],
                            [self viewControllerWithTabTitle:@"消息" image:[UIImage imageNamed:@"bottomtabbar/tab_messages.png"]
                                               selectedImage:[UIImage imageNamed:@"bottomtabbar/tab_messages_selected.png"]
                                        storyboardIdentifier:@"MessageNavigationBar" fromStoryboard:@"ChatStoryboard"],
                            [self viewControllerWithTabTitle:@"我的中心" image:[UIImage imageNamed:@"bottomtabbar/tab_feed_profile.png"]
                               selectedImage:[UIImage imageNamed:@"bottomtabbar/tab_feed_profile_selected.png"]
                                        storyboardIdentifier:@"MyCenterNavigationBar" fromStoryboard:@"MyCenterStoryboard"], nil];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.viewControllers =self.viewControllers;
   [self addCenterButtonWithImage:[UIImage imageNamed:@"bottomtabbar/requirement_add_button.png"] highlightImage:[UIImage imageNamed:@"bottomtabbar/requirement_add_button.png"]];
    self.tabBar.tintColor =[UIColor colorWithRed:75.0/255.0 green:167.0/255.0 blue:66.0/255.0 alpha:1];

}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"bottomtabbar/camera_button_take.png"] highlightImage:[UIImage imageNamed:@"bottomtabbar/tabBar_cameraButton_ready_matte.png"]];
}


- (void)tabBar:(UITabBar *)tabBar
 didSelectItem:(UITabBarItem *)item
{
//      NSLog(@"tabbar:%@",item);
    
}

- (void)hideAllTabBar{
    [self.tabBar setHidden:YES];
    [self.centerButton setHidden:YES];
    
}

- (void)appearAllTabBar{
    [self.tabBar setHidden:NO];
    [self.centerButton setHidden:NO];
}

@end
