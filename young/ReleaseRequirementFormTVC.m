//
//  ReleaseRequirementFormTVC.m
//  young
//
//  Created by z Apple on 15/5/5.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ReleaseRequirementFormTVC.h"
#import "ZPickView.h"
#import "NullHandler.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "NSUserDefaultsHandle.h"
#import "PrimaryTools.h"
#import "DataFormatVerify.h"
#import "GlobleLocalSession.h"

@interface ReleaseRequirementFormTVC ()<UITextViewDelegate>
    @property(nonatomic,strong)UIView *uiReceiver;
    @property(nonatomic,copy)NSMutableArray *dealModelArray;
    @property(nonatomic,copy)NSMutableDictionary *dealModelDict;
    @property(nonatomic)NSArray *dealModelList;
@end

@implementation ReleaseRequirementFormTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
     self.detail.delegate = self;
    [self initData];
}

- (void)initData
{
    self.dealModelList = @[@"招标",@"计件",@"比稿"];
    NSArray *array = [self.dealMode componentsSeparatedByString:@","];
    _dealModelArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.dealModelArray addObject:self.dealModelList[[array[idx] integerValue]]];
    }];
    
    if([array count]==1){
        [self.dealModel setTitle:self.dealModelList[[array[0] integerValue]] forState:UIControlStateNormal];
        self.dealMode = [NSString stringWithFormat:@"%@",array[0]];
        NSLog(@"self.dealMode:%@",self.dealMode);
    }
    
}

- (IBAction)chooseDate:(UIButton *)sender {
  [self.view endEditing:YES];
    self.uiReceiver = sender;
    [self.pickview remove];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    self.pickview=[[ZPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    self.pickview.delegate=self;
    
    [self.pickview show];
}

#pragma mark ZpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZPickView *)pickView resultString:(NSString *)resultString{
    
    if (self.uiReceiver==self.overDate || self.uiReceiver == self.stopDate) {
        resultString = [resultString componentsSeparatedByString:@" " ][0];
    }
    if (self.uiReceiver == self.dealModel) {
        [self.dealModelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isEqualToString:resultString]){
                self.dealMode = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
            }
        }];
        [self.tableView reloadData];
        
    }
    [NullHandler NotNil:resultString AssignToUiReceiver:self.uiReceiver];
}

