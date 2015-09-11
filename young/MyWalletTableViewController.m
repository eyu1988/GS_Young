//
//  MyWalletTableViewController.m
//  young
//
//  Created by z Apple on 15/6/29.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "MyWalletTableViewController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "NSUserDefaultsHandle.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import "UpdatePayPassWordTVC.h"

@interface MyWalletTableViewController ()
@property (strong,nonatomic)NSDictionary *zgDict;
@end

@implementation MyWalletTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initDate];
    self.navigationItem.title = @"我的钱包";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDate];
}
- (void)initDate
{
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[NSUserDefaultsHandle getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyWalletInitInfoUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                NSDictionary *infoDict = [dataDict objectForKeyedSubscript:@"info"];
                self.incomeLabel.text = [NSString stringWithFormat:@"收入:￥%@",[infoDict objectForKey:@"sz_zsr"]];
                self.payLabel.text = [NSString stringWithFormat:@"支出:￥%@",[infoDict objectForKey:@"sz_zzc"]];
                self.balanceLabel.text =[NSString stringWithFormat:@"余额:￥%@",[infoDict objectForKey:@"sz_yue"]];
//                if ([[infoDict objectForKey:@"errorcode"] isEqualToString:@"need_zige"]) {
                    self.zgDict = [infoDict objectForKey:@"zige"];
//                }
                
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UpdatePayPassWord"]) {
         UpdatePayPassWordTVC *uppw = segue.destinationViewController;
        if ([[self.zgDict objectForKey:@"mimaConfirm"] intValue]==0) {
            uppw.isFirstSet = YES;
        }else{
            uppw.isFirstSet = NO;
        }
    }
   
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"BindZfbAndCard"]) {
        
       
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
        
        [ZSyncURLConnection request:[UrlFactory createBindZfbAndCardVerifyUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"result:%@",result);
                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                    NSDictionary *dateDict =[result objectForKey:@"data"];
                    [self.navigationController showViewController:[PrimaryTools createVcByMainStoryBoardIdentifier:@"BindZfbAndCardTVC"] sender:nil];
                    
                }else{
                    
                }
            });
        } errorBlock:^(NSError *error) {
            //        NSLog(@"error %@",error);
        }];

        return YES;
    }else if ([identifier isEqualToString:@"UpdatePayPassWord"]) {
        
        if ([[self.zgDict objectForKey:@"shoujiConfirm"] integerValue]!=1) {
            [PrimaryTools alert:@"您还未绑定手机，无法初始化支付密码，请先绑定手机后，再初始化支付密码。"];
            return NO;
        }

    }
    return YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
