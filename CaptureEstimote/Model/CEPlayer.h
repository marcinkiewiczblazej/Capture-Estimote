#import <Foundation/Foundation.h>

typedef enum {
    CEPlayerBlue = 1,
    CEPlayerRed = 0x10000;
} CEPlayerTeam;

@interface CEPlayer : NSObject
@property (nonatomic) int playerId;
@property (nonatomic, copy) NSString *peerId;

+ (CEPlayer *)playerWithTeamId:(CEPlayerTeam)teamId;

- (BOOL)isPlayerSameTeam:(CEPlayer *)player;
@end
