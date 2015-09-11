//
//  ChooseJobTypeTVC.m
//  young
//
//  Created by z Apple on 8/11/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "ChooseJobTypeTVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@interface ChooseJobTypeTVC ()
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部类型信息
@property(strong,nonatomic) NSMutableSet* chooseSet; //保存选择的类型信息
@property(strong,nonatomic) NSMutableSet* chooseIdSet; //保存选择的类型信息
@property(strong,nonatomic) NSMutableDictionary* chooseDict; //保存选择的类型信息
@end

@implementation ChooseJobTypeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}
- (void)initData
{
    [[[GlobleLocalSession getLoginUserInfo] objectForKey:@"myMajor"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.chooseDict setObject:[[obj objectForKey:@"columns"] objectForKey:@"mc"] forKey:[[obj objectForKey:@"columns"] objectForKey:@"id"]];
    }];
    [ZSyncURLConnection request:[UrlFactory createRequirementTypeTreeUrl] completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            self.dataArray = [[NSMutableArray alloc] init];
            NSLog(@"data-tree:%@",[[dict objectForKey:@"data"] objectForKey:@"tree" ]);
            self.dataArray =[[dict objectForKey:@"data"] objectForKey:@"tree" ];
            
            NSLog(@"self.chooseDict:%@",self.chooseDict);
            [self.tableView reloadData];
        });}
                     errorBlock:^(NSError *error) {
                         //                         NSLog(@"error %@",error);
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
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[[self.dataArray objectAtIndex:section] objectForKey:@"children"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseJobTypeCell" forIndexPath:indexPath];
    
    cell.textLabel.text =  [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"children"] objectAtIndex:indexPath.row] objectForKey:@"mc"];
    NSNumber *jobTypeId = [[self.dataArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"id"];
    
    if([self.chooseDict objectForKey:jobTypeId]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section ] objectForKey:@"mc"] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *jobTypeId = [[self.dataArray[indexPath.section] objectForKey:@"children"][indexPath.row] objectForKey:@"id"];
    
    if ([self.chooseDict objectForKey:jobTypeId]){
        NSLog(@"如果存在");
        [self.chooseDict removeObjectForKey:jobTypeId];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [self.chooseDict setObject:cell.textLabel.text forKey:jobTypeId];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    NSLog(@"chooseDict:%@",self.chooseDict);
 
}
- (NSMutableDictionary*)chooseDict
{
    if (!_chooseDict) {
        _chooseDict = [[NSMutableDictionary alloc] init];
    }
    return _chooseDict;
}

- (NSMutableSet*)chooseSet
{
    if (!_chooseSet) {
        _chooseSet = [[NSMutableSet alloc] init];
    }
    return _chooseSet;
}

- (NSMutableSet*)chooseIdSet
{
    if (!_chooseIdSet) {
        _chooseIdSet = [[NSMutableSet alloc] init];
    }
    return _chooseIdSet;
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

- (IBAction)save:(id)sender {
    
    NSLog(@"chooseDict.keys:%@",[self.chooseDict allKeys]);
    
    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id",[self.chooseDict.allKeys componentsJoinedByString:@","]
                                   ,@"major"
                                   , nil];
    
    [ZSyncURLConnection request:[UrlFactory createUpdateUserInfoUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                [GlobleLocalSession setLoginUserInfo:dateDict];
                [PrimaryTools alert:@"修改成功！"];
                [PrimaryTools backLayer:self backNum:1];
            }else{
                [PrimaryTools alert:@"修改失败,请重试！"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

}
@end
