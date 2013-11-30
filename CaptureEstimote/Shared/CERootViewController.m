#import "CERootViewController.h"
#import "CERootView.h"
#import "CEPlayer.h"
#import "CEPlayerResponseHandler.h"
#import "CEHackViewController.h"


@interface CERootViewController ()
@property(nonatomic, strong) CEPlayer *player;
@property(nonatomic, strong) CEPlayer *otherPlayer;
@property(nonatomic, strong) CEPlayerResponseHandler *playerResponseHandler;
@end

@implementation CERootViewController {
    GKSession *_session;
}

- (CERootView *)rootView {
    return (CERootView *) self.view;
}

- (void)loadView {
    self.view = [[CERootView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.rootView.connectButton addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)connect {
    if (_session == nil) {
        self.player = [CEPlayer playerWithTeamId:CEPlayerBlue];
        GKPeerPickerController *peerPickerController = [[GKPeerPickerController alloc] init];
        peerPickerController.delegate = self;
        peerPickerController.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        [peerPickerController show];
    }
}

- (void)sendMessage {
    NSData *textData = [self.rootView.inputTextField.text dataUsingEncoding:NSASCIIStringEncoding];
    [_session sendDataToAllPeers:textData withDataMode:GKSendDataReliable error:nil];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    NSString *sessionIDString = @"GKTSessionId";
    GKSession *session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    session.delegate = self;
    _session = session;
    picker.delegate = nil;
    [picker dismiss];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateConnected) {
        if (self.player == nil) {
            self.player = [CEPlayer playerWithTeamId:CEPlayerRed];
            self.otherPlayer = [CEPlayer playerWithTeamId:CEPlayerBlue];
        } else {
            self.otherPlayer = [CEPlayer playerWithTeamId:CEPlayerRed];
        }

        [session setDataReceiveHandler:self withContext:nil];
        self.rootView.sendButton.enabled = YES;
    } else {
        self.rootView.sendButton.enabled = NO;
        _session.delegate = nil;
        _session = nil;
    }
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSLog(@"%@", data);
    [self.playerResponseHandler handleResponseData:data fromPlayer:self.otherPlayer];
}

- (void)setPlayer:(CEPlayer *)player {
    _player = player;
    self.playerResponseHandler = [[CEPlayerResponseHandler alloc] initWithMyPlayer:player];
    self.playerResponseHandler.handlerDelegate = self;
}

- (void)handler:(CEPlayerResponseHandler *)handler didDetectHackAttemptFromPlayer:(CEPlayer *)player {
    CEHackViewController *controller = [[CEHackViewController alloc] init];
    controller.controllerDelegate = self;

    [self presentViewController:controller animated:YES completion:nil];
}


@end
