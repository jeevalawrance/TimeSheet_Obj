//
//  URLConstants.h
//  Xpress
//
//  Created by Antony Joe Mathew on 11/22/13.
//  Copyright (c) 2013 Antony Joe Mathew on, Media Systems Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef URLConstants_h
#define URLConstants_h


/*
 #ifdef DEBUG
 #define XpressFIFA_BaseUrl                      @"https://fifa.letsxprs.com/ws/"
 #define MMUrl                               @"http://x2testconvertmm.cloudapp.net/UploadMultimediaFiles.aspx"
 #else
 #define XpressFIFA_BaseUrl                      @"https://dev.xprsapp.com/ws/"
 #define MMUrl                               @"https://convertmm.xprsapp.com/UploadMultimediaFiles.aspx"
 #endif
 
 */

#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define COREDATAHELPER (Coredatahelper*)[Coredatahelper getInstance]

#define kAppID @""

#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define BaseURLString                     @"http://10.5.18.47/api/"// @"http://10.5.18.47"
#define AuthenticationUserName                  @"kamal"
#define AuthenticationPassword                  @"Cpd.com12@"

#define IMAGE_OFFSET_SPEED 150



#define SelecteLangauge @"SelectedLangaugeKey"
#define IS_ARABIC    ([[[NSUserDefaults standardUserDefaults] valueForKey:SelecteLangauge] isEqualToString:@"ar"])


#define CombineStrings(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]


#define ForgotPasswordURL                  @"http://stackoverflow.com/questions/2393386/best-way-to-sort-an-nsarray-of-nsdictionary-objects"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NavigationBarColor [UIColor colorWithRed:(198.0f/255.0f) green:(157.0f/255.0f) blue:(47.0f/255.0f) alpha:1]

#define adminCommonBGColor [UIColor colorWithRed:(232.0f/255.0f) green:(232.0f/255.0f) blue:(232.0f/255.0f) alpha:1]



#define kColorGoldenTopBar [UIColor colorWithRed:(198.0f/255.0f) green:(157.0f/255.0f) blue:(47.0f/255.0f) alpha:1]
#define kColorGreenTopBar [UIColor colorWithRed:(28.0f/255.0f) green:(128.0f/255.0f) blue:(74.0f/255.0f) alpha:1]

#define kColorBlueTopBar [UIColor colorWithRed:(56.0f/255.0f) green:(45.0f/255.0f) blue:(125.0f/255.0f) alpha:1]
#define kBorderColorNormal UIColorFromRGB(0x1B79B6)
#define kBorderColorError UIColorFromRGB(0xf06e6e)

#define kNotificationColorError UIColorFromRGB(0xed4040)


#define kBannerAlertImage [UIImage imageNamed:@"erroricon"]


#define Font_Arabic_Helvetica_Medium                       @"Helvetica Neue LT Arabic"
#define Font_Arabic_Helvetica_Bold                         @"HelveticaNeueLTArabic-Bold"
#define Font_Arabic_Helvetica_Light                        @"HelveticaNeueLTArabic-Light"

#define Font_English_Roboto_Medium                       @"Roboto-Light"
#define Fon_English_Roboto_Bold                         @"Roboto-Bold"
#define Font_English_Roboto_Light                        @"Roboto-Light"

#define Font_English_Gotham_Light                        @"Gotham-Light"
#define Font_English_Gotham_Medium                       @"Gotham-Medium"
#define Font_English_Gotham_Bold                         @"Gotham-Black"

#define FontRegular                    @"Dubai-Regular"
#define FontBold                       @"Dubai-Bold"
#define FontLight                      @"Dubai-Light"


#define kThumbNailExtension @"thumbnail"






#define PushuserNameAutheitcation              @""
#define PushpasswordAutheitcation              @""


#define IsRememberMeKey                       @"IsRememberMeKey"
#define IsLogin                             @"isLoginKey"
#define IsRegisterd                         @"IsRegisterd"


#define pushRegisterd                       @"pushRegisterd"
#define pushNotificationToken               @"pushNotificationToken"
#define isPushTokenChanged                  @"isPushTokenChanged"



#define NoActiveInternet                    @"No Active internet connection available !"


#define kShouldShow @"showRateAlert"
#define kdFormat @"dd-MM-yyyy"
#define kDateNextShow @"DateNextShow"
#define kFirstTime @"firstTime"

#define kLoadingTutorial @"LoadingTutorial"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#endif
