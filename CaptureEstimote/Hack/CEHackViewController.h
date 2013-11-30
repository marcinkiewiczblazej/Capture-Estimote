#import <Foundation/Foundation.h>

@class CEHackViewController;

@protocol CEHackViewControllerDelegate
- (void)hackViewControllerDidFinishHacking:(CEHackViewController *)hackViewController;
@end

@interface CEHackViewController : UIViewController

@property (nonatomic, weak) id<CEHackViewControllerDelegate> controllerDelegate;
@end
