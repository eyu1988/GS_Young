//
//  AboutUsTVC.m
//  young
//
//  Created by z Apple on 15/4/18.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "AboutUsTVC.h"

@implementation AboutUsTVC
- (void)viewDidLoad {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [super viewDidLoad];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 if(indexPath.row==1)
 {
  
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:@"您要拨打客服电话吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://02488928703"]];
                                                           }];
         UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
         [alert addAction:yesAction];
         [alert addAction:noAction];
         [self presentViewController:alert animated:YES completion:nil];
 
   
 }else  if(indexPath.row==2){
     [self joinGroup:@"399305932"];
     
 }else  if(indexPath.row==3){
     
     NSURL *url = [NSURL URLWithString:@"http://www.qingchunhao.com"];
     [[UIApplication sharedApplication] openURL:url];
     
 }
    
}

- (BOOL)joinGroup:(NSString *)qq{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", qq,@"9a534e93d873f22d49d8a6ee2c5625c50a3ba8af710c38045d483f74fbc8ff54"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

@end
