#import "CERootViewController.h"
#import "CERootView.h"
#import "CEPlayer.h"
#import "CEPlayerResponseHandler.h"
#import "CEHackViewController.h"
#import "CEBeaconsController.h"


static NSString *const KillPlayerMessageText = @"UR DEAD MAN!";
NSString *teamSelectionCommand = @"teamRed";


@interface CERootViewController ()

@property(nonatomic, strong) CEPlayer *player;
@property(nonatomic, strong) CEPlayer *otherPlayer;
@property(nonatomic, strong) CEPlayerResponseHandler *playerResponseHandler;
@end


@implementation CERootViewController {
    GKSession *_session;
    CEBeaconsController *beaconsController;
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
    [self.rootView.fightButton addTarget:self action:@selector(fight) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.respawnButton addTarget:self action:@selector(respawn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)respawn {
    self.player.dead = NO;
    self.rootView.fightButton.enabled = YES;
}

- (void)fight {
    CEHackViewController *controller = [[CEHackViewController alloc] init];
    controller.controllerDelegate = self;

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)connect {
    if (_session == nil) {
        NSString *sessionIDString = @"GKTSessionId";
        _session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
        _session.delegate = self;
        _session.available = YES;
        _session.disconnectTimeout = 0;
    }
}

- (void)sendMessage {
    NSData *textData = [self.rootView.inputTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    [_session sendDataToAllPeers:textData withDataMode:GKSendDataReliable error:&error];
    [self logMessage:[NSString stringWithFormat:@"ERROR IN SENDING MESSAGE: %@", error]];
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSString *stateName;
    switch (state) {
        case GKPeerStateAvailable:
            stateName = @"GKPeerStateAvailable";
            break;
        case GKPeerStateUnavailable:
            stateName = @"GKPeerStateUnavailable";
            break;
        case GKPeerStateConnected:
            stateName = @"GKPeerStateConnected";
            break;
        case GKPeerStateDisconnected:
            stateName = @"GKPeerStateDisconnected";
            break;
        case GKPeerStateConnecting:
            stateName = @"GKPeerStateConnecting";
            break;
    }
    [self logMessage:[NSString stringWithFormat:@"Session: %@ with peer: %@ did change state: %@", nil, peerID, stateName]];

    switch (state) {
        case GKPeerStateAvailable:
            [session connectToPeer:peerID withTimeout:0];
            break;
        case GKPeerStateUnavailable:
            self.rootView.sendButton.enabled = NO;
            _session.delegate = nil;
            _session = nil;
            break;
        case GKPeerStateConnected:
            self.player = [CEPlayer playerWithTeamId:CEPlayerBlue];
            self.otherPlayer = [CEPlayer playerWithTeamId:CEPlayerRed];
            beaconsController = [[CEBeaconsController alloc] initWithPlayer:self.player];
            beaconsController.delegate = self;

            [self performSelector:@selector(setTeams) withObject:nil afterDelay:arc4random_uniform(10000) / 2000.f];

            [session setDataReceiveHandler:self withContext:nil];
            self.rootView.sendButton.enabled = YES;
            break;
        case GKPeerStateDisconnected:
            self.rootView.sendButton.enabled = NO;
            _session.delegate = nil;
            _session = nil;
            break;
        case GKPeerStateConnecting:
            [session connectToPeer:peerID withTimeout:0];
            break;
    }
}

- (void)setTeams {
    [self sendMessage:teamSelectionCommand];
}

- (void)sendMessage:(NSString *)string {
    [self logMessage:[NSString stringWithFormat:@">>> %@", string]];
    NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    [_session sendDataToAllPeers:textData withDataMode:GKSendDataReliable error:&error];
    [self logMessage:[NSString stringWithFormat:@"ERROR IN SENDING MESSAGE: %@", error]];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    [self logMessage:[NSString stringWithFormat:@"Session: %@ did recieve connection request from peer: %@", nil, peerID]];

    NSError *error;
    [session acceptConnectionFromPeer:peerID error:&error];
    [self logMessage:[NSString stringWithFormat:@"Error in accepting session: %@", error]];

    [_session connectToPeer:peerID withTimeout:0];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    [self logMessage:[NSString stringWithFormat:@"Session: %@ connection with peer failed: %@ with error: %@", nil, peerID, error]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    [self logMessage:[NSString stringWithFormat:@"Session: %@ did fail with error: %@", nil, error]];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self logMessage:[NSString stringWithFormat:@"<<< %@", receivedString]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if ([receivedString isEqualToString:teamSelectionCommand]) {
        self.player = [CEPlayer playerWithTeamId:CEPlayerRed];
        self.otherPlayer = [CEPlayer playerWithTeamId:CEPlayerBlue];
    } else if ([receivedString isEqualToString:KillPlayerMessageText]) {
        self.player.dead = YES;
        self.rootView.fightButton.enabled = NO;
    } else {
        [self.playerResponseHandler handleResponseData:data fromPlayer:self.otherPlayer];
    }
    
    beaconsController = [[CEBeaconsController alloc] initWithPlayer:self.player];
    beaconsController.delegate = self;
}

- (void)logMessage:(NSString *)message {
    NSLog(@"%@", message);
    self.rootView.messagesTextView.text = [NSString stringWithFormat:@"%@\n\n%@", message, self.rootView.messagesTextView.text];
}

- (void)setPlayer:(CEPlayer *)player {
    _player = player;
    self.playerResponseHandler = [[CEPlayerResponseHandler alloc] initWithMyPlayer:player];
    self.playerResponseHandler.handlerDelegate = self;

    if (_player.playerId == 1) {
        self.rootView.backgroundColor = [UIColor blueColor];
    } else {
        self.rootView.backgroundColor = [UIColor redColor];
    }
}

- (void)handler:(CEPlayerResponseHandler *)handler didDetectHackAttemptFromPlayer:(CEPlayer *)player {
    CEHackViewController *controller = [[CEHackViewController alloc] init];
    controller.controllerDelegate = self;

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)hackViewControllerDidFinishHacking:(CEHackViewController *)hackViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self sendMessage:KillPlayerMessageText];
}

- (void)beaconsControllerHasOpponentsInRange:(BOOL)has {
    self.rootView.fightButton.enabled = has;
}

- (void)canRespawn:(BOOL)canRespawn {
    self.rootView.respawnButton.enabled = YES;

}


@end
