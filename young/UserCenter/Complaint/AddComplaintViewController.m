//
//  AddComplaintViewController.m
//  young
//
//  Created by Lucas on 15/8/27.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "AddComplaintViewController.h"
#import "ZSyncURLConnection.h"  
#import "UrlFactory.h"
#import "GlobleLocalSession.h"
#import "PrimaryTools.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GSDefine.h"

#define DEFAULT_IMG [UIImage imageNamed:@"uploadDefaultImg.png"]

@interface AddComplaintViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray * _JBTypeArray;
    BOOL _typeSelected;
    long _selectedIndex;
    long _currentTag;
}

@property (nonatomic, strong)UITableView * selectionTV;
@property (nonatomic, strong)NSMutableArray * fileIdArray;

@end

@implementation AddComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"投诉";
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
//    submitButton.titleLabel.font= [UIFont systemFontOfSize:16];
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    
    _fileIdArray = [[NSMutableArray alloc] init];
    _JBTypeArray = @[@"垃圾广告",@"TA要求我线下交易",@"雇主涉嫌作弊",@"雇主审标不合理",@"雇主要求不合理",@"雇主拒绝赏金",@"服务商未按时完成工作", @"服务商拒绝修改作品", @"服务商要求追加赏金", @"服务商无能力完成要求"];
    
    [self resetContent]; // 要放在_JBTypeArray下面
    
    _titleTF.delegate = self;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeClick)];
    [_typeLabel addGestureRecognizer:singleTap];
    
    _contentTextView.delegate = self;
    
    [_photoBtn addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photoBtn2 addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_photoBtn3 addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [_deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn2 addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn3 addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectionTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _typeLabel.superview.frame.origin.y+_typeLabel.superview.frame.size.height, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    _selectionTV.dataSource = self;
    _selectionTV.delegate = self;
    _selectionTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectionTV];
}

- (void) submitClick
{
    NSLog(@"提交");
    if (!_deleteBtn3.hidden) {
        [self requestUploadFilesWithBtn:_photoBtn3];
        [self requestUploadFilesWithBtn:_photoBtn2];
        [self requestUploadFilesWithBtn:_photoBtn];
    }
    else if (!_deleteBtn2.hidden) {
        [self requestUploadFilesWithBtn:_photoBtn2];
        [self requestUploadFilesWithBtn:_photoBtn];
    }
    else if (!_deleteBtn.hidden) {
        [self requestUploadFilesWithBtn:_photoBtn];
    }
    else{
        if (_isNewComplaint) {
            [self requestAddComplaintData];
        }
        else{
            [self requestJuzheng];
        }
    }
}

- (void) typeClick
{
    NSLog(@"点击" );
    [_contentTextView resignFirstResponder];
    if (!_typeSelected) {
        _typeSelected = YES;
        [self selectionTVMoveDown];
    }
    else{
        _typeSelected = NO;
        [self selectionTVMoveUp];
    }
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_JBTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"selectCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    cell.textLabel.text = _JBTypeArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
    _typeLabel.text = [NSString stringWithFormat:@"> %@", [_JBTypeArray objectAtIndex:indexPath.row]];
    _typeSelected = NO;
    _selectedIndex = indexPath.row + 1;
    [self selectionTVMoveUp];
}

- (void)selectionTVMoveDown
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _selectionTV.frame = CGRectMake(0, _typeLabel.superview.frame.origin.y+_typeLabel.superview.frame.size.height, self.view.frame.size.width, 300.f);
    }];
}

- (void)selectionTVMoveUp
{
    [UIView animateWithDuration:0.3 animations:^{
        _selectionTV.frame = CGRectMake(0, _typeLabel.superview.frame.origin.y+_typeLabel.superview.frame.size.height, self.view.frame.size.width, 0);
    }];
    
}

