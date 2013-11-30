#import <Foundation/Foundation.h>

@class CEPlayer;
@class CEPlayerResponseHandler;

@protocol CEPlayerResponseHandlerDelegate
- (void)handler:(CEPlayerResponseHandler *)handler didDetectHackAttemptFromPlayer:(CEPlayer *)player;
@end

@interface CEPlayerResponseHandler : NSObject

@property (nonatomic, weak) id<CEPlayerResponseHandlerDelegate> handlerDelegate;

- (instancetype)initWithMyPlayer:(CEPlayer *)player;
- (void)handleResponseData:(NSData *)responseData fromPlayer:(CEPlayer *)player;
@end
