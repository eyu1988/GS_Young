//
//  ChooserTVC.h
//  young
//
//  Created by z Apple on 8/12/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InitDataArrayBlack_b)();
typedef void(^SubmitBlack_b)();
@interface ChooserTVC : UITableViewController
{
     InitDataArrayBlack_b initDataArray_ ;
     SubmitBlack_b submitBlack_ ;
}

-(void)initBlack:(InitDataArrayBlack_b) initDataArrayB submitBlack:(SubmitBlack_b) submitB;

@property (copy,nonatomic)NSArray *dataArray;
@property (copy,nonatomic)NSMutableArray *selectedArray;
@property (weak,nonatomic)NSString *selectedTitle;

@end
