//
//  MyCenterTableController.m
//  young
//
//  Created by z Apple on 15/3/24.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "MyCenterTableController.h"
#import "HomeTableController.h"
#import "AppDelegate.h"
#import "NSUserDefaultsHandle.h"
#import "SeePhotoViewController.h"
#import "NullHandler.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "NSUserDefaultsHandle.h"
#import "CrowdSourcingTableViewController.h"
#import "ViewInfoByWebUIController.h"
#import "ComplaintListViewController.h"
#import "Message.h"
#import "ZActivity.h"
#import "WeiXinSocialShare.h"
#import "SinaWeiboSocialShare.h"

#define SECTION_ONE_COUNT 3
#define SECTION_TWO_COUNT 9

@implementation MyCenterTableController
static CGFloat kImageOriginHight = 10;
static CGFloat kTempHeight = 285.0f;

- (void) viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self initArray];
    [self setCircleButton:self.headImage];
    [self setLoginButtonStyle];
  
    [super viewDidLoad];
}
-(void)setLoginButtonStyle
{
    self.intoLoginButton.layer.masksToBounds = YES;
    self.intoLoginButton.layer.cornerRadius = 10;
}

-(void)setCircleButton:(UIButton *)button
{
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = self.headImage.bounds.size.width/2;
}

-(void)initArray
{
    self.aList = @[
                   [NSDictionary dictionaryWithObjectsAndKeys:@"MyDateManagerTableViewController",@"pushViewController",@"个人资料",@"title",
                    @"user_identity.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"BindPhoneVC",@"pushViewController",
                    @"绑定的手机",@"title",
                    @"user_phone.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"MyWalletTVC",@"pushViewController",
                                       @"我的钱包",@"title",
                                       @"wallet.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"UserAutonymVerifyTVC",@"pushViewController",
                    @"实名认证",@"title",
                    @"autonym_verify.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"StudentStatusVerifyTVC",@"pushViewController",
                    @"学生认证",@"title",
                    @"student_verify.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"GraduateStatusVerifyTVC",@"pushViewController",
                    @"毕业生认证",@"title",
                    @"graduate_verify.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"EnterpriseStatusVerifyTVC",@"pushViewController",
                    @"企业认证",@"title",
                    @"enterprise_verify.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"SuggestionController",@"pushViewController",
                    @"反馈意见",@"title",
                    @"user_feedback.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"ComplaintListViewController",@"pushViewController",
                    @"投诉信息",@"title",
                    @"icon_complaint.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"",@"pushViewController",
                    @"邀请好友",@"title",
                    @"invite_friend.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"BaseWebUI",@"pushViewController",
                    @"帮助",@"title",
                    @"user_help.png",@"image", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"AboutUsTVC",@"pushViewController",
                    @"关于",@"title",
                    @"user_about.png",@"image", nil]
                   ];
}

-(NSDictionary*)getOneThingFormAlist:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return self.aList[indexPath.row + SECTION_ONE_COUNT];
    }else return self.aList[indexPath.row];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(![NullHandler isNullOrNilOrNSNull:delegate.loginUser]){
        _userName.hidden = NO;
        _userName.text=[NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[delegate.loginUser objectForKey:@"nick_name"]];
        _logoutButton.hidden = NO;
        _intoLoginButton.hidden = YES;
    }else{
        
        _userName.hidden = YES;
        _logoutButton.hidden = YES;
        _intoLoginButton.hidden = NO;
    }
    
    
    [PrimaryTools setHeadImage:self.headImage userNo:[delegate.loginUser objectForKey:@"user_no"]];
    
    [GlobleLocalSession initUserInfoByNet:^(NSData *data) {
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
   
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    //    NSLog(@"yOffset===%f",yOffset);
    CGFloat xOffset = (yOffset + kImageOriginHight)/2;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.headerImage.frame;
        f.origin.y = yOffset-80;
        f.size.height =  -yOffset + kTempHeight;
        f.origin.x = xOffset;
        f.size.width = self.view.frame.size.width + fabs(xOffset)*2;
        self.headerImage.frame = f;
    }
}


