#import "CEPlayer.h"


@implementation CEPlayer {

}

+ (CEPlayer *)playerWithTeamId:(CEPlayerTeam)teamId {
    CEPlayer *player = [[CEPlayer alloc] init];
    if (teamId == CEPlayerBlue) {
        player.playerId = 0x01;
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

- (int)teamBeaconsMostSignificantNumber {
    if (self.playerId == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (int)opponentsBeaconsMostSignificantNumber {
    if (self.playerId == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (short)teamMask {
    if (self.playerId == 0) {
        return 1;
    } else {
        return 2;
    }
}

@end
