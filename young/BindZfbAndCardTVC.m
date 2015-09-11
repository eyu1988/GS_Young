    //
//  BindZfbAndCardTVC.m
//  young
//
//  Created by z Apple on 15/7/1.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "BindZfbAndCardTVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "NSUserDefaultsHandle.h"
#import "GlobleLocalSession.h"
#import "ZfbIndexTableViewCell.h"
#import "PrimaryTools.h"
#import "BankCard.h"
#import "AutoLayoutByScale.h"
#import "ColorfulRectAndUILabelTableHeader.h"
#import "PrimaryTools.h"



#define ZFB_SECTION_NO 0
#define CARD_SCALE 2.77
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface BindZfbAndCardTVC ()
@property (strong,nonatomic)NSDictionary *zfbDic;
@property (strong,nonatomic)NSMutableArray *cards;

@end

@implementation BindZfbAndCardTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付宝与银行卡";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
}

- (void)initData
{
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createMyBindZfbAndCardIndexUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                self.zfbDic = [dateDict objectForKey:@"zfb"];
                self.cards = [[NSMutableArray alloc] initWithArray:[dateDict objectForKey:@"yinhangkas"]];
                [self.tableView reloadData];
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return section==0 ? 1 : [self.cards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section==ZFB_SECTION_NO){
      ZfbIndexTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"BindZfbIndexCell"];
        
        
        if(self.zfbDic){
            cell.zfbAccountField.text = [self.zfbDic objectForKey:@"account"];
            cell.zfbBindDate.text =[self.zfbDic objectForKey:@"zfb_bangding_shijian"];
            cell.textLabel.text = @"";
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zfb_background_yellow.png"]];
            [cell setAlreadyBindView];
        }else{
            [cell setNotBindView];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindCardIndexCell"];
        AutoLayoutByScale *bs = [[AutoLayoutByScale alloc] init];
        BankCard *bankCard = (BankCard*)[bs autoUpdateLayoutWithNibName:@"BankCard"];

        bankCard.bankName.text =[self.cards[indexPath.row] objectForKey:@"mingcheng"];
        bankCard.cardTypeName.text =[self.cards[indexPath.row] objectForKey:@"leixing"];
        bankCard.bindPhone.text =[NSString stringWithFormat:@"绑定的手机：%@",[self.cards[indexPath.row] objectForKey:@"shoujihao"]];
        bankCard.bindDate.text =[self.cards[indexPath.row] objectForKey:@"bangding_shijian"];
        bankCard.cardCode.text =[self.cards[indexPath.row] objectForKey:@"kahao"];
        cell.backgroundView = bankCard;
        
        return cell;
    }
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==ZFB_SECTION_NO ? @"我的支付宝":@"我的银行卡";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ZFB_SECTION_NO){
        return 120;
    }else
    return WIDTH/CARD_SCALE;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"BindZfbAndCard"]) {
        NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
        
        [ZSyncURLConnection request:[UrlFactory createUnreadMessageCountUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

                if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                    
                }else{
                    
                }
            });
        } errorBlock:^(NSError *error) {
            //        NSLog(@"error %@",error);
        }];
        return NO;
        
    }else return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
  
        if (indexPath.section==ZFB_SECTION_NO) {
            [self relieveZfb];
        }else
            [self relieveCardByIndexPathRow:indexPath.row];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }

}

-(void)relieveCardByIndexPathRow:(NSInteger)indexPathRow
{
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id",
                                  [self.cards[indexPathRow] objectForKey:@"id"] ,@"id"
                                  , nil];
    
    [ZSyncURLConnection request:[UrlFactory createDeleteBindCardUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                NSDictionary *dateDict =[result objectForKey:@"data"];
                [self.cards removeObjectAtIndex:indexPathRow];

                [self.tableView reloadData];
            }else{
                [PrimaryTools alert:@"解除绑定银行卡失败"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

    
}

-(void)relieveZfb
{
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createDeleteZfbBindAccountUrl ]  requestParameter: formParamter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                NSDictionary *dateDict =[result objectForKey:@"data"];
                [PrimaryTools alert:@"解除绑定成功！"];
                self.zfbDic = nil;
                [self.tableView reloadData];
            }else{
                [PrimaryTools alert:@"解除绑定失败,请重试！"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解除绑定";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    ColorfulRectAndUILabelTableHeader *tableHeader = (ColorfulRectAndUILabelTableHeader*)[PrimaryTools getFristObjectFromNibByNibName:@"ColorfulRectAndUILabelTableHeader"] ;
    tableHeader.titleLabel.text = section==ZFB_SECTION_NO ? @"我的支付宝" : @"我的银行卡";
    
    return tableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;//section头部高度
}


@end
