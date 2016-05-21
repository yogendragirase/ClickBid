//
//  CHRTextMask.h
//


#import <Foundation/Foundation.h>

@protocol CHRTextMask <NSObject, NSCopying>

- (BOOL)shouldChangeText:(NSString *)text withReplacementString:(NSString *)string inRange:(NSRange)range;
- (NSString *)filteredStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition;
- (NSString *)formattedStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition;

@end
