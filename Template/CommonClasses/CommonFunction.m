//
//  CommonFunction.m
//  Xpress
//
//  Created by Antony  11/22/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import "CommonFunction.h"
#include <AVFoundation/AVFoundation.h>
#import "NSData+Base64.h"
#import "ToastView.h"
#import <objc/runtime.h>
//#import  "OpenUDID.h"
#import "MBProgressHUD.h"
 #import "Reachability.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalizationSystem.h"
#import "FTIndicator.h"
#import "UIView+TraverseRadius.h"
 #import <ContactsUI/ContactsUI.h>
#import "NetworkLayer.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "URLConstants.h"
//#import "DPCustomAlertView.h"
#import "DPCustomAlertView.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

static CommonFunction *sharedInstance = nil;

@interface CommonFunction(){
    NSMutableParagraphStyle *paragraphStyle;
    
    UIFont *messageFont;
    MBProgressHUD *hud;
 }

@end

@implementation CommonFunction


+(CommonFunction *) getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CommonFunction alloc] init];
    });
    return sharedInstance;
}

+ (void)displayTheToastWithMsg:(NSString *)msg duration:(float)durationValue
{
    
    ToastView *themePopup=[[ToastView alloc] init];
    [themePopup showToastWithMessage:msg withDuration:durationValue];
    
}
+(BOOL) validateEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL) validatePhoneNumber:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL phoneValidates = [phoneTest evaluateWithObject:phoneNumber];
    return phoneValidates;
}
+(NSString *) getDateForGrouping:(NSDate *)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterLongStyle;
    df.timeStyle = kCFDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    
    NSString *dateString=[df stringFromDate:date];
    
    return dateString;
}
-(NSString*)getRandomMessageID
{
    return [[NSString stringWithFormat:@"%@%@",[[NSUUID UUID] UUIDString],[CommonFunction randomStringGeneration]] lowercaseString];
}
+(NSString*)UUID
{
    return [[[NSUUID UUID] UUIDString] lowercaseString];
}

+(NSString*)uniqueString
{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}
+(NSString*)randomStringGeneration
{
    NSString *randomString=@"";
    NSString *alphabetOrInt=@"";
    for (int i=0; i<5; i++) {
        
        if((arc4random()%20)%2==0)
        {
            alphabetOrInt=[NSString stringWithFormat:@"%d",arc4random()%10];
        }
        else
        {
            alphabetOrInt=[NSString stringWithFormat:@"%c",((arc4random()%26)+97)];
        }
        
        randomString=[randomString stringByAppendingString:alphabetOrInt];
    }
    
    return randomString;
}

/*
 Functions related to encoding and decoding of nsstring
 */
+ (NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}

+(NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}

+ (void )setUserdefaultsValueafterEncoding:(NSString *)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:[CommonFunction base64Encode:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getValueForkeyAfterDecoding:(NSString *)key
{
    return [CommonFunction base64Decode:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
}

/*
 returning the localized string
 */
+(NSString*) localizedString:(NSString *)key
{
    return [self getLocalisedString:key];
}

+(NSString*)getLocalisedString:(NSString*)key
{
    // if(IS_ARABIC)
    return AMLocalizedString(key, @"");
    
    
    return key;
    
    
    
}

/*
 Trim White Spaces
 
 */

#pragma mark Trimming WhiteSpaces

+ (NSString *) trimWhitespacesAndGivingCorrectString:(NSString *)string
{
    NSString *trimmedString             = [string stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

+(void)showAlert:(NSString*)msg{
   
 
    DPCustomAlertView *alt= [[DPCustomAlertView alloc] init];
    [alt showCustomAlertWithMessage:msg Completion:^(ClickedCustomAlertButtonIndex buttonClikd) {

    }];
    return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             //BUTTON OK CLICK EVENT
                         }];
    [alert addAction:ok];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainController = [keyWindow rootViewController];
    [mainController presentViewController:alert animated:YES completion:nil];

    
}
+(void)showAlertWithTitle:(NSString *)titleStr andMessage:(NSString *)msgStr inViewController:(UIViewController *)vc{
     DPCustomAlertView *alt= [[DPCustomAlertView alloc] init];
    [alt showCustomAlertWithTitle:titleStr Message:msgStr Completion:^(ClickedCustomAlertButtonIndex buttonClikd) {
        

    }];
    return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [titleAttrStr addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:14.0]
                         range:NSMakeRange(0, titleStr.length)];
    [alertController setValue:titleAttrStr forKey:@"attributedTitle"];
    
    NSMutableAttributedString *msgAttrStr = [[NSMutableAttributedString alloc] initWithString:msgStr];
    [msgAttrStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange(0, msgAttrStr.length)];
    [alertController setValue:msgAttrStr forKey:@"attributedMessage"];
    
    [alertController.view traverseRadius:2];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:[CommonFunction localizedString:@"OK"] style:UIAlertActionStyleDefault handler:nil];
    /*NSString* okStr = @"YES";
     NSMutableAttributedString *okAttrStr = [[NSMutableAttributedString alloc] initWithString:okStr];
     [okAttrStr addAttribute:NSFontAttributeName
     value:[UIFont boldSystemFontOfSize:10.0]
     range:NSMakeRange(0, okStr.length)];
     [ok setValue:okAttrStr forKey:@"attributedTitle"];*/
    //[ok setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [alertController addAction:ok];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    /*
     UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Dont care what goes here, since we're about to change below" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
     
     
     
     
     UIAlertAction *button = [UIAlertAction actionWithTitle:@"Label text"
     style:UIAlertActionStyleDefault
     handler:^(UIAlertAction *action){
     //add code to make something happen once tapped
     }];
     UIImage *accessoryImage = [UIImage imageNamed:@"someImage"];
     [button setValue:accessoryImage forKey:@"image"];*/
}

