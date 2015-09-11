//
//  ColorfulRectAndUILabelTableHeader.m
//  young
//
//  Created by z Apple on 7/10/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "ColorfulRectAndUILabelTableHeader.h"

@implementation ColorfulRectAndUILabelTableHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setRetract:(CGFloat) retractFloat{
    
    for (UIView *view in [self subviews]) {
        CGRect rect =  view.frame;
        rect.origin.x += retractFloat;
        view.frame = rect;
    }

}
@end