#pragma mark - 请求网络
- (void)requestUploadFilesWithBtn:(UIButton *)btn
{
   
    NSDictionary *formParamter = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId], @"login_id" , nil];
    
    [ZSyncURLConnection upload:@"file"
                                                filename:@"evidencePhoto"
                                                mimeType:@"image/png"
                                                data:[NSData dataWithData:UIImagePNGRepresentation(btn.currentBackgroundImage)]
                                                parmas:formParamter
                                                strUrl:[UrlFactory createComplaintFujianUrl]
                                                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (data) {
                     NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                          NSLog(@"result:%@",result);
                     if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
                         
                         NSDictionary *dateDict =[result objectForKey:@"data"];
                         if ([dateDict objectForKey:@"fileId"]) {
                             NSString * fileId = [dateDict objectForKey:@"fileId"];
                             [_fileIdArray addObject:fileId];
                             NSLog(@"%@", _fileIdArray);
                             if (btn == _photoBtn) {
                                 if (_isNewComplaint) {
                                     [self requestAddComplaintData];
                                 }
                                 else{
                                     [self requestJuzheng];
                                 }
                             }
                             
                         }
                     }else{
//                         [self.myView removeFromSuperview];
                         [PrimaryTools alert:@"图片上传失败。"];
                     }
                 }else{
//                     [self.myView removeFromSuperview];
                     [PrimaryTools alert:@"图片上传失败。"];
                 }
             }];
}

