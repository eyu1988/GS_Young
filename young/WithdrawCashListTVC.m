//
//  WithdrawCashListTVC.m
//  young
//
//  Created by z Apple on 7/30/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "WithdrawCashListTVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "WithdrawCashTableViewCell.h"
#import "PrimaryTools.h"
#import "NullHandler.h"

@interface WithdrawCashListTVC ()
@property (strong,nonatomic)NSArray *dataList;
@end

@implementation WithdrawCashListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"取现";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
}
-(void)initData
{
    self.dataList = [[NSArray alloc] init];
    
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyWalletInitInfoUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                NSDictionary *infoDict = [dataDict objectForKeyedSubscript:@"info"];
                self.balanceLabel.text =[NSString stringWithFormat:@"余额:￥%@",[infoDict objectForKey:@"sz_yue"]];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

    
    
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createWithdrawCashListUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                self.dataList = [dataDict objectForKey:@"tixianList"];
                [self.tableView reloadData];
                [super stopDownPullRefreshAnimating];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.dataList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawCashListCellNew" forIndexPath:indexPath];

      NSDictionary *dic =  self.dataList[indexPath.row];
      cell.moneyLabel.text = [NSString stringWithFormat: @"￥%@元",[dic objectForKey:@"jine"]];
    
      cell.applyForDateLabel.text =[NSString stringWithFormat:@"申请:%@",[NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"sqsj"]]];
    
      if([dic objectForKey:@"wcsj"]==[NSNull null]){
        cell.overDateLabel.text = @"------------";
      }else{
         cell.overDateLabel.text = [NSString stringWithFormat:@"完成:%@",[NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"wcsj"]]];;
      }
    
    
      cell.stateLabel.text = [NSString stringWithFormat:@"[%@]",[NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"tx_zt"]]];
    if ([[dic objectForKey:@"zhifu_fangshi"] intValue]==1) {
        //支付宝
        cell.accountLabel.text=[NSString stringWithFormat:@"账号:%@",[dic objectForKey:@"zfb"] ];
    }else{
        //银行卡
        cell.accountLabel.text=[NSString stringWithFormat:@"账号:%@",[dic objectForKey:@"yinhang_kahao"] ];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(BOOL)downPullLoadData
{
    [self initData];
    return NO;
}

-(BOOL)upPullLoadData
{
    NSLog(@"upPull");
    return NO;
}

-(void)checkPower
{
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", nil];
    
    [ZSyncURLConnection request:[UrlFactory createInitWithdrawCashUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                UIStoryboard* myCenterStoryboard = [UIStoryboard storyboardWithName:@"MyCenterStoryboard" bundle:nil];
                UIViewController* viewController = [myCenterStoryboard   instantiateViewControllerWithIdentifier:@"WithdrawCashTableViewController"];
                [self.navigationController showViewController:viewController sender:nil];
            }else{
                NSString *errorStr =[[result objectForKey:@"msg"] objectForKey:@"errorcode"];
                if(errorStr){
                    if ([errorStr isEqualToString:@"jine_wei_da_dao_biaozhun"]) {
                        [PrimaryTools alert:@"余额未达到可提现金额！"];
                    }
                }else{
                    NSDictionary *d = [[result objectForKey:@"msg"] objectForKey:@"zige"];
                    [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        if([obj intValue]==0){
                            [PrimaryTools alert:[self getErrorMsg:key]];
                        }
                    }];
                }
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}



-(NSString*)getErrorMsg:(NSString *)errorKey
{
    NSLog(@"errorKey:%@",errorKey);
    NSDictionary *dicErrorKey = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"未完成个人认证",@"gerenConfirm",
                                 @"未完成学生认证",@"xueShengConfirm",
                                 @"未完成毕业生认证",@"biyeshengConfirm",
                                 @"未完成企业认证",@"qiyeConfirm",
                                 @"未绑定手机",@"shoujiConfirm",
                                 @"未设置钱包密码",@"mimaConfirm",
                                 @"未绑定银行卡",@"yhkBind",
                                 @"未绑定支付宝",@"zfbBind",
                                 @"未绑定支付宝或银行卡",@"bangdingqianbaozhanghu",
                                 @"未绑定微信",@"weixinBind",
                                 @"未实名认证",@"shimingConfirm", nil];
    
    return [dicErrorKey objectForKey:errorKey];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self checkPower];
    return NO;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
