#import "CEPlayer.h"


@implementation CEPlayer {

}

+ (CEPlayer *)playerWithTeamId:(CEPlayerTeam)teamId {
    CEPlayer *player = [[CEPlayer alloc] init];
    if (teamId == CEPlayerBlue) {
        player.playerId = 0;
    } else {
        player.playerId = 0x10;
    }
    return player;
}

- (BOOL)isPlayerSameTeam:(CEPlayer *)player {
    int otherPlayerId = player.playerId;
    int otherTeamMask;
    if (self.playerId <= 0xF) {
        otherTeamMask = 0xF0;
    } else {
        otherTeamMask = 0x0F;
    }

    return (otherPlayerId & otherTeamMask) == 0;
}

@end
