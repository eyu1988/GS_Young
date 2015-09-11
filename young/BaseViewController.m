    //
//  BaseViewController.m
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

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SortTableViewController.h"
#import "PrimaryTools.h"


@implementation BaseViewController

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image selectedImage:selectedImage storyboardIdentifier: storyboardIdentifier fromStoryboard:(NSString*) storyboardName
{
    
  UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
  NSLog(@"storyboard:%@",storyboardName);
  NSLog(@"storyboardIdentifier:%@",storyboardIdentifier);
  UIViewController* viewController = [mainStoryboard   instantiateViewControllerWithIdentifier:storyboardIdentifier];
  viewController.tabBarItem =  [[UITabBarItem alloc] initWithTitle:title image:image tag:0];

  viewController.tabBarItem.selectedImage =selectedImage;
  return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchDown];
    _centerButton = button;
  [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}
-(void)clickButton
{
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"SortStoryboard" bundle:nil];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *sortTvc =[mainStoryboard   instantiateViewControllerWithIdentifier:@"SortNavigationBar"];

    UINavigationItem *item = sortTvc.navigationBar.items[0];
    item.title =  @"发布需求";
    UIButton *leftBarButton = [UIButton buttonWithType:100];

    [leftBarButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(closeMyself) forControlEvents:(UIControlEventTouchDown)];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton] ;
    item.leftBarButtonItem =leftBarButtonItem;

    if (delegate.loginUser) {
        if ([[delegate.loginUser objectForKey:@"is_check"] intValue]!=2) {
            [PrimaryTools alert:@"您还未实名认证，请在我的中心中进行实名认证后，再发布需求。"];
        }else [self presentViewController:sortTvc animated:YES completion:nil];
    }else{
        [self presentViewController:
         [mainStoryboard   instantiateViewControllerWithIdentifier:@"Login"]
                                animated:YES completion:nil];
    }
   
}


-(void)closeMyself
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
