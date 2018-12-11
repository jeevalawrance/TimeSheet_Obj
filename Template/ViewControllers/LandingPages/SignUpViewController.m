//
//  SignUpViewController.m
//  Template
//
//  Created by Anthony on 12/18/16.
//  Copyright © 2016 CPD. All rights reserved.
//

#import "SignUpViewController.h"

#import "CommonFunction.h"
#import "URLConstants.h"
#import "NetworkLayer.h"

@interface SignUpViewController ()
{
    
    float initialBottomOffset;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCOnstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectingConstraints;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPasswordAr;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPasswordEn;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFullname;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnBackEn;
@property (weak, nonatomic) IBOutlet UIButton *btnBackAr;


@end


@implementation SignUpViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _txtUsername.placeholder = [CommonFunction getLocalisedString:@"Email"];
    _txtpassword.placeholder = [CommonFunction getLocalisedString:@"Password"];
    _txtConfirmPassword.placeholder = [CommonFunction getLocalisedString:@"Confirm Password"];

    _txtFullname.placeholder = [CommonFunction getLocalisedString:@"Full Name"];
    _txtMobileNumber.placeholder = [CommonFunction getLocalisedString:@"Mobile"];
    
    [_btnRegister setTitle:[CommonFunction getLocalisedString:@"Register"] forState:UIControlStateNormal];

    
    
    initialBottomOffset=self.bottomCOnstraints.constant;
    _txtUsername.layer.borderColor=kBorderColorNormal.CGColor;
    _txtUsername.layer.borderWidth=1.0;
    
    _txtpassword.layer.borderWidth=_txtUsername.layer.borderWidth;
    _txtpassword.layer.borderColor= _txtUsername.layer.borderColor;
    
    
    _txtMobileNumber.layer.borderWidth=_txtUsername.layer.borderWidth;
    _txtMobileNumber.layer.borderColor= _txtUsername.layer.borderColor;

    _txtFullname.layer.borderWidth=_txtUsername.layer.borderWidth;
    _txtFullname.layer.borderColor= _txtUsername.layer.borderColor;
    
    _txtConfirmPassword.layer.borderWidth=_txtUsername.layer.borderWidth;
    _txtConfirmPassword.layer.borderColor= _txtUsername.layer.borderColor;

    
    initialBottomOffset=self.bottomCOnstraints.constant;

    [CommonFunction paddingtoTextField:_txtFullname leftWidth:5 rightW:5];
    [CommonFunction paddingtoTextField:_txtMobileNumber leftWidth:5 rightW:5];
    [CommonFunction paddingtoTextField:_txtUsername leftWidth:5 rightW:5];
    [CommonFunction paddingtoTextField:_txtpassword leftWidth:5 rightW:5];

    [CommonFunction paddingtoTextField:_txtConfirmPassword leftWidth:5 rightW:5];

    UIColor *placeholderColor=[UIColor redColor];
    
