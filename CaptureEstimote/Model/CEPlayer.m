#import "CEPlayer.h"


@implementation CEPlayer {

}
- (BOOL)isPlayerSameTeam:(CEPlayer *)player {
    int otherPlayerId = player.playerId;
    int otherTeamMask;
    if (self.playerId <= 0xFFFF) {
        otherTeamMask = 0xFFFF0000;
    } else {
        otherTeamMask = 0xFFFF;
    }

    return (otherPlayerId & otherTeamMask) == 0;
}

@end
