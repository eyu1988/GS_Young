//
//  WorkTypeTools.m
//  young
//
//  Created by z Apple on 8/17/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "WorkTypeTools.h"

@implementation WorkTypeTools

+ (NSString*)workTypeImageNamebyworkType:(NSString*)workType
{
    NSString *imageName =@"";
    if ([workType isEqualToString:@"兼职工作"]) {
        imageName = @"worktype_parttime.png";
    }else if ([workType isEqualToString:@"软件开发"]) {
        imageName = @"worktype_soft_develop.png";
    }else if ([workType isEqualToString:@"包装设计"]) {
        imageName = @"worktype_packaging_design.png";
    }else if ([workType isEqualToString:@"推广营销"]) {
        imageName = @"worktype_popularize_marketing.png";
    }else if ([workType isEqualToString:@"图像处理"]) {
        imageName = @"worktype_picture_handle.png";
    }else if ([workType isEqualToString:@"动漫设计"]) {
        imageName = @"worktype_cartoon_design.png";
    }else if ([workType isEqualToString:@"文案策划"]) {
        imageName = @"worktype_document_plan.png";
    }else if ([workType isEqualToString:@"专业翻译"]) {
        imageName = @"worktype_translation.png";
    }else if ([workType isEqualToString:@"视频制作"]) {
        imageName = @"worktype_video_make.png";
    }else if ([workType isEqualToString:@"其他工作"]) {
        imageName = @"worktype_others.png";
    }
    return imageName;
}
@end
