//
//  PrimaryTools.m
//  young
//
//  Created by z Apple on 15/3/30.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "PrimaryTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSUserDefaultsHandle.h"
#import <UIKit/UIKit.h>
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "AppDelegate.h"
#import "NullHandler.h"

@implementation PrimaryTools

#pragma mark -NSStringHandled
static NSMutableDictionary *imageCacheDict;

+(void)versionUpdateCheck:(UIViewController*)vc
{
    
    [ZSyncURLConnection request:[UrlFactory createVersionUpdateCheckUrl]  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                //              {"result":"success","data":{"force_update":0,"headversion":1.0,"note":"请更新最新版本！"}}
                NSDictionary *dataDict = [dict objectForKey:@"data"];
                 if(![[dataDict objectForKey:@"headversion"] isEqualToString:[PrimaryTools getQchVersion]]){
                     
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"更新提示"
                                                                                   message:[dataDict objectForKey:@"note"]
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction* go = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/qing-chun-hao/id989128443?l=zh&ls=1&mt=8"]];
                                                               }];
                    [alert addAction:go];
                     
                    if([[dataDict objectForKey:@"force_update"] intValue]==0){
                        UIAlertAction* no = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                    }];
                        [alert addAction:no];
                     }
                    [vc presentViewController:alert animated:YES completion:nil];
                     
                }
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];
    
}

+(void) alert:(NSString*)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

+(void)backLayer:(UIViewController*)uvc backNum:(int)num
{
    NSInteger index=[[uvc.navigationController viewControllers]indexOfObject:uvc];
    [uvc.navigationController popToViewController:
    [uvc.navigationController.viewControllers objectAtIndex:index-num]animated:YES];
}

+(NSString*)creatStringUseThe:(NSString*)jointSymbol And:(NSString*)splitSymbol  from:(NSDictionary*)dic isNeedTotransCoding: (BOOL)isNeedTotransCoding
{
    NSMutableString *str = [[NSMutableString alloc] init];
   
    for (NSString *key in dic){
       if(isNeedTotransCoding)
           [str appendString:  [NSString stringWithFormat:@"%@%@%@%@",key,jointSymbol
                                ,[self transCoding:dic[key]],splitSymbol] ];
       else
           [str appendString:  [NSString stringWithFormat:@"%@%@%@%@",key,jointSymbol,dic[key],splitSymbol] ];
    }
    return str;
}

+(NSString*) transCoding:(id) param
{
  NSString *temp =[[NSString alloc] init];
    if([param isKindOfClass:[NSDictionary class]]||[param isKindOfClass:[NSMutableDictionary class]]
       ){
        temp = [param description];
    }else if([param isKindOfClass:[NSString class]]||[param isKindOfClass:[NSMutableString class]]
             ){
        temp = param;
    }else return param;
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)temp, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
}

+ (NSString*)getIOSDeviceInfo
{
    UIDevice *device=[UIDevice currentDevice];
//    device
    NSString *deviceInfo = [NSString stringWithFormat:@"设备:%@ 设备名称:%@ 系统名称:%@ 系统版本号:%@",device.model,[device name],[device systemName],[device systemVersion]];
    return deviceInfo;
}

+(NSString*)getQchVersion
{
    return @"1.1";
}

//CC_SHA256_DIGEST_LENGTH:32
//CC_MD5_DIGEST_LENGTH:16
+ (NSString *)md5HexDigest:(NSString*)str
{
    const char *cStr = [str UTF8String];
   unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                           result[0], result[1], result[2], result[3],
                                           result[4], result[5], result[6], result[7],
                                            result[8], result[9], result[10], result[11],
                                             result[12], result[13], result[14], result[15]
                  ];
}

//设置头像
+ (void)setHeadImage:(id)imageOwner userNo:(NSString*)userNo
{
    NSString *strUrl = [UrlFactory createHeadImageUrl:userNo];
    [ZSyncURLConnection request:strUrl  completeBlock:^(NSData *data) {
      
        if ([data.description isEqualToString:@"<6e756c6c>"]) {
            return;//如果接口返回null则直接使用默认头像
        }
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self imageOwner:imageOwner image:image];
        });
    }
                     errorBlock:^(NSError *error) {
//                         NSLog(@"error %@",error);
                     }];
}

//利用缓存机制加载图片
#warning This method maybe is not the best what is cache way.Need to improve.
+ (void)setHeadImageUseCache:(id)imageOwner userNo:(NSString*)userNo
{
    NSString *strUrl = [UrlFactory createHeadImageUrl:userNo];
    NSMutableDictionary *imageCacheDict =[PrimaryTools getImageCacheDict];
    if ([imageCacheDict objectForKey:strUrl]) {
        UIImage *image = [imageCacheDict objectForKey:strUrl];
        [self imageOwner:imageOwner image:image];
        return;
    }
    [ZSyncURLConnection request:strUrl  completeBlock:^(NSData *data) {
        
        if ([data.description isEqualToString:@"<6e756c6c>"]) {
            return;//如果接口返回null则直接使用默认头像
        }
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [[UIImage alloc] initWithData:data];
            [imageCacheDict setObject:image forKey:strUrl];
            [self imageOwner:imageOwner image:image];
        });
    }
                     errorBlock:^(NSError *error) {
                         //                         NSLog(@"error %@",error);
    }];
}

+ (void)imageOwner:(UIView*)imageOwner image:(UIImage*)image
{
    if ([imageOwner isKindOfClass:[UIImageView class]]) {
        ((UIImageView*)imageOwner).image=image;
    }else if([imageOwner isKindOfClass:[UIButton class]]) {
        [((UIButton*)imageOwner) setImage:image forState:UIControlStateNormal];
    }
}

+(UIViewController*)getMessageViewController
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return delegate.viewControllers[3];
}

+(UIViewController*)createVcByMainStoryBoardIdentifier:(NSString*)identifier
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* viewController = [mainStoryboard   instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}
+(UIView*)getFristObjectFromNibByNibName:(NSString*)nibName
{
//    NSLog(@"nibName:%@",nibName);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [views firstObject];
}

+(NSMutableArray *)findAllRangeFrom:(NSString *)originalString bySubString:(NSString*)subString
{
    return [self findAllRangeFrom:originalString bySubString:subString returnContainer:[[NSMutableArray alloc] init] beginIndex:0];

}

+(NSMutableArray *)findAllRangeFrom:(NSString *)originalString bySubString:(NSString*)subString returnContainer:(NSMutableArray*)containerArr beginIndex:(int)beginIndex
{
    NSRange range =  [ [originalString substringFromIndex:beginIndex] rangeOfString:subString];
    if (range.location==NSNotFound) {
        return containerArr;
    }else{
        range.location +=beginIndex;
        beginIndex =[[NSString stringWithFormat:@"%lu",(range.location + range.length)] intValue];
        [containerArr addObject:NSStringFromRange(range)];
        return [self findAllRangeFrom:originalString bySubString:subString returnContainer:containerArr beginIndex:beginIndex];
    }
}
+(NSString *)insureNotNull:(NSString*)string
{
    return [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:string];
}

+(NSMutableDictionary*)getImageCacheDict
{
    if (!imageCacheDict) {
        imageCacheDict  = [[NSMutableDictionary alloc] init];
    }
    return imageCacheDict;
}

@end
