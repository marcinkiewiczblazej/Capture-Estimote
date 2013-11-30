#import <Foundation/Foundation.h>


@interface CEHackView : UIView <UITextFieldDelegate>
@property(nonatomic) int numberToType;
@property(nonatomic, strong, readonly) UITextField *textField;
@property(nonatomic, strong, readonly) UIButton *hackButton;
@end