+(void)showErrorNotificationWithIcon:(UIImage *)iconImage Title:(NSString *)titleStr Message:(NSString *)msgStr andBackgroundImageOrColor:(id)backgroundProperty{
    [FTIndicator showNotificationWithImage:iconImage
                                     title:titleStr
                                   message:msgStr backgGroundProperty:backgroundProperty];
}

+(void)showNotificationWithTitle:(NSString *)titleStr message:(NSString *)msgStr bg:(id)bg iconImage:(UIImage*)icon{
    [self showErrorNotificationWithIcon:icon Title:titleStr Message:msgStr andBackgroundImageOrColor:bg];
    
}

/*
 Show toast
 */


#pragma mark Function which returns  view that is first responder

+(UIView *)findViewThatIsFirstResponder:(id)views
{
    
    if ([views isFirstResponder]) {
        return views;
    }
    
    for (UIView *subView in [views subviews]) {
        UIView *firstResponder = [self findViewThatIsFirstResponder:subView];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}
+(NSDate*)curentBraziltimeTime
{
    NSDate *date=[NSDate date];
    NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
    [gmtDf setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter* estDf = [[NSDateFormatter alloc]init];
    [estDf setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-03:00"]];
    [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *estDate = [gmtDf dateFromString:[estDf stringFromDate:date]]; // you can also use str
    NSLog(@"change%@",estDate);
    return estDate;
}

+(NSDate*)convertLocalToBrazil:(NSDate*)date
{   NSLog(@"change--->%@",date);
    NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
    [gmtDf setTimeZone:[NSTimeZone localTimeZone]];
    [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter* estDf = [[NSDateFormatter alloc]init];
    [estDf setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-03:00"]];
    [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *estDate = [gmtDf dateFromString:[estDf stringFromDate:date]]; // you can also use str
    NSLog(@"change%@",estDate);
    return estDate;
}

+(NSDate*)convertBrazilToLocal:(NSDate*)date
{
    NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
    [gmtDf setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter* estDf = [[NSDateFormatter alloc]init];
    [estDf setTimeZone:[NSTimeZone localTimeZone]];
    [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *estDate = [gmtDf dateFromString:[estDf stringFromDate:date]]; // you can also use str
    
    return estDate;
    
}


#pragma mark -
#pragma mark activity indicator.

+(void)createIndicator:(UIView *)indicatorView message:(NSString *)msg
{
    UIView *indView                        = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, indicatorView.bounds.size.width / 2, indicatorView.bounds.size.width / 2)];
    
    [indicatorView addSubview:indView];
    indView.center                              =CGPointMake(indicatorView.bounds.size.width / 2, indicatorView.bounds.size.height /2);
    
    indView.tag                                 = 100;
    [indView setHidden:YES];
    
    
    
    
    UILabel *lbl                            = [[UILabel alloc] initWithFrame:CGRectMake(0, indView.frame.size.height*3/4, indView.frame.size.width, 30)];
    [indView addSubview:lbl];
    [lbl                                      setBackgroundColor:[UIColor clearColor]];
    lbl.textAlignment                       = NSTextAlignmentCenter;

    [lbl                                      setTextColor:[UIColor whiteColor]];
    [lbl                                      setNumberOfLines:2];
    lbl.tag                                  = 102;
    lbl.text                                 = [self localizedString:msg];
    [lbl sizeToFit];
    
    float indWidth=lbl.frame.size.width+2.0f*15.0f;
    
    indView.frame=CGRectMake((indicatorView.frame.size.width-indWidth)/2.0f,((indicatorView.frame.size.height-indWidth)/2.0f)-44.0f, indWidth,indWidth);
    
    lbl.frame=CGRectMake((indWidth-lbl.frame.size.width)/2.0f, indView.frame.size.height*3/4, lbl.frame.size.width, lbl.frame.size.height);
    
    
    UIActivityIndicatorView *spin           = [[UIActivityIndicatorView alloc]
                                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    spin.tag = 101;
    
    spin.center = CGPointMake(indView.bounds.size.width / 2.0f, indView.bounds.size.height /2.0f);
    [indView addSubview:spin];
    indView.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    indView.layer.cornerRadius=10.0f;
    
    
    
}



+(void)showIndicator:(UIView *)indicatorView message:(NSString *)msg
{
    
    if(!((UIView*)[indicatorView viewWithTag:100]))
        [self createIndicator:indicatorView message:msg];
    
    [((UIView*)[indicatorView viewWithTag:100]) setHidden:NO];
    [((UIActivityIndicatorView*)[indicatorView viewWithTag:101]) setHidden:NO];
    
    ((UILabel*)[indicatorView viewWithTag:102]).text  = [self localizedString:msg];
    
    [((UIActivityIndicatorView*)[indicatorView viewWithTag:101]) startAnimating];
    
}

+(void)stopIndicator:(UIView *)indicatorView
{
    //self.isNetworkAvailable                  =YES;
    UIView *indView                        = (UIView*)[indicatorView viewWithTag:100];
    [indView                                       setHidden:YES];
    [((UIActivityIndicatorView*)[indicatorView viewWithTag:101]) stopAnimating];
}

/*
 
 The code below specifies an image where
 7 pixels on the top,
 8 pixels on the left,
 11 pixels on the bottom and
 10 pixels on the right be preserved when stretching/resizing the button:
 
 */
+(void)paddingtoTextField:(UITextField*)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    if (textField.textAlignment==NSTextAlignmentLeft) {
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    else
    {
        textField.rightView = paddingView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
}
+(void)paddingtoTextField:(UITextField*)textField leftWidth:(float)leftWidth rightW:(float)rightWidth
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, 20)];
    
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    CGRect frame=paddingView.frame;
    frame.size.width = rightWidth;
    
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    
}
+(UIImage *)loadThumbNailFromUrl:(NSURL *)urlVideo

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform=TRUE;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    
    return [[UIImage alloc] initWithCGImage:imgRef];
    
    
}
+(UIColor*)commonBGColor
{
    return [UIColor colorWithRed:(17.0f/255.0f) green:(66.0f/255.0f) blue:(7.0f/255.0f) alpha:1.0];
}
+(UIImage*)patchImageForGroundBG
{
    return [[UIImage imageNamed:@"textfieldbox"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
}


+(UIBarButtonItem *)navigationButtonSpacer
{
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=0;
    
//    if ([self isIOS7]) {
//        space.width = -16;
//    }
//    else{
//        space.width = -5;
//    }
    space.tintColor=[UIColor blueColor];
    
    return space;
}



#pragma mark -
#pragma mark convert date time formate

#pragma mark -
#pragma mark convert date time formate

+(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format{
    if(!date){
        return @"";
    }
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateformater       = [[NSDateFormatter alloc] init];
    // [dateformater                         setLocale:[NSLocale currentLocale]];
    // [dateformater                         setDateStyle:NSDateFormatterMediumStyle];//set current locale
    // [dateformater                         setTimeStyle:NSDateFormatterShortStyle];
    [dateformater setDateFormat:format];
    [dateformater  setTimeZone:destinationTimeZone];
    return  [dateformater stringFromDate:date];
}

+(NSDate *)getDateFromString:(NSString *) dateString Format:(NSString *)format{
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter  setTimeZone:destinationTimeZone];
    
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];
    
    return  date;
}

+(NSString *) getDateTimeStringFromDate:(NSDate *) date Format:(NSString *)format{
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateformater       = [[NSDateFormatter alloc] init];
    [dateformater                         setLocale:[NSLocale currentLocale]];
    // [dateformater                         setDateStyle:NSDateFormatterMediumStyle];//set current locale
    // [dateformater                         setTimeStyle:NSDateFormatterShortStyle];
    [dateformater setDateFormat:format];
    [dateformater  setTimeZone:destinationTimeZone];
    return  [dateformater stringFromDate:date];
}


/**
 
 Setting shadow around textbox
 */

+(void) setShadowForTextField:(UITextField *)txtField
{
    txtField.background = [[UIImage imageNamed:@"field"]resizableImageWithCapInsets:UIEdgeInsetsMake(1, 5, 1, 10)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtField.leftView = paddingView;
    txtField.leftViewMode = UITextFieldViewModeAlways;
}


// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)TestcolorFromHexString:(NSString *)hexString {
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+(NSArray*)matchesOftheDay:(NSDate*)date
{
    /*  AppDelegate *appdel=  [[UIApplication sharedApplication]delegate];
     NSEntityDescription *entity = [NSEntityDescription
     entityForName:@"XPMatches" inManagedObjectContext:appdel.managedObjectContext];
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     [fetchRequest setEntity:entity];
     NSSortDescriptor *sort = [[NSSortDescriptor alloc]
     initWithKey:@"date" ascending:TRUE];
     [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
     
     
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", [CommonFunction beginningOfDay:date], [CommonFunction endOfDay:date]];
     [fetchRequest setPredicate:predicate];
     
     NSError *error;
     NSArray *contactDetailArray=[appdel.managedObjectContext executeFetchRequest:fetchRequest error:&error];
     */
    return NULL;
}


+(NSDate *)beginningOfDay:(NSDate *)date

{
    
    //gather current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    //set date components
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    //return date relative from date
    return [calendar dateFromComponents:dateComponents];
    
    
    
    
    
}



+(NSDate *)endOfDay:(NSDate *)date

{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    //set date components
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    
    //return date relative from date
    return [calendar dateFromComponents:dateComponents];
}


+(NSString*)predictionEndtime:(NSDate*)dateObj
{
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateformater       = [[NSDateFormatter alloc] init];
    [dateformater                         setLocale:[NSLocale currentLocale]];
    [dateformater                         setDateStyle:NSDateFormatterMediumStyle];//set current locale
    [dateformater                         setTimeStyle:NSDateFormatterShortStyle];
    [dateformater  setTimeZone:destinationTimeZone];
    NSString *strDate                   = [dateformater stringFromDate:dateObj];
    return strDate;
    
}

+(BOOL)isActiveInternet
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable)
    {
        
        
        return FALSE;
        
    }
    return TRUE;
}
+(void)showinActiveINternetAlert
{
  
}
+(void)removeLoaderFromViewController:(UIViewController*)vc
{
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
}

+(void)showLoaderInViewController:(UIViewController*)vc
{
    
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    
}
+(void)removeMultimedia:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    if ([NSData dataWithContentsOfFile:filePath]==NULL||[fileName isEqualToString:@""] || fileName==NULL) {
        return;
    }
    
    
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"%@ deleted ",fileName);
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}
+(BOOL)isValidPhoneNumber:(NSString*)phoneNumber{
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
    NSArray *matches = [detector matchesInString:phoneNumber options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
    
    /*
     NSString *phoneRegex = @"^\\+(?:[0-9] ?){6,14}[0-9]$";
     NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
     BOOL matches = [test evaluateWithObject:phoneNumber];
     return matches;
     */
}
+(void)borderForView:(id)v
{
    UIView *view=v;
    view.layer.cornerRadius=5;
    view.layer.borderWidth=1.0f;
    view.layer.borderColor=[UIColor colorWithRed:(181.0f/255.0f) green:(181.0f/255.0f) blue:(181.0f/255.0f) alpha:1.0f].CGColor;
}
+(void)updatingTokentoServer
{
    
    [[NetworkLayer getInstance] RegisteringPNToken];
    
    
    
    
}
+(UIImage*)thumbnailfromPickerInfo:(NSDictionary*)dict
{
    UIImage *thumb;
    if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto || [[dict objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
        if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
            
            thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
            
            
            
        }
        else {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
        
        
    }
    else
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo ){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
                
                
                
            }
        }
        else if([[dict objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
        {
            // FromCamera
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:dict[UIImagePickerControllerMediaURL] options:nil];
            AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            NSError *error = NULL;
            CMTime time = CMTimeMake(1, 65);
            CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
            NSLog(@"error==%@, Refimage==%@", error, refImg);
            
            thumb= [[UIImage alloc] initWithCGImage:refImg];
            
        }
        
        
        
        
    }
    return thumb;
}
+(UIImage*)thumbnailFromVideoPath:(NSString*)url
{
    //NSURL *ass=[NSURL URLWithString:url];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSURL URLWithString:url] absoluteURL] options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    return [[UIImage alloc] initWithCGImage:refImg];
    
}
+(UIImage*)videoThumbFromURL:(NSString*)url
{
    //NSURL *ass=[NSURL URLWithString:url];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    return [[UIImage alloc] initWithCGImage:refImg];
    
}
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject = NSClassFromString([key capitalizedString]);
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject:[obj valueForKey:key]];
            [dict setObject:subObj forKey:key];
        }
        else
        {
            id value = [obj valueForKey:key];
            if(value) [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

//+(NSString*)stringFromAnyObject:(id)theDict
//{
//    NSData *plist = [NSPropertyListSerialization
//                     dataWithPropertyList:theDict
//                     format:NSPropertyListXMLFormat_v1_0
//                     options:kNilOptions
//                     error:NULL];
//
//    return [[NSString alloc] initWithData:plist encoding:NSUTF8StringEncoding];
//}

+(NSString*)stringFromDictionary:(NSDictionary*)theDict
{
    NSData *plist = [NSPropertyListSerialization
                     dataWithPropertyList:theDict
                     format:NSPropertyListXMLFormat_v1_0
                     options:kNilOptions
                     error:NULL];
    
    return [[NSString alloc] initWithData:plist encoding:NSUTF8StringEncoding];
}
+(NSDictionary*)dictionaryFromString:(NSString*)str
{
    return [NSPropertyListSerialization
            propertyListWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
            options:kNilOptions
            format:NULL
            error:NULL];
}
+(NSMutableDictionary *) dictionaryByReplacingNullsWithStrings:(id)dict {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dict];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in dict) {
        const id object = [dict objectForKey: key];
        if (object == nul || [object isKindOfClass:[NSNull class]]) {
            [replaced setObject: blank forKey: key];
        }
        
        else if ([object isKindOfClass: [NSArray class]]) {
            
            [replaced setObject: [self arrayByReplacingNullsWithStrings:object] forKey: key];
            
            
            /* NSMutableArray *newArr=[NSMutableArray arrayWithArray:object];
             int cnt=0;
             for (id vl in newArr) {
             if([vl isKindOfClass:[NSString class]])
             {
             if (vl==nul|| [vl isEqualToString:@"<null>"]) {
             [newArr replaceObjectAtIndex:cnt++ withObject:blank];
             
             }
             
             }
             else if ([vl isKindOfClass: [NSDictionary class]]) {
             [replaced setObject: [self dictionaryByReplacingNullsWithStrings:vl] forKey: key];
             [newArr replaceObjectAtIndex:cnt++ withObject:replaced];
             }
             
             ;
             }*/
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self dictionaryByReplacingNullsWithStrings:object] forKey: key];
        }
    }
    return replaced;
}
+(NSMutableDictionary *)a1dictionaryByReplacingNullsWithStrings:(NSMutableDictionary*)dictionary {
    for (NSString *key in [dictionary allKeys]) {
        id nullString = [dictionary objectForKey:key];
        if ([nullString isKindOfClass:[NSDictionary class]]) {
            [self dictionaryByReplacingNullsWithStrings:(NSMutableDictionary*)nullString];
        } else {
            if ((NSString*)nullString == (id)[NSNull null])
                [dictionary setValue:@"" forKey:key];
        }
    }
    return dictionary;
}
+(void)changinhTheFonts:(UIView*)view
{
    UITextField *tv;UILabel *l;
    UIButton *bt;
    for (UIView *v in view.subviews)
    {
        if ([v isKindOfClass:[UILabel class]]) {
            l=(UILabel*)v;
            if (l.tag==-1111) {
                if(l.font.pointSize==0)
                {
                  //  l.font=[UIFont fontWithName:Font_Booq_Medium size:14.0];//[UIFont fontWithName:AppfontMedium size:14];
                }
                else
                {
                  //  l.font=[UIFont fontWithName:Font_Booq_Medium size:l.font.pointSize];
                    
                }
                
            }
            else
            {
                if(l.font.pointSize==0)
                {
                 //   l.font=[UIFont fontWithName:Font_Booq_Light size:14];
                }
                else
                {
                 //   l.font=[UIFont fontWithName:Font_Booq_Light size:l.font.pointSize];
                    
                }
                
            }
            
        }
        else if([v isKindOfClass:[UITextField class]])
        {
            tv=(UITextField*)v;
            
            if(tv.font.pointSize==0)
            {
             //   tv.font=[UIFont fontWithName:Font_Booq_Light size:14];;
            }
            else
            {
             //   tv.font=[UIFont fontWithName:Font_Booq_Light size:tv.font.pointSize];
                
            }
            
            
        }
        
        else if([v isKindOfClass:[UIButton class]])
        {
            bt=(UIButton*)v;
            
            if(bt.titleLabel.font.pointSize==0)
            {
           //     bt.titleLabel.font=[UIFont fontWithName:Font_Booq_Light size:14];;
            }
            else
            {
            //    bt.titleLabel.font=[UIFont fontWithName:Font_Booq_Light size:tv.font.pointSize];
                
            }
            
            
        }
        [self changinhTheFonts:v];
    }
}
+(void)changingPlaceHolderColor:(UIView*)view toColor:(UIColor*)color
{
    UITextField *tv;
    
    for (UIView *v in view.subviews)
    {
        
        if([v isKindOfClass:[UITextField class]])
        {
            tv=(UITextField*)v;
            [tv setValue:color forKeyPath:@"_placeholderLabel.textColor"];
            
            
        }
        
        
        [self changingPlaceHolderColor:v toColor:color];
    }
}


