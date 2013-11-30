#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "CEPlayerResponseHandler.h"
#import "CEHackViewController.h"
#import "CEBeaconsController.h"

@class CEPlayer;
@class CEPlayerResponseHandler;


@interface CERootViewController : UIViewController <GKSessionDelegate, CEPlayerResponseHandlerDelegate, CEHackViewControllerDelegate, CEBeaconsControllerDelegate>

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context;

@end
