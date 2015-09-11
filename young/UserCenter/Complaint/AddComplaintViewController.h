//
//  AddComplaintViewController.h
//  young
//
//  Created by Lucas on 15/8/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddComplaintViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn2;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn3;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn3;

@property (nonatomic, strong) NSString * orderID; /**< 提交参数 - fwsid */
@property (nonatomic, strong) NSString * complaintID;  /**< 提交参数 - jbId */
@property (nonatomic) BOOL isNewComplaint;
@property (nonatomic, strong) NSString * complaintTitle;
@property (nonatomic, strong) NSString * complaintType;
@property (nonatomic, strong) NSString * userType;

@end
