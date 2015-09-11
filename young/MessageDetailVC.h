//
//  MessageDetailVC.h
//  young
//
//  Created by z Apple on 15/4/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) NSDictionary *messageDic;
@property (weak, nonatomic) NSString *messageId;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
@property (weak, nonatomic) IBOutlet UIWebView *messageContentByHtml;

@end
