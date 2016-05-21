//
//  CHRPhoneNumberMask.h
//

//

#import <Foundation/Foundation.h>
#import "CHRTextMask.h"

@interface CHRPhoneNumberMask : NSObject <CHRTextMask>

/**
 Specifies not editable phone number prefix.
 
 Phone number prefix will be separated by a whitespace from the actual phone number.
 */
@property (nonatomic, copy) NSString *prefix;

@end