#pragma mark -tableSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
   if (section==0) {
        return SECTION_ONE_COUNT;
    }else if (section==1) {
        return SECTION_TWO_COUNT;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyCenterIndexCell = @"MyCenterIndexCell";
    NSDictionary *dictionary = [self getOneThingFormAlist:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCenterIndexCell];
    cell.imageView.image= [UIImage imageNamed:[dictionary objectForKey: @"image"]];

    cell.textLabel.text = [dictionary objectForKey: @"title"];
    if([[dictionary objectForKey:@"title"] isEqualToString:@"绑定的手机"]){
        if (((NSString*)[[GlobleLocalSession getLoginUserInfo] objectForKey:@"mobile_phone"]).length==0) {
            cell.detailTextLabel.text = @"未绑定";
        }else{
            cell.detailTextLabel.text = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"mobile_phone"];
        }
    }else if([[dictionary objectForKey:@"title"] isEqualToString:@"我的钱包"]){
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"余额:￥%@",[PrimaryTools insureNotNull:[[GlobleLocalSession getLoginUserInfo] objectForKey:@"qianbao_jine"]]];
    }else if([[dictionary objectForKey:@"title"] isEqualToString:@"实名认证"]){
        [self setAutonymVerifyCell:cell];
    }else if([[dictionary objectForKey:@"title"] isEqualToString:@"学生认证"]){
        [self setStudentVerifyCell:cell];
    }else if([[dictionary objectForKey:@"title"] isEqualToString:@"毕业生认证"]){
        [self setGraduateVerifyCell:cell];
    }else if([[dictionary objectForKey:@"title"] isEqualToString:@"企业认证"]){
       [self setEnterpriseVerifyCell:cell];
    }else{
        [cell setUserInteractionEnabled:YES];
        [cell setBackgroundColor:[UIColor whiteColor]];

        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MyCenterStoryboard" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO];
      UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0) {
        if(([[self.aList[indexPath.row] objectForKey:@"title"] isEqualToString:@"个人资料"]
            ||[[self.aList[indexPath.row] objectForKey:@"title"] isEqualToString:@"绑定的手机"]
            ||[[self.aList[indexPath.row] objectForKey:@"title"] isEqualToString:@"我的钱包"]
            )
           &&![GlobleLocalSession getLoginUserInfo]
           ){
            [GlobleLocalSession checkLoginState:self];
            return;
        }
        
        UIViewController *pushVC = [storyboard instantiateViewControllerWithIdentifier:[self.aList[indexPath.row] objectForKey:@"pushViewController"]];
            
        [self.navigationController pushViewController: pushVC animated:YES];
        
    }else{
        if([[[self getOneThingFormAlist:indexPath] objectForKey:@"title"] isEqualToString:@"实名认证"]
            ||[[[self getOneThingFormAlist:indexPath] objectForKey:@"title"] isEqualToString:@"学生认证"]
            ||[[[self getOneThingFormAlist:indexPath] objectForKey:@"title"] isEqualToString:@"毕业生认证"]
            ||[[[self getOneThingFormAlist:indexPath] objectForKey:@"title"] isEqualToString:@"企业认证"]){
            
            if(![GlobleLocalSession getLoginUserInfo]){
                [GlobleLocalSession checkLoginState:self];
                return;
            }else{
                if (![cell.detailTextLabel.text isEqualToString:@"未认证"]) {
                    [self alert:cell.detailTextLabel.text];
                    return;
                }
            }
        }
        if([[[self getOneThingFormAlist:indexPath] objectForKey:@"title"] isEqualToString:@"邀请好友"]){
            if(![GlobleLocalSession getLoginUserInfo]){
                [GlobleLocalSession checkLoginState:self];
                return;
            }else{
                [self socialShare];
                return;
            }
        }
        
        UIViewController *pushVC;
        if([[[self getOneThingFormAlist:indexPath] objectForKey:@"pushViewController"] isEqualToString:@"BaseWebUI"])//help
        {
            pushVC = [[ViewInfoByWebUIController alloc] initWithNibName:@"BaseWebUI" bundle:nil];
            ((ViewInfoByWebUIController*)pushVC).strUrl = [UrlFactory createHelpUrl];
        }else if([[[self getOneThingFormAlist:indexPath] objectForKey:@"pushViewController"] isEqualToString:@"ComplaintListViewController"]){
            pushVC = [[ComplaintListViewController alloc] initWithNibName:@"ComplaintListViewController" bundle:nil];
        }
        else{
            pushVC = [storyboard instantiateViewControllerWithIdentifier:[[self getOneThingFormAlist:indexPath] objectForKey:@"pushViewController"]];
        }
        
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }
}


