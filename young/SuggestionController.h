//
//  Suggestion Controller.h
//  young
//
//  Created by z Apple on 15/4/9.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionController : UITableViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *suggestionText;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceHolder;

@end
