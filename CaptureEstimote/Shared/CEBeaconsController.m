#import "CEBeaconsController.h"
#import "ESTBeaconManager.h"
#import "CEPlayer.h"


@implementation CEBeaconsController {

    ESTBeaconManager *beaconManager;
    int mostSignificantBeaconNumber;
    NSMutableArray *immediateBeacons;
    NSMutableArray *nearBeacons;
    NSMutableArray *farBeacons;
    int opponentsSignificantBeaconNumber;
    int playerId;
    NSMutableDictionary *changingBeacons;
}

NSInteger PLAYER_ID = 1110;
NSInteger BASE_ID = 1111;
NSInteger FLAG_ID = 1112;

- (id)initWithPlayer:(CEPlayer *)player {
    self = [super init];
    if (self) {
        immediateBeacons = [NSMutableArray new];
        nearBeacons = [NSMutableArray new];
        farBeacons = [NSMutableArray new];
        changingBeacons = [NSMutableDictionary new];

        mostSignificantBeaconNumber = player.teamBeaconsMostSignificantNumber;
        opponentsSignificantBeaconNumber = player.opponentsBeaconsMostSignificantNumber;
        playerId = player.playerId;
        beaconManager = [[ESTBeaconManager alloc] init];
        beaconManager.delegate = self;
        beaconManager.avoidUnknownStateBeacons = YES;

        ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithIdentifier:@"EstimoteSampleRegion"];
        [beaconManager startRangingBeaconsInRegion:region];

        [beaconManager startAdvertisingWithMajor:(ESTBeaconMajorValue) (10000 * mostSignificantBeaconNumber + PLAYER_ID) withMinor:0 withIdentifier:@"EstimoteSampleRegion"];
    }

    return self;
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    [immediateBeacons removeAllObjects];
    [nearBeacons removeAllObjects];
    [farBeacons removeAllObjects];

    for (ESTBeacon *beacon in beacons) {
        switch (beacon.ibeacon.proximity) {
            case CLProximityUnknown:
                break;
            case CLProximityImmediate: {
                [immediateBeacons addObject:beacon];
                NSArray *flagsToChange = [self flagsInProximityNeedsChanging:immediateBeacons toOccupied:YES];
                if (flagsToChange.count > 0) {
                    [self tagFlags:flagsToChange state:YES];
                }
                break;
            }
            case CLProximityNear:
                [nearBeacons addObject:beacon];
                break;
            case CLProximityFar:
                [farBeacons addObject:beacon];
                NSArray *flagsToChange = [self flagsInProximityNeedsChanging:farBeacons toOccupied:NO];
                if (flagsToChange.count > 0) {
                    [self tagFlags:flagsToChange state:NO];
                }
                break;
        }
    }

}

- (short)ourBaseMajorId {
    return (short) ([self getTeamPrefix] + BASE_ID);
}

- (short)opponentsBaseMajorId {
    return (short) ([self getOpponentsPrefix] + BASE_ID);
}

- (short)ourFlagMajorId {
    return (short) ([self getTeamPrefix] + FLAG_ID);
}

- (short)opponentsFlagMajorId {
    return (short) ([self getOpponentsPrefix] + FLAG_ID);
}

- (int)getOpponentsPrefix {
    return opponentsSignificantBeaconNumber * 10000;
}

- (int)getTeamPrefix {
    return mostSignificantBeaconNumber * 10000;
}

- (NSArray *)flagsInProximityNeedsChanging:(NSMutableArray *)array toOccupied:(BOOL)shouldBeTagged {
    short opponentsFlagMajorId = [self opponentsFlagMajorId];
    short ourFlagMajorId = [self ourFlagMajorId];
    NSMutableArray *flagsToChange = [NSMutableArray new];
    for (ESTBeacon *beacon in array) {
        short majorId = beacon.ibeacon.major.shortValue;
        if (majorId == ourFlagMajorId || majorId == opponentsFlagMajorId) {
            BOOL flagIsTagged = (beacon.ibeacon.minor.shortValue | playerId) > 0;
            if (flagIsTagged != shouldBeTagged) {
                [flagsToChange addObject:beacon];
            }
        }
    }
    return flagsToChange;
}

- (void)tagFlags:(NSArray *)flags state:(BOOL)tagged {
    for (ESTBeacon *beacon in flags) {
        [changingBeacons setObject:[NSNumber numberWithBool:tagged] forKey:beacon.ibeacon.major];
        beacon.delegate = self;
    }
}

- (short)getShortWithoutOurBit:(ESTBeacon *)beacon {
    short beaconMinor = beacon.ibeacon.minor.shortValue;
    short mask = (short) (0xff ^ playerId);
    return beaconMinor | mask;
}

- (void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {

}

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {

}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {

}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {

}

- (void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {

}

- (void)beaconManagerDidStartAdvertising:(ESTBeaconManager *)manager error:(NSError *)error {

}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
}

- (void)beaconManager:(ESTBeaconManager *)manager didFailDiscoveryInRegion:(ESTBeaconRegion *)region {

}

#pragma mark - Beacon delegate

- (void)beaconConnectionDidFail:(ESTBeacon *)beacon withError:(NSError *)error {
    NSLog(@"%@, beaconMajor:%@ error:%@", NSStringFromSelector(_cmd), beacon.ibeacon.major, error);
    if (error.code != 401 && error.code != 404) {
        [beacon connectToBeacon];
    }
}

- (void)beaconConnectionDidSucceeded:(ESTBeacon *)beacon {
    NSLog(@"%@, beaconMajor:%@", NSStringFromSelector(_cmd), beacon.ibeacon.major);
    NSNumber *shouldBeTagged = [changingBeacons objectForKey:beacon];
    BOOL tag = shouldBeTagged.boolValue;
    short whatToWrite = (short) ([self getShortWithoutOurBit:beacon] + playerId * (tag ? 1 : 0));
    [beacon writeBeaconMinor:whatToWrite withCompletion:^(unsigned int value, NSError *error) {
        NSLog(@"Error: %@, value %d", error, value);
        [beacon disconnectBeacon];
    }];
}

- (void)beaconDidDisconnect:(ESTBeacon *)beacon withError:(NSError *)error {
    NSLog(@"%@, beaconMajor:%@ error:%@", NSStringFromSelector(_cmd), beacon.ibeacon.major, error);
    beacon.delegate = nil;
    [changingBeacons removeObjectForKey:beacon];
}

- (BOOL)canSpawnNow {
    short ourBaseMajorId = [self ourBaseMajorId];
    for (ESTBeacon *beacon in immediateBeacons) {
        short beaconMajorId = beacon.ibeacon.major.shortValue;
        if (beaconMajorId == ourBaseMajorId) return YES;
    }
    return NO;
}


@end