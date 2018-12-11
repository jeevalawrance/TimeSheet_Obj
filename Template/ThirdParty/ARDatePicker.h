//
//  ANDatePicker.h
//  ANDatePicker.h
//
 
#import <UIKit/UIKit.h>

extern NSString * const ANbackgroundColor;
extern NSString * const ANtextColor;
extern NSString * const ANtoolbarColor;
extern NSString * const ANbuttonTextColor;
extern NSString * const ANfont;
extern NSString * const ANvalueY;
extern NSString * const ANselectedIndex;
extern NSString * const ANtoolbarBackgroundImage;
extern NSString * const ANtextAlignment;
extern NSString * const ANshowsSelectionIndicator;
extern NSString * const ANButtonBGColor;
extern NSString * const ANCurrentDate;
extern NSString * const ANMaxtDate;
extern NSString * const ANMinDate;
extern NSString * const ANtoolbarTitle;

extern NSString * const ANReturnDateFormat;


@interface ARDatePicker: UIView

+(void)showPickerViewInView: (UIView *)view
                withOptions: (NSDictionary *)options
                 completion: (void(^)(NSString *selectedString))completion;

+(void)showPickerViewInView: (UIView *)view
                withOptions: (NSDictionary *)options
    objectToStringConverter: (NSString *(^)(id object))converter
       completion: (void(^)(id selectedObject))completion;

+(void)dismissWithCompletion: (void(^)(NSString *))completion;

@end
