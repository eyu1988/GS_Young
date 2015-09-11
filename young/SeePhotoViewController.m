//
//  SeePhotoViewController.m
//  young
//
//  Created by z Apple on 15/4/4.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "SeePhotoViewController.h"




@interface SeePhotoViewController()<UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView* imageView;
@end

@implementation SeePhotoViewController


-(UIScrollView*)scrollView
{
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 5.0;
    _scrollView.delegate = self;
    _scrollView.contentSize=self.image.size;
    return _scrollView;
}
-(UIImageView*)imageView
{
    if(!_imageView)
        _imageView = [[UIImageView alloc] init];
    return _imageView;
}

-(UIImage*)image
{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView addSubview:self.imageView];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