-(BOOL)enterPriseNotNeedToVerify:(UITableViewCell *)cell
{
    if ([[[GlobleLocalSession getLoginUserInfo] objectForKey:@"company_auth"] intValue]!=0) {
        cell.detailTextLabel.text =@"企业用户无需认证";
        return YES;
    }
    return NO;
}
-(BOOL)automynVerifyFirst:(UITableViewCell *)cell
{
    if ([[[GlobleLocalSession getLoginUserInfo] objectForKey:@"real_anth"] intValue]==0) {
        cell.detailTextLabel.text =@"请先实名认证";
        return YES;
    }
    return NO;
}
-(void)setAutonymVerifyCell:(UITableViewCell *)cell
{
    if ([self enterPriseNotNeedToVerify:cell])
        return;
    NSNumber *tache = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"real_anth"];
    cell.detailTextLabel.text = [self getVerifyTacheForDisplay:tache];
}
-(void)setStudentVerifyCell:(UITableViewCell *)cell
{
    if ([self enterPriseNotNeedToVerify:cell])
        return;
    if ([self automynVerifyFirst:cell])
        return;
    NSNumber *tache = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"stu_anth"];
    cell.detailTextLabel.text = [self getVerifyTacheForDisplay:tache];
}
-(void)setGraduateVerifyCell:(UITableViewCell *)cell
{
    if ([self enterPriseNotNeedToVerify:cell])
        return;
    if ([self automynVerifyFirst:cell])
        return;
    NSNumber *tache = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"gra_auth"];
    cell.detailTextLabel.text = [self getVerifyTacheForDisplay:tache];
}
-(void)setEnterpriseVerifyCell:(UITableViewCell *)cell
{
    if ([[[GlobleLocalSession getLoginUserInfo] objectForKey:@"real_anth"] intValue]!=0) {
        cell.detailTextLabel.text =@"个人用户无需认证";
        return;
    }
    NSNumber *tache = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"company_auth"];
    cell.detailTextLabel.text = [self getVerifyTacheForDisplay:tache];
}

-(NSString*)getVerifyTacheForDisplay:(NSNumber*)tache
{
    if ([tache intValue] ==0) {
        return @"未认证";
    }else if ([tache intValue] ==1) {
        return @"认证中";
    }else if ([tache intValue] ==2) {
        return @"已认证";
    }else {
        return @"未知状态";
    }
}


#pragma mark -action

-(void)socialShare
{
        NSArray *shareButtonTitleArray = @[@"微信",@"微信朋友圈",@"新浪微博"];
        NSArray *shareButtonImageNameArray = @[@"icon_other/sns_icon_22",@"icon_other/sns_icon_23",@"icon_other/sns_icon_1"];
        self.tapIndex++;
        ZActivity *zActivity = [[ZActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [zActivity showInView:self.view];
}

- (IBAction)clickLogout:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                   message:@"您确定要退出登录吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                                          delegate.loginUser=nil;
                                                          [NSUserDefaultsHandle clearNSUserDefaults];
                                                          [Message markUnreadMessageCount];
                                                          [self viewWillAppear:YES];
                                                          
                                                      }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearMessage" object:self];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    
}

#pragma mark -segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier:%@",segue.identifier);
    if([segue.identifier isEqualToString:@"See Photo"]){
        
        SeePhotoViewController *seePhoto = [segue destinationViewController];
        seePhoto.image =self.headImage.imageView.image;
        
    }else if([segue.identifier isEqualToString:@"myReleasedCrowdSourcing"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.entryParamter = [[NSMutableDictionary alloc] init];
        [c.entryParamter setObject:@"1" forKey:@"my"];
        NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];
        [c.entryParamter setObject:loginId forKey:@"login_id"];
        
        c.navigationItem.title = @"我发布的";
    }else if([segue.identifier isEqualToString:@"myBidCrowdSourcing"]){
        CrowdSourcingTableViewController *c = [segue destinationViewController];
        c.entryParamter = [[NSMutableDictionary alloc] init];
        [c.entryParamter setObject:@"1" forKey:@"my_qiang"];
        NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];
        [c.entryParamter setObject:loginId forKey:@"login_id"];
        
        c.navigationItem.title = @"我参与的";
    }
    
}


#pragma mark - ZActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createShareRegisterUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                NSString *shareUrl = [dateDict objectForKey: @"regist_page"];
                NSString *title =@"青春号，我的青春我做主！青春号喊你来领工资啦！" ;
                NSString *description = @"青春号是“中国工业淘堡网”上面向于企业和大学生，为企业淘人才，为大学生淘工作的众创空间。企业把项目和工作登记青春号上，青春号上的“青葱”们用大葱的价格帮助企业完成众包任务，确保人力成本减少一半以上。";
                if (imageIndex==0) {
                    //微信
                    [WeiXinSocialShare sendLinkContent:title description:description image:nil url:shareUrl wxShareScene:WXShareSceneSession];
                }else if((int)imageIndex==1){
                    //朋友圈
                    [WeiXinSocialShare sendLinkContent:title description:description image:nil url:shareUrl wxShareScene:WXShareSceneTimeline];
                }else if((int)imageIndex==2){
                    //微博
                    [SinaWeiboSocialShare sendTextAndPicture:[NSString stringWithFormat:@"%@%@",title,shareUrl] pictureData:
                     [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon-152" ofType:@"png"]]
                     ];
                }
            }else{
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
   
}
-(void) alert:(NSString*)msg
{
    [PrimaryTools alert:msg];
    self.navigationController.navigationBarHidden = YES;//弹出提示框后仍然隐藏导航条
}
- (void)didClickOnCancelButton
{
//    NSLog(@"didClickOnCancelButton");
}



@end
