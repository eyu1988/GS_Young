//
//  MessageDetailVC.m
//  young
//
//  Created by z Apple on 15/4/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "MessageDetailVC.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"

@implementation MessageDetailVC

- (void) viewDidLoad{
    self.messageContentByHtml.delegate=self;
    [super viewDidLoad];
    [self initData];
   
}

-(void)initData
{
    NSString *loginId = [[GlobleLocalSession getLoginUserInfo] objectForKey:@"login_id"];


    NSDictionary *formparamter = [NSDictionary dictionaryWithObjectsAndKeys:self.messageId,@"id"
                                  ,loginId,@"login_id"
                                  ,nil];
    [ZSyncURLConnection request:[UrlFactory createMessageDetailUrl] requestParameter:formparamter  completeBlock:^(NSData *data) {
//        NSLog(@"formparamter:%@",formparamter);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"detail:%@",dict);
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                self.messageDic =[dict objectForKey:@"data"];
                self.userName.text = [self.messageDic objectForKey:@"sender_user_name"];
               
                NSString* htmlString = [NSString stringWithFormat:
                                         @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 38pt; color: red;'><B>%@</B><br></div><div style='width: 100%%; text-align: left; font-size: 32pt; color: black;'><br>&nbsp&nbsp&nbsp&nbsp%@</div></body></html>",[self.messageDic objectForKey:@"title"],
                                         [[self.messageDic objectForKey:@"content"]  stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>" ]];
                [self.messageContentByHtml loadHTMLString: htmlString baseURL:nil];
//                @"" stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"
                
                self.sendTime.text =[self.messageDic objectForKey:@"create_time"];
                [PrimaryTools setHeadImage:self.headImage userNo:[self.messageDic objectForKey:@"sender_user_no"]];
            }
//            NSLog(@"dictresult:%@",dict);
        });}
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType== UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}


@end
