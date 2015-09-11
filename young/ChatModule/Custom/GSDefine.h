//
//  GSDefine.h
//  ChatDemo
//
//  Created by Lucas on 15/7/31.
//  Copyright (c) 2015年 gesoft. All rights reserved.
//

#ifndef ChatDemo_GSDefine_h
#define ChatDemo_GSDefine_h


#endif

#define THEMECOLOR [UIColor colorWithRed:0.30f green:0.64f blue:0.24f alpha:1.00f]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define GetState(X) {[@[@"", @"举证协商阶段", @"判定阶段", @"公示结果"] objectAtIndex:X]}

/** Add By Xianyu
 * 1: 修改默认的NSLog打印格式
 * 0: 去掉NSLog打印
 **/
#if 1
#define NSLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]UTF8String]);

#else
#define NSLog(FORMAT, ...) nil
#endif