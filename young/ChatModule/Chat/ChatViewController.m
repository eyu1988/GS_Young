//
//  ChatViewController.m
//  ChatDemo
//
//  Created by Lucas on 15/8/4.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#import "ChatViewController.h"
#import "SRSlimeView.h"
#import "SRRefreshView.h"
#import "DXMessageToolBar.h"
#import "GSMegModel.h"
//#import "DXChatBarMoreView.h"
#import "FMDB.h"
#import "GSBuddy.h"
#import "GSDefine.h"
#import "DataBaseManager.h"
#import "GlobleLocalSession.h"
#import "ZSyncURLConnection.h"  
#import "UrlFactory.h"
#import "PrimaryTools.h"
#import "AppDelegate.h"
#import "HomeTabBarViewController.h"

#define BUBBLE_LEFT_IMAGE_NAME @"chat_receiver_bg" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"chat_sender_bg"
#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 8 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 35 // 文字在左侧时,bubble用于拉伸点的Y坐标

#define BGCOLOR [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]//[UIColor colorWithRed:0.81f green:0.96f blue:0.55f alpha:1.00f]
#define TABLEVIEW_BACKGROUNDCOLOR [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f]

#define DEFAULTVIEWWIDTH 538.f //聊天气泡在600*600布局中的宽度

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, /*UINavigationControllerDelegate, UIImagePickerControllerDelegate,*/ DXMessageToolBarDelegate, SRRefreshDelegate, UITextViewDelegate>
{
    int _pageIndex; /**< 聊天页码 */
//    CGFloat _contentWidth;
    CGFloat keyboardheight;
    CGRect _chatToolBarRect;
    CGRect _tableViewRect;
    CGRect _chatTextViewRect;
    CGFloat _textViewWidth;
    
    UIControl * _keyboardControl;
}

@property (weak, nonatomic) IBOutlet UITableView * tableView;/**<当前页中的列表视图 - 来自storyboard*/
@property (weak, nonatomic) IBOutlet DXMessageToolBar *chatToolBar; /**< 输入工具条 -  来自storyboard*/

@property (strong, nonatomic) NSMutableArray *dataSource; /**<tableView数据源*/
@property (strong, nonatomic) SRRefreshView * slimeView;
@property (nonatomic) BOOL isScrollToBottom; /**< 判断是否移至底部 */

@end


@implementation ChatViewController

- (void)viewDidLayoutSubviews
{
    [self.tableView addSubview:self.slimeView];
    
    _tableViewRect = _tableView.frame;
    _chatToolBarRect = _chatToolBar.frame;
    _textViewWidth = _chatTextView.frame.size.width;
    _chatTextViewRect = _chatTextView.frame;
    [self scrollViewToBottom:NO];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc hideAllTabBar];
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    HomeTabBarViewController * tbvc= (HomeTabBarViewController*)self.tabBarController;
    [tbvc appearAllTabBar];
}

/*******************************************************************************************/

#pragma mark - keyboard notification
- (void)begainMoveUpAnimation:(CGFloat) height
{
    [UIView animateWithDuration:0.2 animations:^{
        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y-height, _chatToolBarRect.size.width, _chatToolBarRect.size.height);
        
        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-height);
        
        [self scrollViewToBottom:YES];
    }];
}

- (void)begainMoveDownAnimation:(CGFloat) height
{
    [UIView animateWithDuration:0.2 animations:^{
        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y, _chatToolBarRect.size.width, _chatToolBarRect.size.height);
        self.chatTextView.frame = CGRectMake(5, 5, self.view.frame.size.width - 20 - _sendBtn.frame.size.width, 40);
        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height);
        
        [self scrollViewToBottom:YES];
    }];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
//    NSLog(@"keyboard height:%f",kbSize.height);
    keyboardheight = kbSize.height;
    
    [self begainMoveUpAnimation:kbSize.height];
}

- (void) putDownKeyboard
{
    [self begainMoveDownAnimation:0.0];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self begainMoveDownAnimation:0.0];
}


#pragma mark - text view delegate