+(NSAttributedString*)attributedStringFromAlignMent:(NSTextAlignment)allignMent font:(UIFont*)font andText:(NSString*)text
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment                =allignMent;
    paragraphStyle.lineSpacing=5;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString : text
                                                                    attributes : @{
                                                                                   NSParagraphStyleAttributeName : paragraphStyle,
                                                                                   
                                                                                   NSFontAttributeName : font }];
    
    return labelText;
    
    
    
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          paragraphStyle, NSParagraphStyleAttributeName,
                                          [NSNumber numberWithInt:0], NSBaselineOffsetAttributeName,
                                          nil];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    return string;
    
}
+(CGFloat)heightframeOfLableFromWidth:(float)width fromText:(NSAttributedString*)attributedtext minHeight:(float)minheight
{
    
    
    
    CGSize constrainedSize = CGSizeMake(width, MAXFLOAT);;//CGSizeMake(_tblDetails.frame.size.width-2*10-2*5, 9999);
    
    
    CGRect requiredHeight = [attributedtext boundingRectWithSize:constrainedSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    if (requiredHeight.size.height > minheight)
    {
        requiredHeight = CGRectMake(0,0,width, requiredHeight.size.height);
    }
    else{
        requiredHeight = CGRectMake(0,0,width, minheight);
        
    }
    return requiredHeight.size.height;
}

+(CGRect)frameOfTopbarfromText:(NSString*)text andFont:(UIFont*)font height:(float)height
{
    
    
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, height);;//CGSizeMake(_tblDetails.frame.size.width-2*10-2*5, 9999);
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          paragrahStyle,NSParagraphStyleAttributeName,
                                          nil];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    return requiredHeight;
}


