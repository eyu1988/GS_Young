
#import <UIKit/UIKit.h>

@protocol ZActivityDelegate <NSObject>
- (void)didClickOnImageIndex:(NSInteger *)imageIndex;
@optional
- (void)didClickOnCancelButton;
@end

@interface ZActivity : UIView

- (id)initWithTitle:(NSString *)title delegate:(id<ZActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;
- (void)showInView:(UIView *)view;

@end
