//
//  PrimaryTools.h
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrimaryTools : NSObject
+(NSString*)creatStringUseThe:(NSString*)jointSymbol And:(NSString*)splitSymbol  from:(NSDictionary*)dic isNeedTotransCoding: (BOOL)isNeedTotransCoding;
+(NSString*) transCoding:(NSString*) param;
+(NSString*)getIOSDeviceInfo;
+(NSString*)getQchVersion;
+(NSString *)md5HexDigest:(NSString*)input;
+(void)backLayer:(UIViewController*)uvc backNum:(int)num;
+(void)setHeadImage:(id)imageOwner userNo:(NSString*)userNo;
+(void)setHeadImageUseCache:(id)imageOwner userNo:(NSString*)userNo;
+(void)versionUpdateCheck:(UIViewController*)vc;
+(void) alert:(NSString*)msg;
+(UIViewController*)getMessageViewController;
+(UIViewController*)createVcByMainStoryBoardIdentifier:(NSString*)identifier;
+(UIView*)getFristObjectFromNibByNibName:(NSString*)nibName;
+(NSMutableArray *)findAllRangeFrom:(NSString *)originalString bySubString:(NSString*)subString;
+(NSMutableArray *)findAllRangeFrom:(NSString *)originalString bySubString:(NSString*)subString returnContainer:(NSMutableArray*)containerArr beginIndex:(int)beginIndex;
+(NSString *)insureNotNull:(NSString*)string;
+(NSMutableDictionary*)getImageCacheDict;
@end
