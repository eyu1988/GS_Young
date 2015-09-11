//
//  AutoLayoutByScale.h
//  TT
//
//  Created by z Apple on 15/7/6.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoLayoutByScale : NSObject

-(UIView*)autoUpdateLayout:(UIView*)view;
-(UIView*)autoUpdateLayout:(UIView*)view currentWidth:(CGFloat)currentWidth currentHeight:(CGFloat)currentHeight;
-(UIView*)autoUpdateLayoutWithNibName:(NSString*)nibName;
-(UIView*)autoUpdateLayoutWithNibName:(NSString*)nibName currentWidth:(CGFloat)currentWidth currentHeight:(CGFloat)currentHeight;
@end
