//
//  UrlFactory.m
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "UrlFactory.h"
#import "PrimaryTools.h"

@implementation UrlFactory
static NSString *QINGCHUNHAO_WEBSITE = @"http://www.qingchunhao.com:9100/";

static NSString *TEST_QINGCHUNHAO_WEBSITE = @"https://www.qingchunhao.com/ios/test_qchmobile/";//Test

//static NSString *TEST_QINGCHUNHAO_WEBSITE = @"https://www.qingchunhao.com/ios/qchmobile/";

+(NSMutableString*)createLoginUrl
{
    return [NSMutableString stringWithFormat:@"%@m/auth/login.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createSendCheckCode
{
    return [NSMutableString stringWithFormat:@"%@m/auth/sms_regist/sendsms.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createRegisterUrl
{
    return [NSMutableString stringWithFormat:@"%@m/auth/sms_regist.do?",TEST_QINGCHUNHAO_WEBSITE];
    
}

+(NSMutableString*)createCrowdSourcingListUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/xuqiu/search/list.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;

}

//+(NSMutableString*)createCrowdSourcingListUrl
//{
//    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@zhongbao/mobilexuqiu/xuqiuList.do?",QINGCHUNHAO_WEBSITE];
//    return urlStr;
//
//}
+(NSMutableString*)createCrowdSourcingDetailUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/xuqiu/info.do?",TEST_QINGCHUNHAO_WEBSITE];
     return urlStr;
}

+(NSMutableString*)createBidUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/xuqiu/qiang.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;

}

+(NSMutableString*)createUpdatePassWordUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/auth/password.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}

+(NSMutableString*)createUpdateUserInfoUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/auth/info/upd.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}
//https://www.qingchunhao.com/ios/test_qchmobile/m/auth/info/get.do?p=%7B%22login_id%22%20:%20%229125dd99-0e47-43d9-afd8-c440a1991603%22%7D
+(NSMutableString*)createGetUserInfoUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/auth/info/get.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}
//https://www.qingchunhao.com/test_qchmobile/m/file/headphoto/3_compress.do
+(NSMutableString*)createHeadImageUrl:(NSString*)userId
{
 
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/file/headphoto/%@_compress.do?",TEST_QINGCHUNHAO_WEBSITE,userId];
//    NSLog(@"urlStr:%@",urlStr);
    return urlStr;
    
}


//https://www.qingchunhao.com/test_qchmobile/m/file/headphoto/3.do
+(NSMutableString*)createHeadImageHDUrl:(NSString*)userId
{

    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/file/headphoto/%@.do?",TEST_QINGCHUNHAO_WEBSITE,userId];
//    NSLog(@"urlStr:%@",urlStr);
    return urlStr;
    
}

//https://www.qingchunhao.com/test_qchmobile/m/file/headphoto/upload.do
+(NSMutableString*)createUploadHeadImageUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/file/headphoto/upload.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
}

//https://www.qingchunhao.com/test_qchmobile/m/fenlei/tree.do
+(NSMutableString*)createRequirementTypeTreeUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/fenlei/tree.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}

//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/read.do
+(NSMutableString*)createMessageDetailUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/xiaoxi/read.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}
//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/list.do
+(NSMutableString*)createMessageListUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/xiaoxi/list.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
    
}

//https://www.qingchunhao.com/test_qchmobile/m/feedback/add.do
+(NSMutableString*)createAddSuggestionUrl
{
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@m/feedback/add.do?",TEST_QINGCHUNHAO_WEBSITE];
    return urlStr;
}


//https://www.qingchunhao.com/test_qchmobile/m/auth/ bindphone/sms.do

