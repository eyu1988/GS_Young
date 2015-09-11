//
//  IndexCommonCell.m
//  young
//
//  Created by z Apple on 15/3/19.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "IndexCommonCell.h"
#import "NullHandler.h"
#import "PrimaryTools.h"
#import "CrowdSourcing.h"

@implementation IndexCommonCell
-(void)setCellValueFrom:(NSDictionary*)dic
{
    self.userName.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"nicheng"]];
    self.title.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"xqmc"]];
    self.result.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[NSString stringWithFormat:@"获得%@人投标",[dic objectForKey:@"fws_count"]]];
    
    
    self.time.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"fbsj"]];
    self.budgetLabel.text =[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"sjje"]] ;
    self.stateLabel.text=[CrowdSourcing getRequirementState:dic];

    [PrimaryTools setHeadImage:self.image userNo:[dic objectForKey:@"yh_id"]];
}
@end
