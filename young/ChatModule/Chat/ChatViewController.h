//
//  ChatViewController.h
//  ChatDemo
//
//  Created by Lucas on 15/8/4.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController


@property (weak, nonatomic) NSString * receiverName; /**< segue传值  */
@property (weak, nonatomic) NSString * receiverID; /**< segue传值 */
//@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) UITextView * chatTextView;


@end
