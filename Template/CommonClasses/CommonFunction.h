//
//  CommonFunction.h
//  Xpress
///
//  Created by Antony  11/22/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <Foundation/Foundation.h>

#import <Photos/Photos.h>


 @interface CommonFunction : NSObject
+(CommonFunction *) getInstance;

@property(nonatomic, strong) AVAudioPlayer *audPlayer;
/**
 Validate the email address
 @param email
 text to be validated
 @return ture or false
 */
+(BOOL) validateEmail:(NSString *)email;

+(BOOL) validatePhoneNumber:(NSString *)phoneNumber;
+(void)showAlert:(NSString*)msg;

/**
 Validate the name to ensure there is no numbers or special charecters
 @param name
 text to be validated
 @return ture or false
 */

+ (void)displayTheToastWithMsg:(NSString *)msg duration:(float)durationValue;


/**
 Validate the number to ensure there is no special charecters
 @param number
 text to be validated
 @return ture or false
 */



/**
 Function for encoding String
 @param number
 String to be encoded
 @return encoded string
 */
+ (NSString *)base64Encode:(NSString *)plainText;

/**
 Function for decoding encoded String
 @param number
 String to be decoded
 @return decoded string
 */
+(NSString *)base64Decode:(NSString *)base64String;

+ (void )setUserdefaultsValueafterEncoding:(NSString *)value forKey:(NSString*)key;

+(NSString *)getValueForkeyAfterDecoding:(NSString *)key;

+(void)paddingtoTextField:(UITextField*)textField;
+(NSString*) localizedString:(NSString *)key;

+ (NSString *) trimWhitespacesAndGivingCorrectString:(NSString *)string;


//+(void)showIndicator:(UIView *)indicatorView message:(NSString *)msg;

+(void)stopIndicator:(UIView *)indicatorView;

+(UIImage*)patchImageForGroundBG;
+(UIColor*)commonBGColor;
/**
 get contacts from phonebook
 */
+(void)removeMultimedia:(NSString *)fileName;
+(NSDate *)endOfDay:(NSDate *)date;
+(NSDate *)beginningOfDay:(NSDate *)date;
+(NSArray*)matchesOftheDay:(NSDate*)date;
+(void)showinActiveINternetAlert;
+(BOOL)isActiveInternet;

+(void)removeLoaderFromViewController:(UIViewController*)vc;
+(void)showLoaderInViewController:(UIViewController*)vc;