+(int)fontType:(UIFont*)font{
    
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    return 0;
    
}


+(NSError*)errorFromErrormessage:(NSString*)errorMessage
{
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    
    [userInfo setValue:errorMessage forKey:NSLocalizedDescriptionKey];
    
    NSError *error1=[[NSError alloc] initWithDomain:@"" code:0 userInfo:userInfo];
    return error1;
}

+(NSMutableArray *)arrayByReplacingNullsWithStrings:(id)sourceArray
{
    
    NSMutableArray *replaced = [[NSMutableArray alloc] initWithArray:sourceArray];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    int cnt=0;;
    for (id  key in sourceArray) {
        
        if ([key isKindOfClass:[NSDictionary class]])
        {
            [replaced replaceObjectAtIndex:[replaced indexOfObject:key] withObject:[self dictionaryByReplacingNullsWithStrings:key]];
            
            
        }
        
        else if (key == nul || [key isKindOfClass:[NSNull class]]) {
            
            [replaced replaceObjectAtIndex:cnt withObject:blank];
        }
        
        else if ([key isKindOfClass: [NSArray class]]) {
            
            [replaced replaceObjectAtIndex:[replaced indexOfObject:key] withObject:[self arrayByReplacingNullsWithStrings:key]];
        }
        
        cnt++;
    }
    
    
    
    return replaced;
}

