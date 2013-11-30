#import <Foundation/Foundation.h>
#import "ESTBeaconManager.h"

@class CEPlayer;


@interface CEBeaconsController : NSObject <ESTBeaconManagerDelegate, ESTBeaconDelegate>
- (id)initWithPlayer:(CEPlayer *)player;

- (BOOL)canSpawnNow;
@end