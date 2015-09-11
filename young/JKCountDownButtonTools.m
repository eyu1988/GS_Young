//
//  JKCountDownButtonTools.m
//  young
//
//  Created by z Apple on 7/7/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "JKCountDownButtonTools.h"
#import "JKCountDownButton.h"

@implementation JKCountDownButtonTools
+(void)disableSendButton:(JKCountDownButton*)sender
{
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
    }];
}
@end
