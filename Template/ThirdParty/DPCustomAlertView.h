//
//  RateView.h
//  NewDua
//
//  Created by CPD on 6/1/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    NoButtonClicked,
    OKButtonClicked,
    CancelButtonClicked,
    
}typedef ClickedCustomAlertButtonIndex;
typedef void (^CompletionBlock)(ClickedCustomAlertButtonIndex  myObj);

@protocol RateViewPopupDelegate <NSObject>

@optional
- (void)rateViewRateNowSelected;
- (void)rateViewNotNowSelected;

- (void)rateViewPresentAnimationCompleted;

- (void)rateViewCloseAnimationCompleted;

@required


@end
@interface DPCustomAlertView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtViewDescriptionHeight;
@property (nonatomic, assign) id<RateViewPopupDelegate> delegate;
-(void)closePopup;
- (id)initWithViewController:(UIViewController*)viewController;
- (id)initNoInternetAlertInViewController:(UIViewController*)viewController;
-(void)showCustomAlertWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitle Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;

-(void)showCustomAlertWithMessage:(NSString*)message Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;
-(void)showCustomAlertWithTitle:(NSString*)title Message:(NSString*)message yesButtonTitle:(NSString*)yesTitle noButtonTitle:(NSString*)noTitle Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;
-(void)showCustomAlertWithTitle:(NSString*)title Message:(NSString*)message Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;
-(void)showNoInternetAlertWithCompletion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;
-(void)showNoDataAlertWithCompletion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;

- (id)initNoDataAlertInViewController:(UIViewController*)viewController;

@end
