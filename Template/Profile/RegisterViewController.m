//
//  RegisterViewController.m
//  ScrollingPOC
//
//  Created by cpd on 12/5/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommonFunction.h"
#import "URLConstants.h"
#import <TOCropViewController/TOCropViewController.h>
#import "KPDropMenu.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface RegisterViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,TOCropViewControllerDelegate,KPDropMenuDelegate>
{
    NSString* selectedPath;

    UIImage* cropedImage;
    
    KPDropMenu *dropNew;
    
    int userType;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet KPDropMenu *drop;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *avoidScrollview;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Registration";
    
    userType = 0;
    
//    _drop.items = @[@"Contractor", @"Sub-Contract", @"Executive", @"Supervisor"];
//    _drop.itemsIDs = @[@"1", @"2", @"3", @"4"];
//    _drop.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
//    _drop.titleTextAlignment = NSTextAlignmentCenter;
//    _drop.delegate = self;
//    _drop.DirectionDown = YES;

    /* Adding Menu Programatically*/
    dropNew = [[KPDropMenu alloc] initWithFrame:CGRectMake(15, 260, [UIScreen mainScreen].bounds.size.width - 30, 40)];
    dropNew.delegate = self;
    dropNew.items = @[@"Contractor", @"Sub-Contract", @"Executive", @"Supervisor"];
    dropNew.itemsIDs = @[@"1", @"2", @"3", @"4"];
    dropNew.title = @"Select user type";
    dropNew.titleColor = [UIColor lightGrayColor];
    dropNew.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    dropNew.titleTextAlignment = NSTextAlignmentCenter;
    dropNew.DirectionDown = YES;
    [self.avoidScrollview addSubview:dropNew];

    
    self.btnRegister.layer.cornerRadius = 5;
    self.btnRegister.layer.masksToBounds = YES;
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.borderWidth = 3.0f;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.clipsToBounds = YES;
}
#pragma mark - KPDropMenu Delegate Methods

-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex{
//    if(dropMenu == _drop)
//    NSLog(@"%@ with TAG : %ld", dropMenu.items[atIntedex], (long)dropMenu.tag);
//    else
//    NSLog(@"%@", dropMenu.items[atIntedex]);
    
    userType = [dropMenu.itemsIDs[atIntedex] intValue];
    
    dropNew.titleColor = [UIColor blackColor];

}

-(void)didShow:(KPDropMenu *)dropMenu{
    NSLog(@"didShow");
}

-(void)didHide:(KPDropMenu *)dropMenu{
    NSLog(@"didHide");
}
#pragma mark-
#pragma mark-UIBUTTON ACTION
- (IBAction)registerAction:(id)sender {
    
    if ([self validateFields]) {
        // success validation
        
        NSString* idStr             = [CommonFunction randomStringGeneration];
        User *obj            = [[DataLayer getInstance] createNewUser];
        obj.userName    = self.txtFirstname.text;
        obj.userSurname = self.txtLastname.text;
        obj.userEmail         = self.txtEmail.text;
        obj.userID = idStr;
        [obj setValue:@(userType) forKey:@"userType"];
//        obj.userType     = @(userType);
        obj.userIsVerified = 0;
        
        [[DataLayer getInstance] saveChangesToCoreData];
        
        
        
        UIViewController *myVC = [self.storyboard instantiateViewControllerWithIdentifier:@"successVC"];
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
- (IBAction)loginAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)imagePickerAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Choose image from" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[CommonFunction localizedString:@"From Camera"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickerSelection:0];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[CommonFunction localizedString:@"From Album"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickerSelection:1];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)pickerSelection:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate         = self;
            picker.allowsEditing    = NO;
            picker.sourceType       = UIImagePickerControllerSourceTypeCamera;
            picker.cameraDevice     = UIImagePickerControllerCameraDeviceFront;
            
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate         = self;
            picker.allowsEditing    = NO;
            picker.sourceType       = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        default:
            break;
    }
}

#pragma mark-
#pragma mark-UIIMAGEPICKER DELEGATE

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage    = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentCropViewController:chosenImage];
    }];
    return;
    cropedImage             = chosenImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image       = chosenImage;
    
    NSData * data   = UIImagePNGRepresentation(_imageView.image);
    NSString *filepath;
    filepath        = [NSString stringWithFormat:@"tempImage.png"];
    
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    selectedPath    = [documentsDirectory stringByAppendingPathComponent:filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath]) {
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:selectedPath error:&error];
    }
    
    [data writeToFile:selectedPath atomically:TRUE];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // [self saveAction];
        //[self uploadProfilePic];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)presentCropViewController:(UIImage *)image
{
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
    cropedImage             = image;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image       = image;
    
    NSData * data   = UIImagePNGRepresentation(_imageView.image);
    NSString *filepath;
    filepath        = [NSString stringWithFormat:@"tempImage.png"];
    
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    selectedPath    = [documentsDirectory stringByAppendingPathComponent:filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath]) {
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:selectedPath error:&error];
    }
    
    [data writeToFile:selectedPath atomically:TRUE];
    [cropViewController  dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
}
-(BOOL)validateFields
{
    BOOL isSuccess = YES;
    
    NSString * message = @"";
    if ([_txtFirstname.text length] == 0) {
        
        isSuccess = NO;
        
        message = @"First name should not empty";
        
        [_txtFirstname becomeFirstResponder];
    }
    else if ([_txtLastname.text length] == 0) {
        
        isSuccess = NO;

        message = @"Last name should not empty";
        
        [_txtLastname becomeFirstResponder];

    }
    else if ([_txtEmail.text length] == 0) {
        
        isSuccess = NO;

        message = @"Email should not empty";

        [_txtEmail becomeFirstResponder];

    }
    else if (![CommonFunction validateEmail:_txtEmail.text])
    {
        isSuccess = NO;

        message = @"Email is not valid";

        [_txtEmail becomeFirstResponder];

    }
    else if ([_txtPassword.text length] == 0)
    {
        isSuccess = NO;

        message = @"Password should not empty";

        [_txtPassword becomeFirstResponder];

    }
    else if ([_txtConfirmPassword.text length] == 0) {
        
        isSuccess = NO;

        message = @"Confirm password should not empty";

        [_txtConfirmPassword becomeFirstResponder];

    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        isSuccess = NO;

        message = @"Password missmatch";

    }
    else if (userType == 0)
    {
        isSuccess = NO;
        
        message = @"Select user type";

    }
    if (!isSuccess) {
        
//        [CommonFunction showAlertWithTitle:@"" andMessage:message inViewController:self];

        [CommonFunction showNotificationWithTitle:@"" message:message bg:kNotificationColorError iconImage:kBannerAlertImage];

//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction         = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
//            
//            [alert dismissViewControllerAnimated:YES completion:nil];
//            
//        }];
//        [alert addAction:cancelAction];
//        
//        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return isSuccess;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
