//
//  ForgotPasswordViewController.m
//  Login
//
//  Created by Anthony on 3/20/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "CommonFunction.h"
#import "URLConstants.h"
#import "NetworkLayer.h"

@interface ForgotPasswordViewController ()
{

float initialBottomOffset;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCOnstraints;

@property (weak, nonatomic) IBOutlet UILabel *lblForgotPasswordTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnRestPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnBackEn;
@property (weak, nonatomic) IBOutlet UIButton *btnBackAr;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txtUsername.placeholder = [CommonFunction getLocalisedString:@"Email"];
    [_btnRestPassword setTitle:[CommonFunction getLocalisedString:@"Reset Password"] forState:UIControlStateNormal];
    _lblForgotPasswordTitle.text=[CommonFunction getLocalisedString:@"Reset Password Title"];
    initialBottomOffset=self.bottomCOnstraints.constant;
    [_btnSignUp setTitle:[CommonFunction getLocalisedString:@"Register"] forState:UIControlStateNormal];
    _txtUsername.layer.borderColor=kBorderColorNormal.CGColor;
    _txtUsername.layer.borderWidth=1.0;

    
    [CommonFunction paddingtoTextField:_txtUsername leftWidth:5 rightW:5];
    
    
    UIColor *placeholderColor=[UIColor redColor];
    
    if(IS_ARABIC)
    {
         _btnBackAr.hidden=FALSE;
        
        
        /*
         [CommonFunction changingPlaceHolderFontOftextField:_txtUsername font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtUsername.font.pointSize] color:placeholderColor];
         [CommonFunction changingPlaceHolderFontOftextField:_txtpassword font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtpassword.font.pointSize] color:placeholderColor];
         [CommonFunction changingPlaceHolderFontOftextField:_txtMobileNumber font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtMobileNumber.font.pointSize] color:placeholderColor];
         [CommonFunction changingPlaceHolderFontOftextField:_txtFullname font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtFullname.font.pointSize] color:placeholderColor];
         */
        
    }
    else{
         _btnBackEn.hidden=FALSE;
        _btnBackEn.transform = CGAffineTransformMakeRotation(M_PI);
       
        
    }
    
    

    

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /// [self.navigationController setNavigationBarHidden:YES];
    
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    //    _txtUsername.text=@"mobileuser";
    //    _txtpassword.text=@"cpd123.com";
    //    [self registerWS];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)keyboardWillShow:(NSNotification *)n
{
    [self moveView:TRUE :n];
    
}
-(void)keyboardWillHide:(NSNotification *)n
{
    [self moveView:FALSE :n];
}
-(void)moveView:(BOOL)isMoveUP :(NSNotification*)n
{
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    float offset;
    if (isMoveUP)
    {
        
        float screenHt=self.view.frame.size.height;//[UIScreen mainScreen].bounds.size.height;
        
        if ((_txtUsername.superview.frame.origin.y+_txtUsername.superview.frame.size.height)<(screenHt-keyboardSize.height)) {
            return;
        }
        
        
offset=-(screenHt/2 - (screenHt - (keyboardSize.height + _txtUsername.superview.frame.size.height/2)));    
    }
    else
    {
        
        offset=initialBottomOffset;
        
    }
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //   self.connectingConstraints.active = !isMoveUP;
                         
                         self.bottomCOnstraints.constant = offset;
                        // self.connectingConstraints.constant =-1* offset;
                         
                         [self.view layoutIfNeeded];
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
    
}
- (IBAction)registerAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - SignIn Action


-(void)highlightErrorField:(UITextField*)textField
{
    [textField becomeFirstResponder];
    for (UIView *v in textField.superview.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            if (v==textField) {
                
                
                v.layer.borderColor=kBorderColorError.CGColor;
                
                
            }
            else
            {
                v.layer.borderColor=kBorderColorNormal.CGColor;
                
            }
            
        }
    }
}

#pragma mark - Validations
-(void)isValidatedCompletion:(void (^)(BOOL success,UITextField *textField, NSString *errormessage))completion
{
    
    if (![CommonFunction validateEmail:_txtUsername.text])
    {
        completion(FALSE,_txtUsername,[CommonFunction localizedString:@"Please enter a valid email"]);
        return ;
        
        
        
    }
    
    
    
    completion(TRUE,nil,@"");
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
        [textField resignFirstResponder];
    
    
    
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Workaround for the jumping text bug.
    // [textField resignFirstResponder];
    [textField layoutIfNeeded];
}
#pragma mark - Touch Delegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dissmissongKeyboard];
}

#pragma mark - DismissingKeyboard
-(void)dissmissongKeyboard
{
    [self.view endEditing:TRUE];
    
    
}

- (IBAction)resetpasswordAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return;
    
    [self isValidatedCompletion:^(BOOL success, UITextField *textField, NSString *errormessage) {
        if (success) {
            [self dissmissongKeyboard];
            [self highlightErrorField:nil];
            
            [self forgotPasswordWS];
            
        }
        else
        {
            //
            [CommonFunction showNotificationWithTitle:@"" message:errormessage bg:kNotificationColorError iconImage:kBannerAlertImage];

            [self highlightErrorField:textField];
        }
    }];
    
}
-(void)forgotPasswordWS
{
    
    
    [self dissmissongKeyboard];
    
    [CommonFunction showLoaderInViewController:self];
    
    NSDictionary* params = @{@"UserName" : _txtUsername.text};
    
    
    [[NetworkLayer getInstance] loginWithParams:params Completion:^(BOOL success, id responseObject, NSError *error) {
        
        [CommonFunction removeLoaderFromViewController:self];
        if (success)
        {
            
            
            
            [self backToSignInView:nil];
            
            
            
        }
        else
        {
            [CommonFunction showAlertWithTitle:@"" andMessage:error.localizedDescription inViewController:self];
        }
    }];
    
}
- (IBAction)backToSignInView:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
