
#import <Foundation/Foundation.h>

@interface CLTreeView_LEVEL0_Model : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *headImgPath;//本地图片名,若不为空则优先于远程图片加载
@property (strong,nonatomic) NSURL *headImgUrl;//远程图片链接

@end

