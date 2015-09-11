//
//  AutoLayoutByScale.m
//  TT
//
//  Created by z Apple on 15/7/6.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "AutoLayoutByScale.h"


@implementation AutoLayoutByScale

-(UIView*)autoUpdateLayout:(UIView*)view
{
    return [self autoUpdateLayout:view currentWidth:[UIScreen mainScreen].bounds.size.width
             currentHeight:view.frame.size.height / view.frame.size.width *[UIScreen mainScreen].bounds.size.width];
}

-(UIView*)autoUpdateLayoutWithNibName:(NSString*)nibName
{
    return [self autoUpdateLayout:[self createUIViewWithNibName:nibName]];
}

-(UIView*)autoUpdateLayoutWithNibName:(NSString*)nibName currentWidth:(CGFloat)currentWidth currentHeight:(CGFloat)currentHeight
{
    return [self autoUpdateLayout:[self createUIViewWithNibName:nibName] currentWidth:currentWidth currentHeight:currentHeight];
}

-(UIView*)autoUpdateLayout:(UIView*)view currentWidth:(CGFloat)currentWidth currentHeight:(CGFloat)currentHeight
{
    for (UIView *viewTemp in [view subviews]){
        [self autoUpdateLayoutWithOriginalWidth:view.frame.size.width
                                 originalHeight:view.frame.size.height
                                   currentWidth:currentWidth
                                  currentHeight:currentHeight view:viewTemp];
    }
    return view;
}

-(void)autoUpdateLayoutWithOriginalWidth:(CGFloat)originalWidth originalHeight :(CGFloat)originalHeight currentWidth:(CGFloat)currentWidth currentHeight:(CGFloat)currentHeight view:(UIView*)view
{
    CGRect frame = view.frame;
    frame.origin.x =    (frame.origin.x/originalWidth) * currentWidth;
    frame.origin.y =    (frame.origin.y/originalHeight) * currentHeight;
    frame.size.width =  (frame.size.width/originalWidth) * currentWidth;
    frame.size.height = (frame.size.height/originalHeight) * currentHeight;
    [view setFrame:frame];
}

-(UIView*)createUIViewWithNibName:(NSString*)nibName
{
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    return [apparray firstObject];
}
@end
