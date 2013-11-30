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
        self.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        self.textField = [[UITextField alloc] init];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        self.hackButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.hackButton setTitle:@"Hack" forState:UIControlStateNormal];
        self.hackButton.enabled = NO;
        [self.hackButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self.hackButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self addSubview:self.hackButton];

        self.numberToType = 0;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    int topMargin = 30;
    [self.label sizeToFit];
    self.label.center = CGPointMake(self.bounds.size.width * 0.5f, topMargin + self.label.frame.size.height * 0.5f);

    [self.textField sizeToFit];
    self.textField.frame = CGRectMake(5, CGRectGetMaxY(self.label.frame) + 5, self.bounds.size.width - 2 * 5, self.textField.frame.size.height);

    [self.hackButton sizeToFit];
    self.hackButton.frame = CGRectMake((self.bounds.size.width - self.textField.frame.size.width) * 0.5f, CGRectGetMaxY(self.textField.frame), self.hackButton.frame.size.width, self.hackButton.frame.size.height);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([text isEqualToString:self.label.text]) {
        self.hackButton.enabled = YES;
    } else {
        self.hackButton.enabled = NO;
    }

    return YES;
}

- (void)setNumberToType:(int)numberToType {
    _numberToType = numberToType;

    self.label.text = [NSString stringWithFormat:@"%04d", numberToType];
    [self setNeedsLayout];
}


@end