+(BOOL)isValidPhoneNumber:(NSString*)phoneNumber;
+(void)updatingTokentoServer;
+(void)borderForView:(id)v;
+(UIImage*)thumbnailfromPickerInfo:(NSDictionary*)dict;
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
+(NSDictionary*)dictionaryFromString:(NSString*)str;
+(NSString*)stringFromDictionary:(NSDictionary*)theDict;
+(NSString*)UUID;
+(NSString*)randomStringGeneration;
+(UIImage*)thumbnailFromVideoPath:(NSString*)url;
+(UIImage *)loadThumbNailFromUrl:(NSURL *)urlVideo;
+(NSMutableDictionary *)dictionaryByReplacingNullsWithStrings:(id)sourceDictionary;
+(NSString *) getDateForGrouping:(NSDate *)date;
+(void)changinhTheFonts:(UIView*)view;
+(void)changingPlaceHolderColor:(UIView*)view toColor:(UIColor*)color;
+(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format;
+(NSString*)uniqueString;
+(CGFloat)heightframeOfLableFromWidth:(float)width fromText:(NSAttributedString*)attributedtext minHeight:(float)minheight;
+(CGRect)frameOfTopbarfromText:(NSString*)text andFont:(UIFont*)font height:(float)height;
+(NSAttributedString*)attributedStringFromAlignMent:(NSTextAlignment)allignMent font:(UIFont*)font andText:(NSString*)text;

+(NSError*)errorFromErrormessage:(NSString*)errorMessage;
+(NSMutableArray *)arrayByReplacingNullsWithStrings:(id)sourceArray;

+(void)deleteteObjectFromKeychain:(NSString*)key;
+(id)getObjectFromKeyChain:(NSString*)key;
+(void)setObjectInKeychain:(id)object key:(NSString*)key;
+(NSString*)getLocalisedString:(NSString*)key;
+(void)paddingtoTextField:(UITextField*)textField leftWidth:(float)leftWidth rightW:(float)rightWidth;
+(void)changingPlaceHolderFontOftextField:(UITextField*)textField font:(UIFont*)font color:(UIColor*)color;
+(void)showNotificationWithTitle:(NSString *)titleStr message:(NSString *)msgStr bg:(id)bg iconImage:(UIImage*)icon;
+(void)showAlertWithTitle:(NSString *)titleStr andMessage:(NSString *)msgStr inViewController:(UIViewController *)vc;
+(void)setLoginRootViewControllerWithAnimation;
+(NSString *) getLastSeenDateString:(NSDate *)date;
+(NSString *)getCompleteJidFromPhoneNumber:(NSString*)phone countryOde:(NSString*)code;
+(NSString *)getCompletePsswordFromJid:(NSString*)jid;
+(NSString*)removeAllCharactersOtherThanDigitFromString:(NSString*)string;
+(NSString *)getUserDPPathFromImagename:(NSString*)imgName ;
+(void)creatingFolderWithName:(NSString*)foldername;

//+(NSString *)getChatImageFolderFromFileName:(NSString*)imgName;
//+(NSString *)getChatVideoFolderFromFileName:(NSString*)imgName;
//+(NSString *)getChatAudioFolderFromFileName:(NSString*)imgName;
//+(NSString *)getChatOtherDocsFolderFromFileName:(NSString*)imgName;

+(NSString *)getImageNameFromJid:(NSString*)jid;
+(NSString *)getCompleteJidFromFormatedPhoneNumber:(NSString*)phone;
+(NSString*)formattedPhoneNumberFromNumber:(NSString*)number;
-(NSString*)getRandomMessageID;
+(NSDate *)getDateFromString:(NSString *) dateString Format:(NSString *)format;
+ (UIColor *)colorFromHexString:(NSString *)hexString ;
 +(UIImage*)getReducedImageFrom :(UIImage *)image toKBSize :(int)kb_size;
-(void)playAlertSoundForMessages:(NSString*)soundname andExtension:(NSString*)extension;
-(void)playAlertSoundForRecievedMessages:(NSString*)soundname andExtension:(NSString*)extension;
-(void)playAlertSoundWithoutVibrateForMessages:(NSString*)soundname andExtension:(NSString*)extension;
+(NSString *)getChatDPPathFromImagename:(NSString*)imgName;
+(NSString*)interNationalFormattedPhoneNumberOf:(NSString*)number;
 -(UIImage*)getMyImage;
- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)resize;
+(void)loadContactEditDetailPage:(int)contactID inViewController:(UIViewController*)vc;

+(NSString*)stringwithNullCheck:(NSString*)theString;
 -(NSString*)getFirstLetterFromName:(NSString*)name;
+(BOOL)checkAddressBookPhoneNumberFromContact:(NSArray*)numberArray;
- (UIImage *)thumbnailFromVideoAtURL:(AVURLAsset *)asset;

+(void)saveImageToDocumentDirectory:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;
+(UIImage *)getImageFromDocumentDirectoryWithFileName:(NSString *)fileName ofType:(NSString *)extension;
+(BOOL)removeImageFromDocumentDirectoryWithFileName:(NSString *)fileName ofType:(NSString *)extension;
+ (UIImage *)imageFromColor:(UIColor *)color;
-(void)deleteChatsInBG:(NSArray*)chats;
-(void)deleteChatsInMainThread:(NSArray*)chats;
+ (UIViewController*)topViewController;



-(void)showShadowInNavigationController:(UINavigationController*)nav;
-(void)hideShadowInNavigationController:(UINavigationController*)nav;



-(UIImage*)getMyFullImage;
+(NSString *)getChatDPPath;

+ (NSString *)getAppversion;
-(void)deleteMessagesInBG:(NSArray*)messagesArray;
-(UIColor*)colorFromChatJID:(NSString*)jisString andText:(NSString*)text;
+(UIImage*)getScaledImageFromImage:(UIImage*)image imageID:(NSString*)imageId minSize:(float)minWidth;
- (void)generatingThumbAtPath:(NSString *)imagePath;

+ (void)resetUnmute;
- (void)CGImageWriteToFileimage:(CGImageRef)image imagePath:(NSString *)imagePath;
//+(NSString*)stringFromAnyObject:(id)theDict;
- (void)downloadingThumbnailAtPath:(NSString *)imagePath;
- (void)thumbnailGenerationWithCompletion:(NSString *)imagePath Completion:(void(^)(BOOL success))completion;
+(UIImage*)videoThumbFromURL:(NSString*)url;
-(void)playAlertSound:(NSString*)soundname andExtension:(NSString*)extension;
- (UIImage *)getCurrentScreenShot;
-(NSString*)getAppName;
-(float)getBottomSafeArea;

-(float)getTopSafeArea;
@end