#pragma mark - UIImage Save and retrieve to documnetDirectory
+(void)saveImageToDocumentDirectory:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension {
  NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //  NSString * documentsDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cpd.hhpochat"] filePathURL].absoluteString;
  //  NSString * documentsDirectory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupContainer].path;
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}
+(UIImage *)getImageFromDocumentDirectoryWithFileName:(NSString *)fileName ofType:(NSString *)extension {
    // NSString * documentsDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cpd.hhpochat"] filePathURL].absoluteString;
    
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  //  NSString * documentsDirectory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupContainer].path;
    
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", documentsDirectory, fileName, [extension lowercaseString]]];
    
    return result;
}
+(BOOL)removeImageFromDocumentDirectoryWithFileName:(NSString *)fileName ofType:(NSString *)extension {
    // NSString * documentsDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cpd.hhpochat"] filePathURL].absoluteString;
    
 NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   // NSString * documentsDirectory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupContainer].path;
    NSString* foofile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName, [extension lowercaseString]]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    if (fileExists) {
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:foofile error:&error];
    }
    
    return YES;
}
#pragma -mark KEYCHAIN Related

+(void)setObjectInKeychain:(id)object key:(NSString*)key
{
 //   [[SingletonClass getInstance].keychain setObject:object forKey:key];
}