//关闭键盘(TextView) 换行时。隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    resultCommunityTableview.frame = CGRectMake(0, 36, 320, 376);
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"";
            return NO;
        }
        else{
            [self requestSendMegWithTextMessage:textView.text];
            textView.text = @"";
            
            _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y-keyboardheight, _chatToolBarRect.size.width, _chatToolBarRect.size.height);
            
            self.chatTextView.frame = CGRectMake(5, 5, self.view.frame.size.width - 20 - _sendBtn.frame.size.width, 40);
            
            _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-keyboardheight);

            
            return NO;
        }
    }
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _sendBtn.enabled = NO;
    }
    else{
        _sendBtn.enabled = YES;
    }
    CGSize size = [self textSizeWithMegText:textView.text];
    
    NSLog(@"%f", size.height);
    if (size.height <= _chatTextViewRect.size.height) {
        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y-keyboardheight, _chatToolBarRect.size.width, _chatToolBarRect.size.height);
        
        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-keyboardheight);
    }
    else if (size.height > _chatTextViewRect.size.height && size.height < 100.f) {
        CGFloat h = size.height - _chatTextViewRect.size.height + 10;
//        NSInteger num = h / 19.088 + 1;
//        CGFloat height = 19.088 * num;
        
        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y - keyboardheight - h, _chatToolBarRect.size.width, _chatToolBarRect.size.height + h);
        _chatTextView.frame = CGRectMake(5, 5, _chatTextViewRect.size.width, _chatToolBarRect.size.height + h-10);
        
        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-keyboardheight - h);
//        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y - keyboardheight - height, _chatToolBarRect.size.width, _chatToolBarRect.size.height + height);
//        _chatTextView.frame = CGRectMake(5, 5, _chatTextViewRect.size.width, _chatToolBarRect.size.height +height -10);
//        
//        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-keyboardheight - height);
        [self scrollViewToBottom:YES];
    }
//    else{
//        _chatToolBar.frame = CGRectMake(0, _chatToolBarRect.origin.y - keyboardheight - 184.f, _chatToolBarRect.size.width, _chatToolBarRect.size.height);
//        _tableView.frame = CGRectMake(0, _tableViewRect.origin.y, _tableViewRect.size.width, _tableViewRect.size.height-keyboardheight);
//    }

}

