//
//  WithdrawCashTableViewController.m
//  young
//
//  Created by z Apple on 15/6/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "WithdrawCashTableViewController.h"
#import "ZSyncURLConnection.h"
#import "NSUserDefaultsHandle.h"
#import "UrlFactory.h"
#import "PrimaryTools.h"
#import "NullHandler.h"
#import "GlobleLocalSession.h"
#import "ZSYPopoverListView.h"
#import "JKCountDownButtonTools.h"


@interface WithdrawCashTableViewController ()<UITextViewDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate>
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic,retain) NSMutableArray *accountList;
@property (nonatomic,retain) NSMutableArray *accountDictList;
@end

@implementation WithdrawCashTableViewController

double balance;
NSString *payWay;
NSString *cardId;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"取现";
    [self initData];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"申请提现需同时满足以下条件：\n▸  用户须通过手机认证；\n▸  用户须设置钱包支付密码；\n▸  用户须绑定支付宝或银行卡；" attributes:attributes];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"phoneBind"
                             range:[[attributedString string] rangeOfString:@"手机认证"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"setWalletPassword"
                             range:[[attributedString string] rangeOfString:@"设置钱包支付密码"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"bindZhifubao"
                             range:[[attributedString string] rangeOfString:@"绑定支付宝或银行卡"]];
    
    NSMutableArray *rangeArr = [PrimaryTools findAllRangeFrom: [attributedString string] bySubString:@"▸"];
    [rangeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSRangeFromString(obj)];
    }];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.note.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.note.attributedText = attributedString;
    self.note.font = [UIFont fontWithName:@"Arial" size:20.0];
    self.note.delegate = self;
    
}
-(void)initData
{
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", nil];
    
    [ZSyncURLConnection request:[UrlFactory createInitWithdrawCashUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *infoDict = [[result objectForKey:@"data"] objectForKey:@"info"];
                self.moneyField.placeholder =[NSString stringWithFormat:@"当前余额%@元",[PrimaryTools insureNotNull:[infoDict objectForKey:@"ketixian_jine"]]];
            }else{
                [PrimaryTools alert:@"初始化失败！"];
                [PrimaryTools backLayer:self backNum:1];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    

    
    formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyBindZfbAndCardIndexUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result---:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                [self.accountList addObject:[NSString stringWithFormat:@"支付宝:%@",[[dateDict objectForKey:@"zfb"] objectForKey:@"account"]]];
#warning there is a error
                [self.accountDictList addObject:[dateDict objectForKey:@"zfb"]];
                 NSArray *cards=[dateDict objectForKey:@"yinhangkas"];
                 [ cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         [self.accountList addObject:
                         [NSString stringWithFormat:@"银行卡:%@",[cards[idx] objectForKey:@"kahao"]]];
                         [self.accountDictList addObject:cards[idx]];
                 } ];
            }else{
                
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submit:(id)sender {

    if([self.accountButton.titleLabel.text isEqualToString:@"选择账号"]){
        [PrimaryTools alert:@"请选择账户信息。"];
        return;
    }
    if(self.moneyField.text.length==0){
        [PrimaryTools alert:@"请填写提现金额。"];
        return;
    }
    if(self.payPwdField.text.length==0){
        [PrimaryTools alert:@"请填写支付密码。"];
        return;
    }
    if(self.checkCodeLabel.text.length==0){
        [PrimaryTools alert:@"请填短信验证码。"];
        return;
    }
    
    
    NSString * loginName = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"ln"];
    
    NSMutableDictionary *formParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [GlobleLocalSession getLoginId],@"login_id"
                                  ,self.moneyField.text,@"jine"
                                         ,[PrimaryTools md5HexDigest:
                                           [NSString stringWithFormat:@"%@%@",loginName,self.payPwdField.text]
                                           ],@"zfmm"
                                  ,self.checkCodeLabel.text,@"code"
                                  ,payWay,@"tixian_fangshi"
                                  , nil];
    
    if ([payWay isEqualToString:@"yinhangka"]) {
        [formParamter setObject:cardId forKey:@"kaid"];
    }
    
    [ZSyncURLConnection request:[UrlFactory createWithdrawCashUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"submit-result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                [PrimaryTools alert:@"提现申请成功！"];
                [PrimaryTools backLayer:self backNum:1];
            }else{
                [self analyseError:[result objectForKey:@"msg"]];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}
- (void)analyseError:(NSDictionary*)msgDict
{
    NSString *errorStr = [msgDict objectForKey:@"errorcode"];
    if ([errorStr isEqualToString:@"jine_xiaoyu_xiaxian"]) {
        [PrimaryTools alert:[NSString stringWithFormat:@"提现失败，最小提现金额为%@元！",[msgDict objectForKey:@"jine_xiaxian"]]];
    }else if([errorStr isEqualToString:@"jine_buzu"]){
        [PrimaryTools alert:[NSString stringWithFormat:@"提现失败，当前可提现金额为%@元！",[msgDict objectForKey:@"jine_shangxian"]]];
    }else if([errorStr isEqualToString:@"error_mima_invalidate"]){
        [PrimaryTools alert:@"提现失败，支付密码错误！"];
    }else if([errorStr isEqualToString:@"error_yzm_invalidate"]){
        [PrimaryTools alert:@"提现失败，短信校验码错误！"];
    }else if([errorStr isEqualToString:@"error_yzm_invalidate"]){
        [PrimaryTools alert:@"提现失败，短信校验码错误！"];
    }else{
        [PrimaryTools alert:@"提现失败！"];
    }

}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
{
    NSLog(@"url:%@",URL);
//    NSLog(@"characterRange:%@",characterRange);
    
    return YES;
}


#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accountList count];
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.accountList[indexPath.row]];
    
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    NSLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"select:%ld", (long)indexPath.row);
    [self.accountButton setTitle:self.accountList[indexPath.row] forState:UIControlStateNormal];
    NSRange range = [self.accountList[indexPath.row] rangeOfString:@"银行卡:"];
    if (range.length==0) {
        payWay = @"zhifubao";
        [self.accountButton setTitle:[self.accountList[indexPath.row] stringByReplacingOccurrencesOfString:@"支付宝:" withString:@""] forState:UIControlStateNormal];
      
    }else{
        payWay = @"yinhangka";
        [self.accountButton setTitle:[self.accountList[indexPath.row]stringByReplacingOccurrencesOfString:@"银行卡:" withString:@""] forState:UIControlStateNormal];
        NSLog(@"self.accountDictList[indexPath.row]:%@",self.accountDictList[indexPath.row]);
        cardId = [self.accountDictList[indexPath.row] objectForKey:@"id"];
        
    }

}


- (IBAction)chooseAccount:(id)sender {
   
        ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 10, 200)];
        listView.titleName.text = @"请选择";
        listView.datasource = self;
        listView.delegate = self;
        [listView show];
     
}

- (NSMutableArray*)accountList{
    if (!_accountList) {
        _accountList = [[NSMutableArray alloc] init];
    }
    return _accountList;
}

- (NSMutableArray*)accountDictList{
    if (!_accountDictList) {
        _accountDictList = [[NSMutableArray alloc] init];
    }
    return _accountDictList;
}

- (IBAction)sendCheckButton:(JKCountDownButton *)sender {
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createWithdrawCashSendMessageCodeUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                //                [self disableSendButton:sender];
                [JKCountDownButtonTools disableSendButton:sender];
                [PrimaryTools alert:@"验证码发送成功,请耐心等待"];
            }else{
                [PrimaryTools alert:@"验证码发送失败,请重新发送"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
    
}
@end
