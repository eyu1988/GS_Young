
#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface CLTreeView_LEVEL1_Cell : UITableViewCell

@property (retain,strong,nonatomic) CLTreeViewNode *node;//data
@property (strong,nonatomic) IBOutlet UIImageView *arrowView;//箭头
@property (strong,nonatomic) IBOutlet UILabel *sonCount;//叶子数
@property (strong,nonatomic) IBOutlet UILabel *name;

@end

