//
// Created by Tomasz Netczuk on 30/11/13.
// Copyright (c) 2013 neciu corporation. All rights reserved.
//


#import "CERootView.h"


@implementation CERootView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [self addSubview:_connectButton];

        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        _sendButton.enabled = NO;
        [self addSubview:_sendButton];

        _inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputTextField.tintColor = [UIColor darkGrayColor];
        [self addSubview:_inputTextField];

        _messagesTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _messagesTextView.tintColor = [UIColor darkGrayColor];
        [self addSubview:_messagesTextView];
    }

    return self;
}

- (void)layoutSubviews {
    float Padding = 12;
    float LabelWidth = self.bounds.size.width - 2 * Padding;
    float y;

    y = Padding * 2;
    [_connectButton sizeToFit];
    _connectButton.frame = CGRectMake(Padding, y, _connectButton.bounds.size.width, _connectButton.bounds.size.height);

    y = CGRectGetMaxY(_connectButton.frame) + Padding;
    [_sendButton sizeToFit];
    _sendButton.frame = CGRectMake(Padding, y, _sendButton.bounds.size.width, _sendButton.bounds.size.height);

    y = CGRectGetMaxY(_sendButton.frame) + Padding;
    [_inputTextField sizeToFit];
    _inputTextField.frame = CGRectMake(Padding, y, LabelWidth, _inputTextField.bounds.size.height);

    y = CGRectGetMaxY(_inputTextField.frame) + Padding;
    [_messagesTextView sizeToFit];
    _messagesTextView.frame = CGRectMake(Padding, y, LabelWidth, self.bounds.size.height - Padding - y);
}

@end