+(id)getObjectFromKeyChain:(NSString*)key
{
    return nil;
    
}
+(void)deleteteObjectFromKeychain:(NSString*)key
{

    
}
+(void)changingPlaceHolderFontOftextField:(UITextField*)textField font:(UIFont*)font color:(UIColor*)color
{
    
    textField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:textField.placeholder
                                    attributes:@{
                                                 //NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : font
                                                 }
     ];
}

+(void)setLoginRootViewControllerWithAnimation
{
   AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardIdLogin bundle: nil];
    
    UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"signInRoot"];
    
    UIView *snapShotView;
    snapShotView = [appdel.window snapshotViewAfterScreenUpdates: YES];
    [rootViewController.view addSubview: snapShotView];
    
    
    [appdel.window setRootViewController: rootViewController];
    {
        [UIView animateWithDuration: 0.3 animations:^{
            
            snapShotView.layer.opacity = 0;
            snapShotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
            
        } completion:^(BOOL finished) {
            
            [snapShotView removeFromSuperview];
            
        }];
    }
    
}
+(NSString *) getLastSeenDateString:(NSDate *)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterLongStyle;
    df.timeStyle = kCFDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    
    NSString *dateString=[df stringFromDate:date];
    
    return dateString;
}
+(NSString*)removeAllCharactersOtherThanDigitFromString:(NSString*)string
{
    NSString *newString = [[string componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    NSRange range = [newString rangeOfString:@"^0*" options:NSRegularExpressionSearch];
    newString= [newString stringByReplacingCharactersInRange:range withString:@""];
    
    return newString;
}



+(void)creatingFolderWithName:(NSString*)foldername
{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
   // NSString * documentsDirectory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupContainer].path;
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:foldername ];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
}
+(NSString*)formattedPhoneNumberFromNumber:(NSString*)number
{
    
    // import NBPhoneNumberUtil
    return @"";
    
}

+(UIImage*)getReducedImageFrom :(UIImage *)image toKBSize :(int)kb_size
{
    NSData *data = UIImagePNGRepresentation(image);
    while (data.length / 1000 >= kb_size) {
        UIGraphicsBeginImageContext( CGSizeMake(image.size.width/2, image.size.height/2));
        [image drawInRect:CGRectMake(0,0,image.size.width/2,image.size.height/2)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = newImage;
        data = UIImagePNGRepresentation(image);
    }
    return image;
}
-(void)playAlertSoundForMessages:(NSString*)soundname andExtension:(NSString*)extension
{

    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundname ofType:extension];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    dispatch_async( dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(soundID);
    });
    
}

