//
//  MyUtility.m
//  Pristine
//

//

#import "CBUtility.h"
//#import "pictureCell.h"


@implementation CBUtility

+(NSString*)Trim:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value;
}

+(BOOL)CB_ValidateEmailSting:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(NSString *)CB_correctString:(NSString *) anyStr {
    
    NSMutableString *str=[NSMutableString stringWithString:anyStr];
    int indx=4;
    while (indx<str.length) {
        [str insertString:@" " atIndex:indx];
        indx +=5;
    }
    anyStr=str;
    return anyStr;
}

+(BOOL)CB_CheckStringForNullValue:(NSString *)Str
{
    BOOL Result;
    if ([Str isKindOfClass:[NSString class]] || [Str isKindOfClass:[NSNull class]]) {
        if ([Str isKindOfClass:[NSNull class]]|| Str==nil || [Str isEqualToString:@"<null>"])
        {
            Result = NO;
        }
        else
        {
            Result = YES;
        }

    }
    else
    {
        Result = YES;
    }
         return Result;
}

+(NSString *)CB_StringToPhoneformat:(NSString *)strText
{
    NSMutableString *stringts = [NSMutableString stringWithString:strText];
//    [stringts insertString:@"(" atIndex:0];
//    [stringts insertString:@")" atIndex:4];
//    [stringts insertString:@"-" atIndex:5];
//    [stringts insertString:@"-" atIndex:9];
    [stringts insertString:@"-" atIndex:3];
    [stringts insertString:@"-" atIndex:7];
    //self.ts.text = stringts;
    return stringts;
    
}

+(NSString *)CB_StringToPhoneformatArray:(NSArray *)arrayText
{
    NSMutableArray *arrayPhone = [NSMutableArray new];
    for (int i=0; i<arrayText.count; i++) {
        NSString *strPhone = [CBUtility CB_StringToPhoneformat:[arrayText objectAtIndex:i]];
        [arrayPhone addObject:strPhone];
    }
    NSString *strPhone= [arrayPhone componentsJoinedByString:@", "];
    return strPhone;
}



@end
