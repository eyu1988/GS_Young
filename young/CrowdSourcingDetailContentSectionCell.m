//
//  CrowdSourcingDetailContentSectionCell.m
//  young
//
//  Created by z Apple on 8/23/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "CrowdSourcingDetailContentSectionCell.h"
#import "NullHandler.h"
#import "ZPickView.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"

@interface CrowdSourcingDetailContentSectionCell ()
@property (weak,nonatomic)NSDictionary* csDict;
@end

@implementation CrowdSourcingDetailContentSectionCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)postpone:(id)sender {
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    ZPickView *pickview=[[ZPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    pickview.delegate=self;
    [pickview show];
}


#pragma mark ZpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZPickView *)pickView resultString:(NSString *)resultString{
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *date = [NSDate date];
//    NSDate *date2 = [NSDate dateWithTimeInterval:5*60*60+75 sinceDate:date];
//    NSDateComponents *compt = [calendar components:(NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:date toDate:date2 options:0];
//    
//    NSLog(@"%d",[compt minute]);
//    NSLog(@"%d",[compt second]);
    NSLog(@"已经选择了最新的延期日期:%@",[resultString componentsSeparatedByString:@" "][0]);
    NSDate *date = [CrowdSourcingDetailContentSectionCell convertDateFromString:resultString];
    NSLog(@"date:%@",date);
    NSString *newDate =[resultString componentsSeparatedByString:@" "][0];
//    NSDictionary *formParameter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id" , nil];
//    
//    [ZSyncURLConnection request:[UrlFactory createUnreadMessageCountUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"result:%@",result);
//            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
//                NSDictionary *dateDict =[result objectForKey:@"data"];
//                
//            }else{
//                
//            }
//        });
//    } errorBlock:^(NSError *error) {
//        //        NSLog(@"error %@",error);
//    }];

}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
- (void)initData:(NSDictionary*) dict
{
    
    self.csDict = dict;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元",[dict objectForKey:@"sjje"]];
    self.employerLabel.text = [NullHandler connectNotNullString:@"",[dict objectForKey:@"nick_name"],nil];
    self.telephoneLabel.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"lxfs"],nil];
    
    self.peopleNumLimit.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"zbrssx"],nil];
    self.unitPriceLabel.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"gzldw_je"],nil];
    self.workTotalLabel.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"gzl_zs"],nil];
    self.closeDateLabel.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"zbjzrq"],nil];
    self.doneDateLabel.text =[NullHandler connectNotNullString:@"",[dict objectForKey:@"jhwcrq"],nil];
    self.detailContantLabel.text= [dict objectForKey:@"xqnr"];
    if ([[dict objectForKey:@"is_overdue"] integerValue]==1) {
        [self overDue];
    }
}

- (void)overDue
{
    self.closeDateLabel.textColor = [UIColor redColor];
    self.doneDateLabel.textColor = [UIColor redColor];
    [self.applyForPostpone setHidden:NO];
}

@end
