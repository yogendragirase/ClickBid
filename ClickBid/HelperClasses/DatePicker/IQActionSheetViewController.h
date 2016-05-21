//
//  IQActionSheetViewController.h
// https://github.com/hackiftekhar/IQActionSheetPickerView
// Copyright (c) 2013-14 Iftekhar Qurashi.
//

//FTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

@class IQActionSheetPickerView;

@interface IQActionSheetViewController : UIViewController

@property(nonatomic, strong, readonly) IQActionSheetPickerView *pickerView;

-(void)showPickerView:(IQActionSheetPickerView*)pickerView completion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

@end
