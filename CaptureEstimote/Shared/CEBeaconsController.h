#import <Foundation/Foundation.h>
#import "ESTBeaconManager.h"

@class CEPlayer;

@protocol CEBeaconsControllerDelegate
- (void)beaconsControllerHasOpponentsInRange:(BOOL)has;
- (void)canRespawn:(BOOL)canRespawn;
@end

@interface CEBeaconsController : NSObject <ESTBeaconManagerDelegate, ESTBeaconDelegate>
@property id<CEBeaconsControllerDelegate> delegate;
- (id)initWithPlayer:(CEPlayer *)player;

- (BOOL)canSpawnNow;
@end