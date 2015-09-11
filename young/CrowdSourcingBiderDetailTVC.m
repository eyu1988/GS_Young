//
//  CrowdSourcingBiderDetailTVC.m
//  young
//
//  Created by z Apple on 8/25/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "CrowdSourcingBiderDetailTVC.h"
#import "ColorfulRectAndUILabelTableHeader.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "CrowdSourcing.h"

@interface CrowdSourcingBiderDetailTVC ()
{
    BOOL _isAttented;
    UIButton * _addButton;
}
@end

@implementation CrowdSourcingBiderDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isAttented = NO;
    
    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initData
{
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    if (!_isAttented) {
        [_addButton setTitle:@"添加关注" forState:UIControlStateNormal];
    }
    else{
        [_addButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    [_addButton addTarget:self action:@selector(addAttent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:_addButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id",self.bidId,@"id" , nil];
    
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingBiderInfoUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                NSDictionary *toubiaoDict = [dataDict objectForKey:@"toubiao"];
                NSDictionary *userDict = [dataDict objectForKey:@"user"];
                self.requireTitleLabel.text = [toubiaoDict objectForKey:@"xqmc"];
                self.requireStateLabel.text = [CrowdSourcing getRequirementBidState:toubiaoDict ];
                self.biderNameLabel.text = [userDict objectForKey:@"nick_name"];
                self.projectNumLabel.text = [NSString stringWithFormat:@"%@", [userDict objectForKey:@"cjxq_count"] ];
                self.integralLabel.text =[NSString stringWithFormat:@"%@", [userDict objectForKey:@"jifen"] ];
                self.contactLabel.text = [NSString stringWithFormat:@"%@", [userDict objectForKey:@"mobile_phone"] ];
                self.requireDetailLabel.text = @"非招标人或投标人，不可见此字段。";
                self.buserNo = [toubiaoDict objectForKey:@"yh_id"];
                
            }else{
                
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

}

- (void)addAttent
{
    NSLog(@"关注操作");
    
    if (!_isAttented) {
        [self requestAddAttent];
        _isAttented = YES;
       
            [_addButton setTitle:@"取消关注" forState:UIControlStateNormal];
        
    }
    else{
        [self requestCancelAttent];
        _isAttented = NO;
        
            [_addButton setTitle:@"添加关注" forState:UIControlStateNormal];
  
    }
}

- (void) requestAddAttent
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId], @"login_id", _buserNo, @"buserNo", nil];
    
    NSLog(@"\n添加关注 :\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createAddAttentUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      //                                            NSLog(@"\ncomplaint :\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"添加关注 - 数据获取失败");
                          [PrimaryTools alert:@"关注失败, 请重新操作"];
                          return ;
                      }
                      
                      NSLog(@"添加关注成功");
                      [PrimaryTools alert:@"添加关注成功"];
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [PrimaryTools alert:@"添加失败, 请重新提交"];
                     }];

}

- (void) requestCancelAttent
{
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId], @"login_id", _buserNo, @"buserNo", nil];
    
    NSLog(@"\n取消关注 :\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createCancelAttentUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                      //                                            NSLog(@"\ncomplaint :\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"取消关注 - 数据获取失败");
                          [PrimaryTools alert:@"取消关注失败, 请重新操作"];
                          return ;
                      }
                      
                      NSLog(@"取消关注 - 数据获取成功");
                      [PrimaryTools alert:@"取消关注成功"];
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [PrimaryTools alert:@"添加失败, 请重新提交"];
                     }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==2) {
        ColorfulRectAndUILabelTableHeader *th = nil;
        th =  (ColorfulRectAndUILabelTableHeader*)[PrimaryTools getFristObjectFromNibByNibName:@"ColorfulRectAndUILabelTableHeader"];
        th.titleLabel.text = @"承接项目";
        
        [th setRetract:10];
        return th;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2){
        return 36;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

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
