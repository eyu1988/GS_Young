//
//  DealLogTVC.m
//  young
//
//  Created by z Apple on 7/20/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "DealLogTVC.h"
#import "UrlFactory.h"
#import "ZSyncURLConnection.h"
#import "GlobleLocalSession.h"
#import "DealLogTableViewCell.h"
#import "PrimaryTools.h"



@interface DealLogTVC ()
@property (strong,nonatomic)NSMutableArray *dataList;
@end

@implementation DealLogTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.navigationItem.title = @"交易记录";
}

-(void)initData
{
    self.pageNo = 1;
    [self setupData:self.pageNo];
    [self initAccountInfo];
}
- (void)initAccountInfo
{
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyWalletInitInfoUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                NSDictionary *infoDict = [dataDict objectForKeyedSubscript:@"info"];
                self.incomeLabel.text =[NSString stringWithFormat:@"￥%@",[infoDict objectForKey:@"sz_zsr"]];
                self.expendLabel.text =[NSString stringWithFormat:@"￥%@",[infoDict objectForKey:@"sz_zzc"]];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
}

-(void)setupData:(int)pageNoParameter{

    if ([self isOrNotDataLoadLock:pageNoParameter]) return;
    
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id",[NSString stringWithFormat:@"%d",pageNoParameter],@"page", nil];
    
    [ZSyncURLConnection request:[UrlFactory createDealLogListUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                NSMutableArray *dataArray = [NSMutableArray arrayWithArray:
                                               [dateDict objectForKey:@"list"]];
                if (pageNoParameter == 1) {
                    self.dataList = [NSMutableArray arrayWithArray:dataArray];
                    [super stopDownPullRefreshAnimating];
                }else{
                    if ([dataArray count]!=0) self.pageNo++;
                    [self.dataList addObjectsFromArray:dataArray];
                    [super stopUpPullRefreshAnimating];
                }
                [self.tableView reloadData];
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
    
//    return 3;
    return [self.dataList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DealLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealLogTableViewCell" forIndexPath:indexPath];
    DealLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealLogTableViewCellNew" forIndexPath:indexPath];
    NSDictionary *dic =  self.dataList[indexPath.row];
    cell.dealName.text =[dic objectForKey:@"ming_cheng"];
    
    cell.dealAccount.text = [NSString stringWithFormat:@"%@·%@",[PrimaryTools insureNotNull:[dic objectForKey:@"laiyuan"]],[PrimaryTools insureNotNull:[dic objectForKey:@"zhanghao"]]];
    cell.dealMoney.text = [dic objectForKey:@"zhuan_ru"]==[NSNull null]? [NSString stringWithFormat:@"￥%@元",[dic objectForKey:@"zhuan_ru"]]
                            : [NSString stringWithFormat:@"￥%@元",[dic objectForKey:@"zhuan_chu"]];
    
    cell.dealTime.text = [dic objectForKey:@"lrsj"];
    cell.balance.text = [NSString stringWithFormat:@"￥%@元",[dic objectForKey:@"yu_e"]];
    if([dic objectForKey:@"srcusername"])
        cell.dealDetail.text = [NSString stringWithFormat:@"%@%@%@",[PrimaryTools insureNotNull:[dic objectForKey:@"srcusername"]],[PrimaryTools insureNotNull:[dic objectForKey:@"destusername"]],[PrimaryTools insureNotNull:[dic objectForKey:@"zhanghao"]]];
    else
        cell.dealDetail.text = @"";
    return cell;
}

-(BOOL)downPullLoadData
{
    [self initData];
    return NO;
}

-(BOOL)upPullLoadData
{   
    [self setupData:self.pageNo+1];
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
