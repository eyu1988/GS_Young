//
//  GSMegModel.h
//  ChatDemo
//
//  Created by Lucas on 15/8/7.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSMegModel : NSObject

@property(nonatomic, strong) NSString * userName;
@property(nonatomic, strong) NSString * userID;
@property(nonatomic, strong) NSString * megText; /**< 信息内容文本 */
@property(nonatomic, strong) NSString * megDate; /**< 信息日期 */
@property(nonatomic, strong) NSString * news_sub_id;
@property(nonatomic) BOOL isReceiver;
@property(nonatomic) BOOL isRead;
@property(nonatomic) BOOL isNewData;

@property(nonatomic) CGSize  megSize; /**< 文本显示区域大小 */
@property(nonatomic) CGSize  singleLineSize;

//- (id)initWithMegText:(NSString *)megText andMegDate:(NSString *)megDate andAsReceiver:(BOOL)isReceiver;

- (id)initWithUserName:(NSString *)userName andUserID:(NSString *)userID andMegText:(NSString *)megText andMegDate:(NSString *)megDate andAsReceiver:(BOOL)isReceiver andIsRead:(BOOL)isRead andIsNewData:(BOOL)isNewData ;

- (CGSize)textSizeWithMegText:(NSString *)megText;
@end
