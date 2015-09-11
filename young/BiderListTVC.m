//
//  BiderListTVC.m
//  young
//
//  Created by z Apple on 8/21/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "BiderListTVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "RequireListCell.h"
#import "BiderListCell.h"
#import "PrimaryTools.h"

@interface BiderListTVC ()

@end

@implementation BiderListTVC

- (void)viewDidLoad {
    
   [super viewDidLoad];
    
}
- (void)initData
{

    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:self.requirementId,@"xuqiuId", nil];
    
    [ZSyncURLConnection request:[UrlFactory createCrowdSourcingBiderListUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"initData-result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dataDict =[result objectForKey:@"data"];
                self.dataDictionary = dataDict;
                self.dataList = [dataDict objectForKey:@"list"];
//                NSLog(@"self.dataList:%@",self.dataList);
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.

    return [self.dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BiderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BiderListCell" forIndexPath:indexPath];
    NSLog(@"cell:%@",cell);
    cell.nickNameLabel.text = [self.dataList[indexPath.row] objectForKey:@"nick_name"];
//    cell.headImageView
    [PrimaryTools setHeadImage:cell.headImageView userNo:[self.dataList[indexPath.row] objectForKey:@"yh_id"]];
    
//    self.dataList[indexPath.row]
//    self.dataList
    // Configure the cell...
    
    
    CGRect frame = cell.frame;
    frame.size.height = 300;
    
    [cell setFrame:frame];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    return 108;
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}



//override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    return UITableViewAutomaticDimension
//}


- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了子cell");
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
