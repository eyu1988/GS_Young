//
//  NumericalValueConverImageCVC.m
//  young
//
//  Created by z Apple on 8/26/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "NumericalValueConverImageCVC.h"
#import "ImageCoverCollectionViewCell.h"
#import "ImageCollectionViewCell.h"
@interface NumericalValueConverImageCVC ()
@property CGFloat cellHeight;
@property CGFloat cellWidth;
@property NSInteger cellNum;
@end

//此类通过字典参数（dictParameter）实现将数字转换成图片显示
//字典中的displayWay为标明了显示方式，目前共分为两种cover和list
//cover:通过两张图片的覆盖效果实现，当前积分或者信誉等级的显示。如:🌕🌕🌗🌑🌑
//list:通过传输图片数组，顺序的显示出图片内容。如:😄😃😀😊☺️
@implementation NumericalValueConverImageCVC

static NSString * reuseIdentifier = @"ImageCoverCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dictParameter = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"star_full.png",@"topImageName"//上层图片
                          ,@"star_none.png",@"bottomImageName"//下层图片
                          ,@"100",@"total"//总值
                          ,@"5",@"current"//当前值
                          ,@"5",@"imageNums"//总图标数
                          ,@"cover",@"displayWay"//显示方式
                          , nil];
    self.dictParameter = [[NSDictionary alloc] initWithObjectsAndKeys:
                @[@"star_full.png",@"star_none.png",@"star_none.png"],@"imageList"//图片数组
                          ,@"list",@"displayWay"//显示方式
                          , nil];
    
    if ([[self.dictParameter objectForKey:@"displayWay"] isEqualToString:@"cover"]) {
        UIImage *topImageName = [UIImage imageNamed:[self.dictParameter objectForKey:@"topImageName"]];
        self.cellHeight = topImageName.size.height;
        self.cellWidth = topImageName.size.width;
        self.cellNum = [[self.dictParameter objectForKey:@"imageNums"] integerValue];
        
    }else if([[self.dictParameter objectForKey:@"displayWay"] isEqualToString:@"list"]){
        NSArray *images =  [self.dictParameter objectForKey:@"imageList"] ;
        if ([images count]>0) {
            
            self.cellNum =[images count];
            UIImage *image = [UIImage imageNamed:images[0]];
            self.cellHeight = image.size.height;
            self.cellWidth = image.size.width;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return self.cellNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   if ([[self.dictParameter objectForKey:@"displayWay"] isEqualToString:@"cover"]) {
       reuseIdentifier = @"ImageCoverCollectionViewCell";
       return [self coverDisplayCollectionView:collectionView cellForItemAtIndexPath:indexPath];
   }else if ([[self.dictParameter objectForKey:@"displayWay"] isEqualToString:@"list"]) {
       reuseIdentifier = @"ImageCollectionViewCell";
       return [self listDisplayCollectionView:collectionView cellForItemAtIndexPath:indexPath];
   }
    return nil;
}


- (UICollectionViewCell *)coverDisplayCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        float total = [[self.dictParameter objectForKey:@"total"] floatValue];
        float current = [[self.dictParameter objectForKey:@"current"] floatValue];
        int imageNums = [[self.dictParameter objectForKey:@"imageNums"] integerValue];
        float unitNums =  total / imageNums ;
        if (((indexPath.row+1) * unitNums) > current
            &&((indexPath.row+1) * unitNums) < (current+unitNums)) {
            float excess =  unitNums - ((indexPath.row+1) * unitNums - current);
            float clipWidth = excess * (self.cellWidth/unitNums);
            UIImage *image = cell.topImageView.image;
            CGImageRef cgimage = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, clipWidth,self.cellHeight));
            cell.topImageView.image = [UIImage imageWithCGImage:cgimage];
        }else if(((indexPath.row+1) * unitNums) > current){
            [cell.topImageView setHidden:YES];
        }
    
    
    return cell;
}

//已列表方式显示
- (UICollectionViewCell *)listDisplayCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *images = [self.dictParameter objectForKey:@"imageList"];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, self.cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSIndexPath *)indexPath
{
    return CGSizeMake(0, 0);
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 100, 100);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0.1f;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0.1f;
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
