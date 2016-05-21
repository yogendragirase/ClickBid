//
//  CustomKeyboard.h
//  CustomKeyboard
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// Protocol for classes using this
@protocol CustomKeyboardDelegate
- (void)nextClicked:(NSUInteger)sender;
- (void)previousClicked:(NSUInteger)sender;
- (void)resignResponder:(NSUInteger)sender;
@end

@interface CustomKeyboard : NSObject

@property (nonatomic, strong) UIColor *navBarColor;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIViewController<CustomKeyboardDelegate>* delegate;
@property (nonatomic) NSUInteger currentSelectedTextboxIndex;

- (UIToolbar *)getToolbarWithPrevNextDone:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (UIToolbar *)getToolbarWithPrevNext:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (UIToolbar *)getToolbarWithDone;

@end
