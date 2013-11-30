#import <Foundation/Foundation.h>


@interface CEPlayer : NSObject
@property (nonatomic) int playerId;
@property (nonatomic, copy) NSString *peerId;

- (BOOL)isPlayerSameTeam:(CEPlayer *)player;
@end
