//
//  ViewInfoByWebUIController.h
//  young
//
//  Created by z Apple on 15/4/17.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewInfoByWebUIController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) NSString *strUrl;
@property (weak, nonatomic) NSString *strHtml;

@end
