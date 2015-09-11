//
//  UrlFactory.h
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlFactory : NSObject

+(NSMutableString*)createSendCheckCode;

+(NSMutableString*)createRegisterUrl;

+(NSMutableString*)createCrowdSourcingListUrl;

+(NSMutableString*)createCrowdSourcingDetailUrl;

+(NSMutableString*)createLoginUrl;

+(NSMutableString*)createUpdateUserInfoUrl;

+(NSMutableString*)createBidUrl;

+(NSMutableString*)createUpdatePassWordUrl;

+(NSMutableString*)createGetUserInfoUrl;

+(NSMutableString*)createHeadImageUrl:(NSString*)userId;

+(NSMutableString*)createHeadImageHDUrl:(NSString*)userId;

+(NSMutableString*)createUploadHeadImageUrl;

+(NSMutableString*)createRequirementTypeTreeUrl;

+(NSMutableString*)createMessageListUrl;

+(NSMutableString*)createAddSuggestionUrl;

+(NSMutableString*)createMessageDetailUrl;

+(NSMutableString*)createSendBindPhoneCheckCode;

+(NSMutableString*)createBindPhoneUrl;

+(NSString*)createTermsOfServiceUrl;

+(NSMutableString*)createValidateLoginNameUrl;

+(NSMutableString*)createHelpUrl;

+(NSMutableString*)createVersionUpdateCheckUrl;

+(NSMutableString*)createRequirementAddUrl;

+(NSMutableString*)createUnreadMessageCountUrl;

+(NSMutableString*)createVerifyUploadFileUrl;

+(NSMutableString*)createAutonymVerifyUrl;

+(NSMutableString*)createStudentStatusVerifyUrl;

+(NSMutableString*)createGraduateStatusVerifyUrl;

+(NSMutableString*)createEnterpriseStatusVerifyUrl;

+(NSMutableString*)createReSetPasswordSms;

+(NSMutableString*)createReSetMyPwd;

+(NSMutableString*)createInitWithdrawCashUrl;

+(NSMutableString*)createWithdrawCashUrl;

+(NSMutableString*)createMyWalletInitInfoUrl;

+(NSMutableString*)createMyBindZfbAndCardIndexUrl;

+(NSMutableString*)createMyBindZfbAndCardMessage;

+(NSMutableString*)createBindZfbUrl;

+(NSMutableString*)createBindZfbAndCardVerifyUrl;

+(NSMutableString*)createDeleteZfbBindAccountUrl;

+(NSMutableString*)createAddCardUrl;

+(NSMutableString*)createCardCodeVerifyUrl;

+(NSMutableString*)createDeleteBindCardUrl;

+(NSMutableString*)createSendZfmmCheckCodeUrl;

+(NSMutableString*)createUpdateZfmmUrl;

+(NSMutableString*)createWithdrawCashListUrl;

+(NSMutableString*)createDealLogListUrl;

+(NSMutableString*)createAdPicLoadUrl;

+(NSMutableString*)createShareRegisterUrl;

+(NSMutableString*)createWithdrawCashSendMessageCodeUrl;

+(NSMutableString*)createCrowdSourcingBiderListUrl;

+(NSMutableString*)createCrowdSourcingBiderInfoUrl;

+(NSMutableString*)createChatListUrl;

+(NSMutableString*)createMegListUrl;

+(NSMutableString*)createSendMegUrl;

+(NSMutableString*)createHasReadUrl;

+(NSMutableString*)createUserListUrl;

+(NSMutableString*)createComplaintListUrl;

+(NSMutableString*)createComplaintInfoUrl;

+(NSMutableString*)createAddComplaintUrl;

+(NSMutableString*)createComplaintFujianUrl;

+(NSMutableString*)createJuzhengUrl;

+(NSMutableString*)createAddAttentUrl;

+(NSMutableString*)createCancelAttentUrl;

+(NSMutableString*)createListAttentUrl;

@end