+(NSMutableString*)createSendBindPhoneCheckCode
{
    return [NSMutableString stringWithFormat:@"%@m/auth/bindphone/sms.do?",
            TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/m/auth/bindphone.do

+(NSMutableString*)createBindPhoneUrl
{
    return [NSMutableString stringWithFormat:@"%@m/auth/bindphone.do?",TEST_QINGCHUNHAO_WEBSITE];
}


//http://www.qingchunhao.com:9100/qch/help-term.jsp
+(NSString*)createTermsOfServiceUrl
{
    return @"http://www.qingchunhao.com:9100/qch/help-term.jsp";
}

//https://www.qingchunhao.com/test_qchmobile/m/auth/validate_loginname.do
+(NSMutableString*)createValidateLoginNameUrl
{
    return [NSMutableString stringWithFormat:@"%@m/auth/validate_loginname.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/qchmobile/help/ios/1.1/html/help.html
+(NSMutableString*)createHelpUrl
{
    return [[NSMutableString alloc] initWithFormat:@"http://www.qingchunhao.com:9100/qchmobile/help/ios/1.1/html/help.html" ];
}


//https://www.qingchunhao.com/test_qchmobile/qchmobile/app/headversion.do

//https://www.qingchunhao.com/test_qchmobile/qchmobile/app/headversion.do
+(NSMutableString*)createVersionUpdateCheckUrl
{
    return [[NSMutableString alloc] initWithFormat:@"https://www.qingchunhao.com/ios/qchmobile/m/app/headversion.do"];
}

//https://www.qingchunhao.com/test_qchmobile/m/xuqiu/add.do
+(NSMutableString*)createRequirementAddUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xuqiu/add.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createUnreadMessageCountUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/xiaoxitongji.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createVerifyUploadFileUrl
{
    return [NSMutableString stringWithFormat:@"%@m/authidentify/renzheng_tupian_shangchuan.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createAutonymVerifyUrl
{
    return [NSMutableString stringWithFormat:@"%@m/authidentify/shenfenrenzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}
+(NSMutableString*)createStudentStatusVerifyUrl
{
     return [NSMutableString stringWithFormat:@"%@m/authidentify/xueshengrenzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createGraduateStatusVerifyUrl
{
    return [NSMutableString stringWithFormat:@"%@m/authidentify/biyeshengrenzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createEnterpriseStatusVerifyUrl
{
    return [NSMutableString stringWithFormat:@"%@m/authidentify/gongsirenzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}


+(NSMutableString*)createReSetPasswordSms
{
    return [NSMutableString stringWithFormat:@"%@m/sms/resetpwdsms.do?",TEST_QINGCHUNHAO_WEBSITE];
}

+(NSMutableString*)createReSetMyPwd
{
    return [NSMutableString stringWithFormat:@"%@m/auth/resetmypwd.do?",TEST_QINGCHUNHAO_WEBSITE];
}


//https://www.qingchunhao.com/test_qchmobile/m/qianbao/tixian/init.do
+(NSMutableString*)createInitWithdrawCashUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/tixian/init.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/tixian/tixian.do?
+(NSMutableString*)createWithdrawCashUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/tixian/tixian.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/account/index.do? 
+(NSMutableString*)createMyWalletInitInfoUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/account/index.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/account/myaccount.do?
+(NSMutableString*)createMyBindZfbAndCardIndexUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/account/myaccount.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/yinhang/bdyzm.do?
+(NSMutableString*)createMyBindZfbAndCardMessage
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/yinhang/bdyzm.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/zfb/setzfb.do?
+(NSMutableString*)createBindZfbUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/zfb/setzfb.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/zfb/bdyanzheng.do
+(NSMutableString*)createBindZfbAndCardVerifyUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/zfb/bdyanzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/zfb/delzfb.do
+(NSMutableString*)createDeleteZfbBindAccountUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/zfb/delzfb.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/yinhang/addka.do? 
+(NSMutableString*)createAddCardUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/yinhang/addka.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/yinhang/yanzheng_yinhang.do?
+(NSMutableString*)createCardCodeVerifyUrl
{
    NSLog(@"url:%@",[NSMutableString stringWithFormat:@"%@m/qianbao/yinhang/yanzheng_yinhang.do?",TEST_QINGCHUNHAO_WEBSITE]);
    return [NSMutableString stringWithFormat:@"%@m/qianbao/yinhang/yanzheng_yinhang.do?",TEST_QINGCHUNHAO_WEBSITE];

}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/yinhang/delka.do?
+(NSMutableString*)createDeleteBindCardUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/yinhang/delka.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/account/setzfmm_sms.do
+(NSMutableString*)createSendZfmmCheckCodeUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/account/setzfmm_sms.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//http://www.qingchunhao.com:9100/test_qchmobile/m/qianbao/account/setzfmm.do
+(NSMutableString*)createUpdateZfmmUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/account/setzfmm.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/m/qianbao/tixian/list.do
+(NSMutableString*)createWithdrawCashListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/tixian/list.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/m/qianbao/account/jymxlist.do
+(NSMutableString*)createDealLogListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/account/jymxlist.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/guanggao/imgs.do
+(NSMutableString*)createAdPicLoadUrl
{
    return [NSMutableString stringWithFormat:@"%@m/guanggao/imgs.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/shehuihua/zhuce_fenxiang.do
+(NSMutableString*)createShareRegisterUrl
{
    return [NSMutableString stringWithFormat:@"%@m/shehuihua/zhuce_fenxiang.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/m/qianbao/tixian/tixiansms.do?
+(NSMutableString*)createWithdrawCashSendMessageCodeUrl
{
    return [NSMutableString stringWithFormat:@"%@m/qianbao/tixian/tixiansms.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/xuqiu/xqfwslist.do
+(NSMutableString*)createCrowdSourcingBiderListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xuqiu/xqfwslist.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/userList.do
+(NSMutableString*)createChatListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/userList.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/list.do
+(NSMutableString*)createMegListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/list.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/send.do
+(NSMutableString*)createSendMegUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/send.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/read.do
+(NSMutableString*)createHasReadUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/read.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/ m/xuqiu/xqfwsInfo.do
+(NSMutableString*)createCrowdSourcingBiderInfoUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xuqiu/xqfwsInfo.do?",TEST_QINGCHUNHAO_WEBSITE];
}
//https://www.qingchunhao.com/test_qchmobile/m/xiaoxi/userList.do
+(NSMutableString*)createUserListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/xiaoxi/userList.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/tousu/tousuList.do
+(NSMutableString*)createComplaintListUrl
{
    return [NSMutableString stringWithFormat:@"%@m/tousu/tousuList.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/tousu/getTousuInfo.do
+(NSMutableString*)createComplaintInfoUrl
{
    return [NSMutableString stringWithFormat:@"%@m/tousu/getTousuInfo.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/tousu/addTousu.do
+(NSMutableString*)createAddComplaintUrl
{
    return [NSMutableString stringWithFormat:@"%@m/tousu/addTousu.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/tousu/tousu_fujian_shangchuan.do
+(NSMutableString*)createComplaintFujianUrl
{
    return [NSMutableString stringWithFormat:@"%@m/tousu/tousu_fujian_shangchuan.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/tousu/addJuzheng.do
+(NSMutableString*)createJuzhengUrl
{
    return [NSMutableString stringWithFormat:@"%@m/tousu/addJuzheng.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/attent/addAttent.do
//login_id, buserNo
+(NSMutableString*)createAddAttentUrl
{
    return [NSMutableString stringWithFormat:@"%@m/attent/addAttent.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/attent/cancelAttent.do
//login_id, buserNo
+(NSMutableString*)createCancelAttentUrl
{
    return [NSMutableString stringWithFormat:@"%@m/attent/cancelAttent.do?",TEST_QINGCHUNHAO_WEBSITE];
}

//https://www.qingchunhao.com/test_qchmobile/m/attent/listAttent.do
//login_id, pageNumber, pageSize
+(NSMutableString*)createListAttentUrl
{
    return [NSMutableString stringWithFormat:@"%@m/attent/listAttent.do?",TEST_QINGCHUNHAO_WEBSITE];
}

@end
