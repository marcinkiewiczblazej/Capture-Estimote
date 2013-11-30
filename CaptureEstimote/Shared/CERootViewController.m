#import "CERootViewController.h"
#import "CERootView.h"


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
    [self logMessage:[NSString stringWithFormat:@"%@", receivedString]];
}

- (void)logMessage:(NSString *)message {
    NSLog(@"%@", message);
    self.rootView.messagesTextView.text = [NSString stringWithFormat:@"%@\n\n%@", message, self.rootView.messagesTextView.text];
}

@end