- (CGSize)textSizeWithMegText:(NSString *)megText
{
    CGSize size = CGSizeMake(_textViewWidth,CGFLOAT_MAX);//LableWight标签宽度，固定的
    
    UIFont * tfont = [UIFont systemFontOfSize:16];
    
    //获取当前文本的属性
    NSDictionary *tdic=[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize = [megText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize;
}


/*******************************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
//     self.automaticallyAdjustsScrollViewInsets = NO;
    _pageIndex = 1;//页码, 默认为1
    _isScrollToBottom = YES; //初试状态设置滚动到底部
    
    // 输入工具条布局设计
    _sendBtn.layer.cornerRadius = 5;
    [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.chatTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 20 - _sendBtn.frame.size.width, 40)];
    [_chatToolBar addSubview:self.chatTextView];
    
    self.chatTextView.scrollEnabled = YES;
    self.chatTextView.returnKeyType = UIReturnKeySend;
    self.chatTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    self.chatTextView.delegate = self;
    self.chatTextView.font = [UIFont systemFontOfSize:16];
    self.chatTextView.backgroundColor = [UIColor whiteColor];
    self.chatTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.chatTextView.layer.borderWidth = 0.65f;
    self.chatTextView.layer.cornerRadius = 6.0f;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    self.navigationItem.title = _receiverName; //设置导航栏标题
    [self setupBarButtonItem];
    
    
    [[DataBaseManager sharedDataBaseManager] createDataBase]; // 创建数据库
    
//    [self dataSource];
    _dataSource = [[DataBaseManager sharedDataBaseManager] getDataWithUserID:_receiverID andPage:_pageIndex];
    
    [self setTableView];
    
//    [self setChatToolBar];
    
    [[DataBaseManager sharedDataBaseManager] readAllDataFromUserID:_receiverID];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChat) name:@"listLoadDone" object:nil];
}

- (void)sendClick
{
    if ([_chatTextView.text isEqualToString:@""]) {
        return;
    }
    
    [self requestSendMegWithTextMessage:_chatTextView.text];
    _chatTextView.text = @"";
    [_chatTextView resignFirstResponder];
//    [self begainMoveDownAnimation:0.0];
}

- (void)refreshChat
{
    NSLog(@"聊天详情 - listLoadDone");
    _dataSource = [[DataBaseManager sharedDataBaseManager] getDataWithUserID:_receiverID andPage:_pageIndex];
    [self.tableView reloadData];
    [[DataBaseManager sharedDataBaseManager] readAllDataFromUserID:_receiverID];
    [self scrollViewToBottom:YES];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
}


- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)setupBarButtonItem
{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (void)setTableView
{
//    NSLog(@"%lf, %lf, %lf", self.view.frame.size.width, self.view.frame.size.height,self.chatToolBar.frame.size.height);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        lpgr.minimumPressDuration = .5;
//        [_tableView addGestureRecognizer:lpgr];
    
}

- (DXMessageToolBar *)setChatToolBar
{
    
    _chatToolBar.delegate = self;
    
//    ChatMoreType type = self.isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
//    _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) type:ChatMoreTypeChat];
//    _chatToolBar.moreView.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.97f alpha:1.00f];//RGBACOLOR(240, 242, 247, 1);
    
    return _chatToolBar;
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GSMegModel * mm = [_dataSource objectAtIndex:indexPath.row];
    NSString *imageName = mm.isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    NSInteger leftCapWidth = mm.isReceiver?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight =  mm.isReceiver?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
    
    
    if (mm.isReceiver)
    {
        UITableViewCell * cell;
        UILabel * timeLabel;
        UIImageView * leftIV;
        UIView * bgLeftView;
        UIImageView * bgLeftIV;
        UILabel * labelLeft;
        
        if (mm.megSize.height <  38.176) { //单行聊天气泡, 代码自适应
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeftSingleLineCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LeftSingleLineCell"];
            }
            
            timeLabel = (UILabel *)[cell viewWithTag:201];
            leftIV = (UIImageView *)[cell viewWithTag:202];
            bgLeftView = (UIView *)[cell viewWithTag:203];
            bgLeftIV = (UIImageView *)[cell viewWithTag:204];
            labelLeft = (UILabel *)[cell viewWithTag:205];
            
            CGFloat height = leftIV.frame.size.height /40.f * (20.f+mm.megSize.height);
//            CGFloat widthRate = bgLeftView.frame.size.width/235.f;
            
            bgLeftView.frame = CGRectMake(bgLeftView.frame.origin.x, bgLeftView.frame.origin.y, bgLeftView.frame.size.width, height);
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeftViewCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LeftViewCell"];
            }
            
            timeLabel = (UILabel *)[cell viewWithTag:101];
            leftIV = (UIImageView *)[cell viewWithTag:102];
            bgLeftView = (UIView *)[cell viewWithTag:103];
            bgLeftIV = (UIImageView *)[cell viewWithTag:104];
            labelLeft = (UILabel *)[cell viewWithTag:105];
            
            CGFloat height = leftIV.frame.size.height /40.f * (20.f+mm.megSize.height);
            
            bgLeftView.frame = CGRectMake(bgLeftView.frame.origin.x, bgLeftView.frame.origin.y, bgLeftView.frame.size.width, height);
            
        }
        
        //清理
        leftIV.image = nil;
        timeLabel.text = @"";
        bgLeftIV.image = nil;
        labelLeft.text = @"";
        
        [PrimaryTools setHeadImageUseCache:leftIV userNo:_receiverID];
        if (!leftIV.image) {
            leftIV.image = [UIImage imageNamed:@"acquiesceheader.png"];
        }

        bgLeftIV.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        labelLeft.text = mm.megText;
        timeLabel.text = [self dateToStringWithTimeStamp: mm.megDate];
        
        labelLeft.textColor = [UIColor blackColor];
        if (mm.isNewData) {
            labelLeft.textColor = [UIColor blueColor];
            labelLeft.text = [self filterHTML:mm.megText];
        }
        
        return cell;
    }
    else{
        
        UITableViewCell * cell;
        UILabel * timeLabel;
        UIImageView * rightIV;
        UIView * bgRightView;
        UIImageView * bgRightIV;
        UILabel * labelRight;
        
        if (mm.megSize.height <  38.176) { //单行聊天气泡, 代码自适应
            cell = [tableView dequeueReusableCellWithIdentifier:@"RightSingleLineCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightSingleLineCell"];
            }
            
            timeLabel = (UILabel *)[cell viewWithTag:401];
            rightIV = (UIImageView *)[cell viewWithTag:402];
            bgRightView = (UIView *)[cell viewWithTag:403];
            bgRightIV = (UIImageView *)[cell viewWithTag:404];
            labelRight = (UILabel *)[cell viewWithTag:405];
            
            CGFloat height = rightIV.frame.size.height /40.f * (20.f+mm.megSize.height);
            CGFloat widthRate = bgRightView.frame.size.width/235.f;
            
            bgRightView.frame = CGRectMake(bgRightView.frame.origin.x+bgRightView.frame.size.width - (mm.megSize.width+30.f)*widthRate, bgRightView.frame.origin.y, bgRightView.frame.size.width, height);
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"RightViewCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightViewCell"];
            }

            timeLabel = (UILabel *)[cell viewWithTag:301];
            rightIV = (UIImageView *)[cell viewWithTag:302];
            bgRightView = (UIView *)[cell viewWithTag:303];
            bgRightIV = (UIImageView *)[cell viewWithTag:304];
            labelRight = (UILabel *)[cell viewWithTag:305];
            
            CGFloat height = rightIV.frame.size.height /40.f * (20.f+mm.megSize.height);
            
            bgRightView.frame = CGRectMake(bgRightView.frame.origin.x, bgRightView.frame.origin.y, bgRightView.frame.size.width, height);

        }
        
        //清理
        rightIV.image = nil;
        timeLabel.text = @"";
        bgRightIV.image = nil;
        labelRight.text = @"";
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [PrimaryTools setHeadImageUseCache:rightIV userNo:[delegate.loginUser objectForKey:@"user_no"]];
        if (!rightIV.image) {
            rightIV.image = [UIImage imageNamed:@"acquiesceheader.png"];
        }
        
        bgRightIV.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
        labelRight.text = mm.megText;
        timeLabel.text = [self dateToStringWithTimeStamp: mm.megDate];
        
        return cell;
    }
    
}

- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    CGFloat height;
    GSMegModel * mm = [_dataSource objectAtIndex:indexPath.row];
//    if (mm.isReceiver) {
//        UIImageView * leftIV;
//        if (mm.megSize.height <  38.176){
//            leftIV = (UIImageView *)[cell viewWithTag:201];
//        }
//        else{
//            leftIV = (UIImageView *)[cell viewWithTag:101];
//        }
//        
//        height = leftIV.frame.size.height /40.f * (23+mm.megSize.height+30);
//    }
//    else{
//        UIImageView * rightIV;
//        if (mm.megSize.height <  38.176){
//            rightIV = (UIImageView *)[cell viewWithTag:401];
//        }
//        else{
//            rightIV = (UIImageView *)[cell viewWithTag:301];
//        }
//        
//        height = rightIV.frame.size.height /40.f * (23+mm.megSize.height+30);
//    }
//
    
//    NSLog(@"%f     %f", height, mm.megSize.height);
    return 23+mm.megSize.height+30;//height+40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSMegModel * mm = [_dataSource objectAtIndex:indexPath.row];
    if (mm.isNewData) {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         [self performSegueWithIdentifier:@"ChatViewSegue" sender:indexPath];
    }
    
}


#pragma mark - segue传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"注: 对方为receiver, 登录用户为sender");
    
    if ([segue.identifier isEqualToString:@"ChatViewSegue"]) {
        
        id nextPage = segue.destinationViewController;
        
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        GSMegModel * mm = [_dataSource objectAtIndex:indexPath.row];
        [nextPage setValue:mm.megText forKey:@"content"];
       
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    long num = [_dataSource count];
    [_dataSource removeAllObjects];
    _pageIndex++;
    
    _dataSource = [[DataBaseManager sharedDataBaseManager] getDataWithUserID:_receiverID andPage:_pageIndex];
    long newNum = [_dataSource count] - num;
    
    [_tableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:newNum inSection:0]; //实现平滑加载功能
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
   
    
    [_slimeView endRefresh];

}


#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
//    [_menuController setMenuItems:nil];
    NSLog(@"inputTextViewWillBeginEditing");
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    NSLog(@"changeFrame");
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _tableView.frame;
        _tableView.frame = CGRectMake(0, rect.origin.y, rect.size.width, self.view.frame.size.height-rect.origin.y-toHeight);

    }];
    [self scrollViewToBottom:NO];

}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    [self requestSendMegWithTextMessage:textMessage];
    
}

#pragma mark - SendMegRequest
- (void)requestSendMegWithTextMessage:(NSString *)textMessage
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", _receiverID, @"receive_user_no", textMessage,@"content", nil];
    NSLog(@"%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createSendMegUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"数据获取失败");
                          return ;
                      }
                      
                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      NSString * timeStamp = [dataDict objectForKey:@"send_time"];
                      
                      GSMegModel * MM = [[GSMegModel alloc] initWithUserName:_receiverName andUserID:_receiverID andMegText:textMessage andMegDate:timeStamp andAsReceiver:NO andIsRead:YES andIsNewData:NO];
                      
                      [_dataSource addObject:MM];
                      
                      [[DataBaseManager sharedDataBaseManager] saveDataWithMegModel:MM];
                      
                      //延迟方式让tableView先计算contentsize, 然后再让焦点放在最低端
                      [UIView animateWithDuration:0.3 animations:^{
                          [_tableView reloadData];
                      }completion:^(BOOL finished) {
                          [self scrollViewToBottom:YES];
                      }];
                      
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                     }];
}

#pragma mark - 时间戳转时间字符串
- (NSString *)dateToStringWithTimeStamp:(NSString *)timeStamp
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //直接输出的话是机器码
    //或者是手动设置样式[formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSString *string = [formatter stringFromDate:date];
    
    return string;
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
