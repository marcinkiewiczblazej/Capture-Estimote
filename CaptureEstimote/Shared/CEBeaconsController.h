#import <Foundation/Foundation.h>
#import "ESTBeaconManager.h"


@interface CEBeaconsController : NSObject <ESTBeaconManagerDelegate, ESTBeaconDelegate>
- (BOOL)canSpawnNow;
@end