- (void)choosePhoto:(UIButton *)sender
{
    NSLog(@"tag %ld", sender.tag);
    _currentTag = sender.tag;

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照",@"相册",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

- (void)deletePhoto:(UIButton *)sender
{
    
    if (sender.tag == 201) {
        if (!_deleteBtn2.hidden) {
            [_photoBtn setBackgroundImage:_photoBtn2.currentBackgroundImage forState:UIControlStateNormal];
            if (!_deleteBtn3.hidden) {
                [_photoBtn2 setBackgroundImage:_photoBtn3.currentBackgroundImage forState:UIControlStateNormal];
                [_photoBtn3 setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
                _deleteBtn3.hidden = YES;
            }
            else{
                [_photoBtn2 setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
                _deleteBtn2.hidden = YES;
                _photoBtn3.hidden = YES;
            }
        }
        else{
            [_photoBtn setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
            _deleteBtn.hidden = YES;
            _photoBtn2.hidden = YES;
        }
    }
    else if (sender.tag == 202) {
        if (!_deleteBtn3.hidden) {
            [_photoBtn2 setBackgroundImage:_photoBtn3.currentBackgroundImage forState:UIControlStateNormal];
            [_photoBtn3 setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
            _deleteBtn3.hidden = YES;
        }
        else{
            [_photoBtn2 setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
            _deleteBtn2.hidden = YES;
            _photoBtn3.hidden = YES;
        }
    }
    else if (sender.tag == 203) {
        [_photoBtn3 setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
        _deleteBtn3.hidden = YES;
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex<2){
        UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
        uiipc.delegate = self;
        uiipc.mediaTypes=@[(NSString*)kUTTypeImage];
        uiipc.allowsEditing=YES;
        if (buttonIndex == 0) {;
            uiipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        }else if(buttonIndex == 1) {
            uiipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:uiipc animated:YES completion:NULL];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *headImage =info[UIImagePickerControllerEditedImage];
    
    if(!headImage)
        headImage=info[UIImagePickerControllerOriginalImage];
    
    if (_currentTag == 101 ) {
        [_photoBtn setBackgroundImage:headImage forState:UIControlStateNormal];
        _photoBtn2.hidden = NO;
        _deleteBtn.hidden = NO;
    }
    else if (_currentTag == 102) {
        [_photoBtn2 setBackgroundImage:headImage forState:UIControlStateNormal];
        _photoBtn3.hidden = NO;
        _deleteBtn2.hidden = NO;
    }
    else if (_currentTag == 103) {
        [_photoBtn3 setBackgroundImage:headImage forState:UIControlStateNormal];
        _deleteBtn3.hidden = NO;
    }
    
    [NSData dataWithData:UIImagePNGRepresentation(headImage)];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)requestAddComplaintData
{

    NSMutableString * fileIds = [[NSMutableString alloc] init];
    
    if ([_fileIdArray count] > 0) {
        for(long i = [_fileIdArray count]-1; i >= 0; i--){
            [fileIds appendString:[NSString stringWithFormat:@"%@,",_fileIdArray[i]]];
        }
        NSRange range;
        range.location = fileIds.length-1;
        range.length = 1;
        [fileIds deleteCharactersInRange:range];
        [_fileIdArray removeAllObjects];
    }
    else{
        fileIds = nil;
    }
    
    if (!_titleTF.text || [_titleTF.text isEqualToString:@""]) { //如果多个空格, 还需要有待解决
        [PrimaryTools alert:@"请添加标题"];
        [_fileIdArray removeAllObjects];
        return;
    }
    
    NSLog( @"id %@", _orderID );
//    _orderID = @"3305389349070748";
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", _orderID,@"xq_fws_id", [NSString stringWithFormat:@"%ld", _selectedIndex], @"leibie", _titleTF.text,@"biaoti", _contentTextView.text,@"neirong", fileIds,@"fileIds", nil];

    NSLog(@"\n添加投诉 :\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createAddComplaintUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                                            NSLog(@"\ncomplaint :\n%@", dict);

                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"添加投诉 - 数据获取失败");
                          [PrimaryTools alert:@"添加失败, 请重新提交"];
                          return ;
                      }
                      
                      NSLog(@"添加投诉 - 数据获取成功");
//                      NSDictionary * dataDict = [dict objectForKey:@"data"];
//                      NSString * jvId = [dataDict objectForKey:@"jvId"];
                      [self resetContent];
                      [PrimaryTools alert:@"提交成功"];
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [PrimaryTools alert:@"添加失败, 请重新提交"];
                     }];
}

- (void)requestJuzheng
{
    
    NSMutableString * fileIds = [[NSMutableString alloc] init];
    
    if ([_fileIdArray count] > 0) {
        for(long i = [_fileIdArray count]-1; i >= 0; i--){
            [fileIds appendString:[NSString stringWithFormat:@"%@,",_fileIdArray[i]]];
        }
        NSRange range;
        range.location = fileIds.length-1;
        range.length = 1;
        [fileIds deleteCharactersInRange:range];
        [_fileIdArray removeAllObjects];
    }
    else{
        fileIds = nil;
    }
    
    /*
    if (!_titleTF.text || [_titleTF.text isEqualToString:@""]) { //如果多个空格, 还需要有待解决
        [PrimaryTools alert:@"请添加标题"];
        [_fileIdArray removeAllObjects];
        return;
    }
    */
    
//    _orderID = @"3305389349070748";
//    NSString * type = @"0";
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:[GlobleLocalSession getLoginId],@"login_id", _complaintID,@"jbId", _userType, @"type", _contentTextView.text,@"neirong", fileIds,@"fileIds", nil];
    
    //    NSLog(@"\ncomplaint :\n%@", para);
    
    [ZSyncURLConnection request:[UrlFactory createJuzhengUrl] requestParameter:para
                  completeBlock:^(NSData *data) {
                      
                      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"\n追加举证:\n%@", dict);
                      
                      NSString * result = [dict objectForKey:@"result"];
                      if (![result isEqualToString:@"success"]) {
                          NSLog(@"添加投诉 - 数据获取失败");
                          [PrimaryTools alert:@"添加失败, 请重新提交"];
                          return ;
                      }
                      
                      NSLog(@"添加投诉 - 数据获取成功");
                      //                      NSDictionary * dataDict = [dict objectForKey:@"data"];
                      //                      NSString * jvId = [dataDict objectForKey:@"jvId"];
                      [self resetContent];
                      [PrimaryTools alert:@"提交成功"];
                  }
                     errorBlock:^(NSError *error) {
                         NSLog(@"error %@",error);
                         [PrimaryTools alert:@"添加失败, 请重新提交"];
                     }];
}

- (void) resetContent
{
    if (!_isNewComplaint) {
        _titleTF.text = _complaintTitle;
        _titleTF.enabled = NO;
        _typeLabel.text = [NSString stringWithFormat:@"> %@", _JBTypeArray[[_complaintType intValue]-1]];
        _typeLabel.userInteractionEnabled = NO;
    }
    else{
        _titleTF.text = @"";
        _titleTF.enabled = YES;
        _typeLabel.text = [NSString stringWithFormat:@"> %@", _JBTypeArray[0]];
        _typeLabel.userInteractionEnabled = YES;
    }
    
    _selectedIndex = 1;
    _typeSelected = NO;
    _contentTextView.text = @"我要投诉...";
    
    _currentTag = 0;
    [_photoBtn setBackgroundImage:DEFAULT_IMG forState:UIControlStateNormal];
    _photoBtn2.hidden = YES;
    _photoBtn3.hidden = YES;
    _deleteBtn.hidden = YES;
    _deleteBtn2.hidden = YES;
    _deleteBtn3.hidden = YES;
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

@end
