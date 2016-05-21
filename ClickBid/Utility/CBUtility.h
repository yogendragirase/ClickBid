//
//  MyUtility.h
//  Pristine
//

//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface CBUtility : NSObject

+(NSString*)Trim:(NSString*)value;
+(BOOL)CB_ValidateEmailSting:(NSString *)checkString;
+(NSString *)CB_correctString:(NSString *) anyStr;
+(BOOL)CB_CheckStringForNullValue:(NSString *)Str;
+(NSString *)CB_StringToPhoneformat:(NSString *)strText;
+(NSString *)CB_StringToPhoneformatArray:(NSArray *)arrayText;


//^[2-9]\d{2}-\d{3}-\d{4}$

@end
