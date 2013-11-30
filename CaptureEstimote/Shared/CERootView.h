//
// Created by Tomasz Netczuk on 30/11/13.
// Copyright (c) 2013 neciu corporation. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CERootView : UIView

@property(nonatomic, strong) UIButton *connectButton;
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UITextView *messagesTextView;

@property(nonatomic, readonly) UIButton *fightButton;
@property(nonatomic, strong) UIButton *respawnButton;
@end
