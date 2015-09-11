
#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface CLTreeView_LEVEL2_Cell : UITableViewCell

@property (retain,strong,nonatomic) CLTreeViewNode *node;//data
@property (strong,nonatomic) IBOutlet UIImageView *headImg;
@property (strong,nonatomic) IBOutlet UILabel *signture;//个性签名
@property (strong,nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) NSString *identifer;
@property (strong,nonatomic) NSMutableDictionary *infoDict;

@end
