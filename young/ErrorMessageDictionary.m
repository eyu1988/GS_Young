//
//  ErrorMessageDictionary.m
//  young
//
//  Created by z Apple on 7/7/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "ErrorMessageDictionary.h"
#import "PrimaryTools.h"

@implementation ErrorMessageDictionary
+(NSString*)qualificationErrorMessage:(NSString *)errorKey
{
    NSDictionary *dicErrorKey = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"未完成个人认证",@"gerenConfirm",
                                 @"未完成学生认证",@"xueShengConfirm",
                                 @"未完成毕业生认证",@"biyeshengConfirm",
                                 @"未完成企业认证",@"qiyeConfirm",
                                 @"未绑定手机",@"shoujiConfirm",
                                 @"未设置钱包密码",@"mimaConfirm",
                                 @"未绑定银行卡",@"yhkBind",
                                 @"未绑定支付宝",@"zfbBind",
                                 @"未绑定微信",@"weixinBind",
                                 @"未实名认证",@"shimingConfirm", nil];
    
    return [dicErrorKey objectForKey:errorKey];

}

+(NSString*)bindBankCardErrorMsg:(NSString *)errorKey
{
    NSDictionary *dicErrorKey = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"卡号无效",@"card_not_valid",
                                 @"卡号在系统中已存在",@"ka_is_exist",
                                 @"银行无效",@"bank_not_valid",
                                 @"卡号无效",@"CARD_BIN_NOT_MATCH", nil];
//    if ([dicErrorKey objectForKey:errorKey]) {
//        [PrimaryTools alert:[dicErrorKey objectForKey:errorKey]];
//    }else
//        [PrimaryTools alert:@"未知错误"];
    return [dicErrorKey objectForKey:errorKey];
}


+(NSString*)postponeErrorMsg:(NSString *)errorKey
{
    NSDictionary *dicErrorKey = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"该续期周期超过了，原始的周期。（周期=截止日期-发布日期）",@"xuqiu_over_zhouqi",
                                 @"该需求中标人数已满，无法续期。",@"people_enough",
                                 @"该需求未过期，无法续期。",@"xuqiu_weiguoqi",
                                 @"该需求续期次数已经达到三次,无法续期。",@"xuqiu_no_cishu",
                                 @"该需求未发布,无法续期。",@"xuqiu_weifabu",
                                 @"设置的截止日期与完成日期不能等于或小于当前日期,无法续期。",@"parameter_invalidate: (zbjzrq or jhwcrq) < now",
                                 @"您要延期的需求不存在。",@"xuqiu_is_not_exist", nil];
    
    return [dicErrorKey objectForKey:errorKey]?[dicErrorKey objectForKey:errorKey]:@"续期错误，请重试";
}


@end
