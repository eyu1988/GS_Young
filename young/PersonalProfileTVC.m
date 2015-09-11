//
//  PersonalProfileTVC.m
//  young
//
//  Created by z Apple on 8/10/15.
//  Copyright (c) 2015 z. All rights reserved.
//

#import "PersonalProfileTVC.h"
#import "ZPickView.h"
#import "NullHandler.h"
#import "PrimaryTools.h"
#import "ZSyncURLConnection.h"
#import "UrlFactory.h"
#import "GlobleLocalSession.h"

@interface PersonalProfileTVC ()<ZPickViewDelegate>
@property(nonatomic,strong)UIView *uiReceiver;
@property(nonatomic,strong)ZPickView *pickview;
@property(nonatomic,strong)NSString *provinceName;
@property(nonatomic,strong)NSString *cityName;
@end

@implementation PersonalProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    
    NSDictionary *userDict = [GlobleLocalSession getLoginUserInfo];
    self.nickNameTextField.text = [userDict objectForKey:@"nick_name"];
    [self.sexButton setTitle:[userDict objectForKey:@"sex"] forState:UIControlStateNormal];
    NSLog(@"userDict:%@",userDict);
    if (![[userDict objectForKey:@"province"] isEqualToString:@""]
        &&![[userDict objectForKey:@"city"] isEqualToString:@""]) {
        [self.provinceButton setTitle:[NSString stringWithFormat:@"%@%@",[userDict objectForKey:@"province"],[userDict objectForKey:@"city"]] forState:UIControlStateNormal];
        self.provinceName = [userDict objectForKey:@"province"];
        self.cityName = [userDict objectForKey:@"city"];
    }
    [self.birthdayButton setTitle:[userDict objectForKey:@"birthday"] forState:UIControlStateNormal];
    self.qqTextField.text = [userDict objectForKey:@"qq"];
    self.telephoneNumberTextField.text = [userDict objectForKey:@"tel"];

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ZpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZPickView *)pickView resultString:(NSString *)resultString{
    
    if (self.uiReceiver==self.provinceButton) {
        self.provinceName = self.pickview.state;
        self.cityName     = self.pickview.city;
    }else if(self.uiReceiver==self.birthdayButton){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss +0000"];
        NSDate *date=[formatter dateFromString:resultString];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        resultString = [formatter stringFromDate:date];
    }
    [NullHandler NotNil:resultString AssignToUiReceiver:self.uiReceiver];
}
- (IBAction)chooseSex:(id)sender {
    [self textFieldResignFirstResponder];
    self.uiReceiver = sender;
    NSArray *array=@[@"男",@"女"];
    _pickview=[[ZPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    self.pickview.delegate=self;
    [self.pickview show];
}

- (IBAction)chooseBirthday:(id)sender {
    [self textFieldResignFirstResponder];
    self.uiReceiver = sender;
    [self.pickview remove];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-567648000];//18 years age
    self.pickview=[[ZPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    self.pickview.delegate=self;
    [self.pickview show];
}

- (IBAction)chooseProvince:(id)sender {
    [self textFieldResignFirstResponder];
    self.uiReceiver = sender;
    _pickview=[[ZPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    self.pickview.delegate=self;
    [self.pickview show];
}

- (void)textFieldResignFirstResponder
{
    [self.nickNameTextField resignFirstResponder];
    [self.qqTextField resignFirstResponder];
    [self.telephoneNumberTextField resignFirstResponder];
}
- (IBAction)save:(id)sender {
    if(self.nickNameTextField.text.length==0){
        [PrimaryTools alert:@"昵称不能为空！"];
        return;
    }
    NSMutableDictionary *formParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id"
                                          ,self.nickNameTextField.text,@"nick_name"
                                          , nil];
    [formParameter setObject:self.sexButton.titleLabel.text forKey:@"sex"];
    [formParameter setObject:self.birthdayButton.titleLabel.text forKey:@"birthday"];
    [formParameter setObject:self.qqTextField.text forKey:@"qq"];
    [formParameter setObject:self.telephoneNumberTextField.text forKey:@"tel"];
    [formParameter setObject:self.provinceName forKey:@"province"];
    [formParameter setObject:self.cityName forKey:@"city"];
    
    NSLog(@"formParameter:%@",formParameter);
    [ZSyncURLConnection request:[UrlFactory createUpdateUserInfoUrl ]  requestParameter: formParameter  completeBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result:%@",result);
            if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                NSDictionary *dateDict =[result objectForKey:@"data"];
                NSLog(@"dateDict:%@",dateDict);
                [GlobleLocalSession setLoginUserInfo:dateDict];
                [PrimaryTools alert:@"个人信息修改成功！"];
                [PrimaryTools backLayer:self backNum:1];
            }else{
                [PrimaryTools alert:@"个人信息修改失败！"];
            }
        });
    } errorBlock:^(NSError *error) {
        //        NSLog(@"error %@",error);
    }];

    
}
@end
