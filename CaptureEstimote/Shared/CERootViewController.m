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
        [session setDataReceiveHandler:self withContext:nil];
        self.rootView.sendButton.enabled = YES;
    } else {
        self.rootView.sendButton.enabled = NO;
        _session.delegate = nil;
        _session = nil;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {

}



@end