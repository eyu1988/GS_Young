//
//  GSMegModel.m
//  ChatDemo
//
//  Created by Lucas on 15/8/7.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//
#define LABELWIDTH 210//195
#import "GSMegModel.h"

#define TEXTFONT 16

@implementation GSMegModel
//- (id)initWithMegText:(NSString *)megText andMegDate:(NSString *)megDate andAsReceiver:(BOOL)isReceiver
//{
//    self = [super init];
//    if (self) {
//        _megText = megText;
//        _megDate = megDate;
//        _isReceiver = isReceiver;
//        _megSize = [self textSizeWithMegText:megText];
//    }
//    return self;
//}

- (id)initWithUserName:(NSString *)userName andUserID:(NSString *)userID andMegText:(NSString *)megText andMegDate:(NSString *)megDate andAsReceiver:(BOOL)isReceiver  andIsRead:(BOOL)isRead andIsNewData:(BOOL)isNewData
{
    self = [super init];
    if (self) {
        _userName = userName;
        _userID = userID;
        _megText = megText;
        _megDate = megDate;
        _isReceiver = isReceiver;
        _isRead = isRead;
        _isNewData = isNewData;
        _megSize = [self textSizeWithMegText:megText];
        _singleLineSize = [self textSizeWithMegText:megText];
//        NSLog(@"文本字体大小: %d", TEXTFONT);
    }
    return self;
}

- (CGSize)textSizeWithMegText:(NSString *)megText
{
    if ([megText isEqualToString:@""]) {
        megText = @"a"; //设定默认的文本大小
    }
    megText = [self filterHTML:megText];
    
    CGSize size = CGSizeMake(LABELWIDTH,CGFLOAT_MAX);//LableWight标签宽度，固定的
    
    UIFont * tfont = [UIFont systemFontOfSize:TEXTFONT];
    
    //获取当前文本的属性
    NSDictionary *tdic=[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize = [megText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;

    return actualsize;
}

- (CGSize)singleLineSizeWithMegText:(NSString *)megText
{
    CGSize size = CGSizeMake(CGFLOAT_MAX,19.088);//LableWight标签宽度，固定的
    
    UIFont * tfont = [UIFont systemFontOfSize:16];
    
    //获取当前文本的属性
    NSDictionary *tdic=[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize = [megText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize;
}

- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

@end
