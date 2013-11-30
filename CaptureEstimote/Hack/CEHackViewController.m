#import "CEHackViewController.h"
#import "CEHackView.h"


@implementation CEHackViewController {

}

- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (void)loadView {
    [super loadView];

    CEHackView *view = [[CEHackView alloc] init];
    view.numberToType = arc4random_uniform(10000);
    [view.hackButton addTarget:self action:@selector(didTapHack) forControlEvents:UIControlEventTouchUpInside];
    [view.textField becomeFirstResponder];
    self.view = view;
}

- (void)didTapHack {
    [self.controllerDelegate hackViewControllerDidFinishHacking:self];
}




@end
