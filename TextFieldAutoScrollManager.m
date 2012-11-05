/*
 * Credit where it is due: http://www.cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
 */

#import "TextFieldAutoScrollManager.h"

@interface TextFieldAutoScrollManager ()
@property NSUInteger animationDistance;
@end

@implementation TextFieldAutoScrollManager

- (void)calculateAnimationDistance:(NSDictionary* ) userInfo {
    //is grabbing the superview sufficient?
    CGRect textFieldRect = [_textField.window
                            convertRect:_textField.bounds
                            fromView:_textField];
    
    CGRect viewRect = [_textField.superview.window
                       convertRect:_textField.superview.bounds
                       fromView:_textField.superview];
    
    //tweaking definitely possible
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - 0.2 * viewRect.size.height;
    CGFloat denominator = (0.8 - 0.2) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    NSValue* keyboardFrameValue = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [_textField.superview.window
                            convertRect:[keyboardFrameValue CGRectValue]
                            fromView:_textField.superview];
    NSUInteger keyBoardHeight = keyboardFrame.size.height;
    
    self.animationDistance = (keyBoardHeight * heightFraction);
    
    //if the duration has not been set explicitly, we synch it to the keyboard
    if (!_duration) {
        _duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    }
}

- (void)down:(NSNotification* )notifier {
    CGRect viewFrame = _textField.superview.frame;
    viewFrame.origin.y += _animationDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:_duration];
    
    [_textField.superview setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (id)init {
    self = [super init];
    
    if (!self) {
        //error
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(up:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(down:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

+ (TextFieldAutoScrollManager* )ManagerWithTextField:(UITextField* )textField {
    TextFieldAutoScrollManager* textMan = [[TextFieldAutoScrollManager alloc] init];
    textMan.textField = textField;
    return textMan;
}

- (void)up:(NSNotification* )notifier {
    //pass the userInfo
    [self calculateAnimationDistance:notifier.userInfo];
    
    CGRect viewFrame = _textField.superview.frame;
    viewFrame.origin.y -= _animationDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:_duration];
    [_textField.superview setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

@end
