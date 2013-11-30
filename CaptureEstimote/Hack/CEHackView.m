#import "CEHackView.h"


@interface CEHackView ()
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *hackButton;
@end

@implementation CEHackView {

}

- (id)init {
    self = [super init];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        self.textField = [[UITextField alloc] init];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        self.hackButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.hackButton setTitle:@"Hack" forState:UIControlStateNormal];

    }

    return self;
}

@end
