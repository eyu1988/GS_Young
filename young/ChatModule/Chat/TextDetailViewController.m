//
//  TextDetailViewController.m
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "TextDetailViewController.h"
#import "HomeTabBarViewController.h"

@interface TextDetailViewController ()

@end

@implementation TextDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc hideAllTabBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc appearAllTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_textWebView loadHTMLString:_content baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
