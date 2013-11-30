#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "CEPlayerResponseHandler.h"
#import "CEHackViewController.h"

@class CEPlayer;
@class CEPlayerResponseHandler;


@interface CERootViewController : UIViewController <GKSessionDelegate, CEPlayerResponseHandlerDelegate, CEHackViewControllerDelegate>

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context;

@end
