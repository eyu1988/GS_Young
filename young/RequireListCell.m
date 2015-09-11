//
//  RequireListCell.m
//  young
//
//  Created by z Apple on 8/15/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "RequireListCell.h"
#import "NullHandler.h"
#import "CrowdSourcing.h"
#import "WorkTypeTools.h"

@implementation RequireListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellValueFrom:(NSDictionary*)dic
{
  
    self.requireTitleLabel.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[dic objectForKey:@"xqmc"]];
    self.peopleNumLabel.text = [NullHandler ifEqualNilReturnNullStringElseReturnOriginalString:[NSString stringWithFormat:@"%@人参与",[dic objectForKey:@"fws_count"]]];
    self.residueDaysLabel.text = [dic objectForKey:@"zbjzrq_shengyu_format"];
    self.costLabel.text =[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"sjje"]] ;
    self.stateLabel.text=[CrowdSourcing getRequirementState:dic];
    [self workTypeImageView:[dic objectForKey:@"top_xqlb"]];
}

- (void)workTypeImageView:(NSString*)topWorkType
{
    topWorkType = [topWorkType componentsSeparatedByString:@"#"][1];
    NSString* imageName = [WorkTypeTools workTypeImageNamebyworkType:topWorkType];
    _workTypeImageView.image = [UIImage imageNamed:imageName];
}

@end
