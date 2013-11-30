#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface CERootViewController : UIViewController <GKSessionDelegate>

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context;
@end