-(void)playAlertSound:(NSString*)soundname andExtension:(NSString*)extension
{
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundname ofType:extension];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    dispatch_async( dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(soundID);
    });
    
}


    
- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)resize
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(resize.width)
                                                           };
    
    CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    UIImage *scaled = [UIImage imageWithCGImage:scaledImageRef];
    CGImageRelease(scaledImageRef);
    return scaled;
}


+(NSString*)stringwithNullCheck:(id)theString
{
    if (theString == [NSNull null]) {
        return @"";
    }
    if ([theString isKindOfClass:NULL]) {
        return @"";
    }
    if (theString == nil) {
        return @"";
    }
    if ([theString isKindOfClass:[NSString class]] && [theString length] == 0) {
        return @"";
    }
    return theString;
}


- (UIImage *)thumbnailFromVideoAtURL:(AVURLAsset *)asset {
    UIImage *theImage = nil;
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef];
    //    theImage = [CommonFunction getReducedImageFrom:theImage toKBSize:1];
    
    CGImageRelease(imgRef);
    
    return theImage;
}
+ (UIImage *)imageFromColor:(UIColor *)color {
   // if (![[SingletonClass getInstance].colorCodeDictionaryForUsers objectForKey:color])
 //   {
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
      //  [[SingletonClass getInstance].colorCodeDictionaryForUsers setObject:image forKey:color];
  //  }
    
    return image;//[[SingletonClass getInstance].colorCodeDictionaryForUsers objectForKey:color];
}


