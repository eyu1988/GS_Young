/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXMessageToolBar.h"

@interface DXMessageToolBar()<UITextViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
//@property (strong, nonatomic) UIButton *styleChangeButton;
//@property (strong, nonatomic) UIButton *moreButton;
//@property (strong, nonatomic) UIButton *faceButton;
@property (strong, nonatomic) UIButton * sendButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@end

@implementation DXMessageToolBar

// storyboard 由此方法初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupConfigure];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    
    return _toolbarView;
}

#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
//    self.faceButton.selected = NO;
//    self.styleChangeButton.selected = NO;
//    self.moreButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
//        [self endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    NSLog(@"%@ %@", self.description, self.superview);
//    NSLog(@"%f %f %f %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
//    self.toolbarView.backgroundColor = [UIColor blueColor];
//    self.backgroundColor = [UIColor greenColor];
    
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 10.0;
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight-20, self.frame.size.height - kVerticalPadding - kInputTextViewMinHeight, kInputTextViewMinHeight+20, kInputTextViewMinHeight)];
    self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;

    [self.sendButton setBackgroundColor:[UIColor orangeColor]];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.tag = 3;
    self.sendButton.layer.cornerRadius = 5;
    allButtonWidth += CGRectGetWidth(self.sendButton.frame) + kHorizontalPadding * 3;
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
 
    [self.toolbarView addSubview:self.inputTextView];
    [self.toolbarView addSubview:self.sendButton];
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
        NSLog(@"这里%f", toFrame.size.height);
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    NSLog(@"按钮响应");
    switch (tag) {
        case 0://切换状态
        {
            if (button.selected) {
//                self.faceButton.selected = NO;
//                self.moreButton.selected = NO;
                //录音状态下，不显示底部扩展页面
                [self willShowBottomView:nil];
                
                //将inputTextView内容置空，以使toolbarView回到最小高度
                self.inputTextView.text = @"";
                [self textViewDidChange:self.inputTextView];
                [self.inputTextView resignFirstResponder];
            }
            else{
                //键盘也算一种底部扩展页面
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.recordButton.hidden = !button.selected;
                self.inputTextView.hidden = button.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didStyleChangeToRecord:)]) {
                [self.delegate didStyleChangeToRecord:button.selected];
            }
        }
            break;
        case 1://表情
        {
//            if (button.selected) {
//                self.moreButton.selected = NO;
//                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
//                if (self.styleChangeButton.selected) {
//                    self.styleChangeButton.selected = NO;
//                }
//                else{//如果处于文字输入状态，使文字输入框失去焦点
//                    [self.inputTextView resignFirstResponder];
//                }
//                
//                [self willShowBottomView:self.faceView];
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.recordButton.hidden = button.selected;
//                    self.inputTextView.hidden = !button.selected;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            } else {
//                if (!self.styleChangeButton.selected) {
//                    [self.inputTextView becomeFirstResponder];
//                }
//                else{
//                    [self willShowBottomView:nil];
//                }
//            }
        }
            break;
        case 2://更多
        {
//            if (button.selected) {
//                self.faceButton.selected = NO;
//                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
//                if (self.styleChangeButton.selected) {
//                    self.styleChangeButton.selected = NO;
//                }
//                else{//如果处于文字输入状态，使文字输入框失去焦点
//                    [self.inputTextView resignFirstResponder];
//                }
//
//                [self willShowBottomView:self.moreView];
//                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.recordButton.hidden = button.selected;
//                    self.inputTextView.hidden = !button.selected;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }
//            else
//            {
//                self.styleChangeButton.selected = NO;
//                [self.inputTextView becomeFirstResponder];
//            }
        }
            break;
          
        case 3:
        {
            NSLog(@"发送");
            [self textView:_inputTextView shouldChangeTextInRange:NSRangeFromString(@"") replacementText:@"\n"];
//            [self endEditing:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
//    self.faceButton.selected = NO;
//    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    
//    CGFloat allButtonWidth = CGRectGetWidth(self.sendButton.frame) + kHorizontalPadding * 3;
//    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (10.f * 2));
//    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(10.f, kVerticalPadding, width, kInputTextViewMinHeight)];
    return result;
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.inputTextView isExclusiveTouch]) {
//        [_chatToolBar resignFirstResponder];
        [self endEditing:YES];
    }
}

@end
