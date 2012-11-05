/*
 * Credit where it is due: http://www.cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
 */

#import <Foundation/Foundation.h>

@interface TextFieldAutoScrollManager : NSObject

@property (nonatomic) CGFloat duration;
@property (strong, nonatomic) UITextField* textField;

+ (TextFieldAutoScrollManager* )ManagerWithTextField:(UITextField* )textField;

@end