+ (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}



-(void)showShadowInNavigationController:(UINavigationController*)nav
{
    [nav.navigationBar setShadowImage:[CommonFunction imageFromColor:UIColorFromRGB(0xd9d9d9)]] ;
}
-(void)hideShadowInNavigationController:(UINavigationController*)nav
{
    [nav.navigationBar setShadowImage:[[UIImage alloc] init]] ;
    
    
}


+ (NSString *)getAppversion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];;
}
+(UIImage*)getScaledImageFromImage:(UIImage*)image imageID:(NSString*)imageId minSize:(float)minWidth
{
    UIImage *newImage;
    
    // if (![[SingletonClass getInstance].colorCodeDictionaryForUsers objectForKey:[NSString stringWithFormat:@"scaledImage%@_%f",imageId,minWidth]])
    {
        NSLog(@"image size before %@",NSStringFromCGSize(image.size));
        
        float scaleFactor = 1.;
        if (image.size.width>minWidth) {
            if (image.size.height>minWidth) {
                scaleFactor =image.size.height/minWidth;
            }
        }
        else
        {
            if (image.size.width>minWidth) {
                scaleFactor = image.size.width/minWidth;
            }
            
        }
        
        newImage =  [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:image.imageOrientation];
        image=nil;
        


        
        
    }
    return newImage;

}
void CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
}
- (void)CGImageWriteToFileimage:(CGImageRef)image imagePath:(NSString *)imagePath {
    CGImageWriteToFile(image, [imagePath stringByAppendingString:kThumbNailExtension]);
    
}
- (void)generatingThumbAtPath:(NSString *)imagePath {
    if ([NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[imagePath stringByAppendingString:kThumbNailExtension]]]) {
        return;
    }
    //    dispatch_async( dispatch_get_main_queue(), ^{
    // Create the image source
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:imagePath], NULL);
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(480)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    NSLog(@"thumbnail---->%@\n%@",thumbnail,imagePath);
    
    if(thumbnail)
    {
        CFRelease(src);
        // Write the thumbnail at path
      
        CGImageWriteToFile(thumbnail, [imagePath stringByAppendingString:kThumbNailExtension]);
    }
    
    //    });
}
- (void)thumbnailGenerationWithCompletion:(NSString *)imagePath Completion:(void(^)(BOOL success))completion{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        [self generatingThumbAtPath:imagePath];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            completion(TRUE);
            
        });
    });
}
- (void)downloadingThumbnailAtPath:(NSString *)imagePath {
    //    dispatch_async( dispatch_get_main_queue(), ^{
    // Create the image source
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:imagePath], NULL);
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(480)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    NSLog(@"thumbnail---->%@\n%@",thumbnail,imagePath);
    
    if(thumbnail)
    {
        CFRelease(src);
        // Write the thumbnail at path
      
        CGImageWriteToFile(thumbnail, imagePath);
    }
    
    //    });
}


- (UIImage *)getCurrentScreenShot {
    return [self fullScreenShot];
    /*
     UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
     CGRect rect = [keyWindow bounds];
     UIGraphicsBeginImageContext(rect.size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     [keyWindow.layer renderInContext:context];
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return img;*/
}

- (UIImage*)fullScreenShot {
    CGSize imgSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0);
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if (![window respondsToSelector:@selector(screen)] || window.screen == [UIScreen mainScreen]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
    }
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(NSString*)getAppName
{
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    
    if (![appname isKindOfClass:[NSString class]]) {
        appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (![appname isKindOfClass:[NSString class]]) {
            appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        if (![appname isKindOfClass:[NSString class]]) {
            appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        }
        if (![appname isKindOfClass:[NSString class]]) {
            appname = @"";
        }
        
    }
    return appname;
}
-(float)getTopSafeArea
{
    float safeAreaTop = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaTop = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    return safeAreaTop;
}
-(float)getBottomSafeArea
{
    float safeAreaBottom = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    return safeAreaBottom;
}
@end

