//
//  Suggestion Controller.m
//  young
//
//  Created by z Apple on 15/4/9.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "SuggestionController.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@interface SuggestionController ()

@end

@implementation SuggestionController



- (void)viewDidLoad {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [super viewDidLoad];
    self.suggestionText.delegate =self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (self.suggestionText.text.length == 0) {
        
        self.textViewPlaceHolder.text=@"请留下您的宝贵意见";
    }else{
        self.textViewPlaceHolder.text=@"";
    }
    
}


- (IBAction)save:(id)sender {
    
//    @property (weak, nonatomic) IBOutlet UITextView *suggestionText;
//    @property (weak, nonatomic) IBOutlet UITextField *contactField;
    
    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.suggestionText.text ,@"content"
                                  ,self.contactField.text,@"qq",nil];
    [ZSyncURLConnection request:[UrlFactory createAddSuggestionUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {
//        NSLog(@"formparamter:%@",formparamter);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                [self alert:@"反馈成功！"];
                [PrimaryTools backLayer:self backNum:1];
                
            }else{
                [self alert:@"反馈失败！"];
            }
//            NSLog(@"dictresult:%@",dict);
        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
    
}

-(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

@end
