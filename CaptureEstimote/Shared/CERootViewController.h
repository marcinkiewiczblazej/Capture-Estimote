#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "CEPlayerResponseHandler.h"
#import "CEHackViewController.h"

@class CEPlayer;
@class CEPlayerResponseHandler;


@interface CERootViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate, CEPlayerResponseHandlerDelegate, CEHackViewControllerDelegate>

@end
