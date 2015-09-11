
#import <Foundation/Foundation.h>

@interface CLTreeView_LEVEL2_Model : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *signture;
@property (strong,nonatomic) NSString *headImgPath;//本地图片名,若不为空则优先于远程图片加载
@property (strong,nonatomic) NSURL *headImgUrl;//远程图片链接
@property (strong,nonatomic) NSString *identifer;
@property (strong,nonatomic) NSMutableDictionary *infoDict;
@end