- (IBAction)chooseCountUnit:(UIButton *)sender {
    [self.view endEditing:YES];
    self.uiReceiver = sender;
    NSArray *array=@[@"月",@"周",@"天",@"小时",@"件"];
    _pickview=[[ZPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    self.pickview.delegate=self;
    
    [self.pickview show];
}
- (IBAction)chooseRewardDistribute:(UIButton *)sender {
    [self.view endEditing:YES];
    
    self.uiReceiver = sender;
    NSArray *array=@[@"只选一人中标",@"选多人中标"];
    _pickview=[[ZPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    self.pickview.delegate=self;
    [self.pickview show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if ([self isNeedToHidden:cell]){
       return 0;
    }
    if(cell == self.detailCell)
        return self.detail.frame.size.height + 16 ;
   
    return 45;
}

-(BOOL)isNeedToHidden:(UITableViewCell*)cell
{

    if(![self.dealMode isEqualToString:@"1"]){
        for (UITableViewCell  *oneCell in self.optionalTableCells) {
            if (cell ==oneCell) {
                return YES;
            }
        }
    }else{
        if (cell==self.rewardTableCell){
            return YES;
        }

    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (self.detail.text.length == 0) {
        
        self.detailPlaceHolder.text=@"详细要求说明";
    }else{
        self.detailPlaceHolder.text=@"";
    }
    
}

- (IBAction)chooseDealModel:(id)sender {
    [self.view endEditing:YES];
    
    self.uiReceiver = sender;
      _pickview=[[ZPickView alloc] initPickviewWithArray:self.dealModelArray isHaveNavControler:NO];
    self.pickview.delegate=self;
    [self.pickview show];

}

- (IBAction)submitForm:(id)sender {
    
    if([self.dealModel.titleLabel.text isEqualToString:@"点击选择交易模式"]){
        [PrimaryTools alert:@"请选择交易模式"];
        return;
    }
    if ([NullHandler ifLengthEqualZeroThenAlert:self.titleLable alertMsg:@"请填写需求标题"]) {
        return;
    }
    if([self.overDate.titleLabel.text isEqualToString:@"需求计划完成日期"]){
        [PrimaryTools alert:@"请选择计划完成日期"];
        return;
    }
    if (self.peopleNum.text.length!=0) {
        if (![DataFormatVerify isNumberString:self.peopleNum.text]) {
            [PrimaryTools alert:@"人数上线必须为数字"];
            return;
        }
    }
    if (![self.dealMode isEqualToString:@"1"]) {
        if([NullHandler ifLengthEqualZeroThenAlert:self.cost alertMsg:@"请填写悬赏金额"])
            return;
        if (![DataFormatVerify isNumberString:self.cost.text]) {
            [PrimaryTools alert:@"悬赏金额必须为数字"];
            return;
        }
        
    }else{
        if ([NullHandler ifLengthEqualZeroThenAlert:self.countUnit alertMsg:@"请填写计量单位"]) {
            return;
        }
        if ([NullHandler ifLengthEqualZeroThenAlert:self.unitCost alertMsg:@"请填写单位金额"]) {
            return;
        }
        if ([NullHandler ifLengthEqualZeroThenAlert:self.workload alertMsg:@"请填写工作量总数"]) {
            return;
        }
    }
    
    [ZSyncURLConnection request:[UrlFactory createRequirementAddUrl] requestParameter:[self getFormparamter]  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"data:%@",data);
            NSLog(@"dict:%@",dict);
            if ([[dict objectForKey:@"result"] isEqualToString:@"success"]) {
                [PrimaryTools alert:@"发布成功"];
                [self dismissViewControllerAnimated:true completion:nil];
            }else{
                 if ([[[dict objectForKey:@"msg"] objectForKey:@"errorcode" ] isEqualToString:@"user_not_identify"]) {
                     [PrimaryTools alert:@"您未做实名认证，请在我的中心中做实名认证。"];
                 }else if ([[[dict objectForKey:@"msg"] objectForKey:@"errorcode" ] isEqualToString:@"jiaoyi_moshi_is_empty"]) {
                     [PrimaryTools alert:@"发布失败，您未选择交易模式！"];
                 }else [PrimaryTools alert:@"发布失败"];
            }
        });}
                     errorBlock:^(NSError *error) {
                          [PrimaryTools alert:@"发布失败"];
                         //                         NSLog(@"error %@",error);
                     }];
}

-(NSMutableDictionary*)getFormparamter
{
    NSMutableDictionary *formparamter = [[NSMutableDictionary alloc] init];
    [formparamter setValue:self.dealMode forKey:@"jiaoyi_moshi"];
    [formparamter setValue:self.titleLable.text forKey:@"xqmc"];
    [formparamter setValue:self.isTrusteeship.isOn ? @"1":@"0" forKey:@"jine_tuoguan"];
    [formparamter setValue:self.typeIdentifier forKey:@"xqlb_id"];
    [formparamter setValue:self.cost.text forKey:@"sjje"];
    [formparamter setValue:self.countUnit.titleLabel.text forKey:@"gzldw"];
    [formparamter setValue:self.unitCost.text forKey:@"gzldw_je"];
    [formparamter setValue:self.workload.text forKey:@"gzl_zs"];
    [formparamter setValue:self.phone.text forKey:@"lxfs"];
    [formparamter setValue:self.detail.text forKey:@"xqnr"];
    [formparamter setValue:self.peopleNum.text forKey:@"zbrssx"];
    [formparamter setValue:self.overDate.titleLabel.text forKey:@"jhwcrq"];
    [formparamter setValue:self.stopDate.titleLabel.text forKey:@"zbjzrq"];
    [formparamter setValue:[GlobleLocalSession getLoginId] forKey:@"login_id"];
    return formparamter;
}
@end
