#import "CEPlayerResponseHandler.h"
#import "CEPlayer.h"


@interface CEPlayerResponseHandler ()
@property(nonatomic, strong) CEPlayer *player;
@end

@implementation CEPlayerResponseHandler {

}

- (instancetype)initWithPlayer:(CEPlayer *)player {
    self = [self init];
    if (self) {
        self.player = player;
    }
    
    return self;
}

- (void)handleResponseData:(NSData *)responseData fromPlayer:(CEPlayer *)player {
    if (![self.player isPlayerSameTeam:player]) {
        [self.handlerDelegate handler:self didDetectHackAttemptFromPlayer:player];
    }
}

@end