    if(IS_ARABIC)
    {
        _btnViewPasswordAr.hidden=FALSE;
        _btnBackAr.hidden=FALSE;

     //   [CommonFunction paddingtoTextField:_txtpassword leftWidth:25 rightW:5];
        
        /*
        [CommonFunction changingPlaceHolderFontOftextField:_txtUsername font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtUsername.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtpassword font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtpassword.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtMobileNumber font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtMobileNumber.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtFullname font:[UIFont fontWithName:Font_Arabic_Helvetica_Medium size:_txtFullname.font.pointSize] color:placeholderColor];
        */
        
    }
    else{
        _btnViewPasswordEn.hidden=FALSE;
        _btnBackEn.hidden=FALSE;
        _btnBackEn.transform = CGAffineTransformMakeRotation(M_PI);

      //  [CommonFunction paddingtoTextField:_txtpassword leftWidth:5 rightW:5];
        
      /*
        [CommonFunction changingPlaceHolderFontOftextField:_txtUsername font:[UIFont fontWithName:Font_English_Gotham_Medium size:_txtUsername.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtpassword font:[UIFont fontWithName:Font_English_Gotham_Medium size:_txtpassword.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtMobileNumber font:[UIFont fontWithName:Font_English_Gotham_Medium size:_txtMobileNumber.font.pointSize] color:placeholderColor];
        [CommonFunction changingPlaceHolderFontOftextField:_txtFullname font:[UIFont fontWithName:Font_English_Gotham_Medium size:_txtFullname.font.pointSize] color:placeholderColor];
       */
    }
    
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                         
                         [self.view layoutIfNeeded];
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
    
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
- (IBAction)registerAction:(id)sender {
    [self isValidatedCompletion:^(BOOL success, UITextField *textField, NSString *errormessage) {
        if (success) {
            [self dissmissongKeyboard];
            [self highlightErrorField:nil];
            
            [self registerWS];
            
        }
        else
        {
            //
            [CommonFunction showNotificationWithTitle:@"" message:errormessage bg:kNotificationColorError iconImage:kBannerAlertImage];

            [self highlightErrorField:textField];
        }
    }];
    
}
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
-(void)registerWS
{
    
    
    [self dissmissongKeyboard];
    
    [CommonFunction showLoaderInViewController:self];
    
    NSDictionary* params = @{@"Password" : _txtpassword.text,
                             @"UserName" : _txtUsername.text};
    
    
    [[NetworkLayer getInstance] loginWithParams:params Completion:^(BOOL success, id responseObject, NSError *error) {
        
        [CommonFunction removeLoaderFromViewController:self];
        if (success)
        {
            
            UIViewController *nc=[self.storyboard instantiateViewControllerWithIdentifier:@"successVC"];
            [self.navigationController pushViewController:nc animated:TRUE];
            
            
            
        }
        else
        {
            [CommonFunction showAlertWithTitle:@"" andMessage:error.localizedDescription inViewController:self];
        }
    }];
    
}

#pragma mark - Validations
-(void)isValidatedCompletion:(void (^)(BOOL success,UITextField *textField, NSString *errormessage))completion
{
    if ([CommonFunction trimWhitespacesAndGivingCorrectString:_txtFullname.text].length==0)
    {
        completion(FALSE,_txtFullname,[CommonFunction localizedString:@"Fullname cannot be empty"]);
        return ;
        
        
        
    }
    else if (![CommonFunction validateEmail:_txtUsername.text])
    {
        completion(FALSE,_txtUsername,[CommonFunction localizedString:@"Please enter a valid email"]);
        return ;
        
        
        
    }
    else if ([CommonFunction trimWhitespacesAndGivingCorrectString:_txtMobileNumber.text].length==0)
    {
        completion(FALSE,_txtMobileNumber,[CommonFunction localizedString:@"Mobile Number cannot be empty"]);
        return ;
        
        
        
    }
    else if ([CommonFunction trimWhitespacesAndGivingCorrectString:_txtpassword.text].length==0)
    {
        completion(FALSE,_txtpassword,[CommonFunction localizedString:@"Password cannot be empty"]);
        return ;
        
        
    }
    else if (![_txtpassword.text isEqualToString:_txtConfirmPassword.text])
    {
        completion(FALSE,_txtpassword,[CommonFunction localizedString:@"PasswordMismatch"]);
        return ;
        
        
    }
    completion(TRUE,nil,@"");
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==_txtFullname)
    {
        [_txtUsername becomeFirstResponder];
        
        
    }
   else  if (textField==_txtUsername)
    {
        [_txtMobileNumber becomeFirstResponder];
        
        
    }
    else if (textField==_txtMobileNumber)
    {
        [_txtpassword becomeFirstResponder];
        
        
    }
    else if (textField==_txtpassword)
    {
        [_txtConfirmPassword becomeFirstResponder];
        
        
    }
    else
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
- (IBAction)viewPasswordAction:(id)sender {
    
    
    _txtpassword.secureTextEntry =!_txtpassword.secureTextEntry;
}
- (IBAction)backToSignInView:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}



@end
