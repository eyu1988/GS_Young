//
//  TextDetailViewController.h
//  young
//
//  Created by Lucas on 15/8/25.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *textWebView;
@property (weak, nonatomic) NSString * content; /**< segue传值 */
@end
