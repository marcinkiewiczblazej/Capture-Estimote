#import <Foundation/Foundation.h>

typedef enum {
    CEPlayerBlue = 1,
    CEPlayerRed = 0x10
} CEPlayerTeam;

@interface CEPlayer : NSObject
@property (nonatomic) int playerId;
@property (nonatomic, copy) NSString *peerId;

@property(nonatomic) BOOL dead;

+ (CEPlayer *)playerWithTeamId:(CEPlayerTeam)teamId;

- (BOOL)isPlayerSameTeam:(CEPlayer *)player;
- (int)teamBeaconsMostSignificantNumber;

- (int)opponentsBeaconsMostSignificantNumber;
@end
