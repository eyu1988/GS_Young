//
//  CrowdSourcing.m
//  young
//
//  Created by z Apple on 15/4/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "CrowdSourcing.h"

@implementation CrowdSourcing


+(NSString*)getRequirementState:(NSDictionary*)dic
{
    if([[dic objectForKey:@"xqzt_keyiqiang"] intValue]==1){
        return @"等你抢";
    }else if([[dic objectForKey:@"xqzt_zhongbiao"] intValue]==1){
        return @"已中标";
    }else if([[dic objectForKey:@"xqzt_fukuan"] intValue]==1){
        return @"已托管";
    }else if([[dic objectForKey:@"xqzt_weifabu"] intValue]==1){
        return @"未发布";
    }else if([[dic objectForKey:@"xqzt_jinxingzhong"] intValue]==1){
        return @"进行中";
    }
    return @"doing";
}

+(NSString*)getRequirementBidState:(NSDictionary*)dic
{
    if([[dic objectForKey:@"zb_zt"] intValue ]==0){
        return @"未处理";
    }else if([[dic objectForKey:@"zb_zt"] intValue ]==2){
        return @"淘汰";
    }else if([[dic objectForKey:@"zb_zt"] intValue ]==4){
        return @"选用";
    }else if([[dic objectForKey:@"zb_zt"] intValue ]==5){
        return @"已提交结果";
    }else if([[dic objectForKey:@"zb_zt"] intValue ]==6){
        return @"已支付";
    }
    return @"unknow";
}

+(NSMutableDictionary*)createNetRequirementParamter
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"xqzt_weifabu"
            ,@"1",@"lie_zbjzrq_shengyu"
            ,@"1",@"lie_top_xqlb"
            ,nil];
}

@end
