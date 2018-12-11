//
//  AppDelegate.m
//  Template
//
//  Created by Anthony on 11/1/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "AppDelegate.h"
#import "URLConstants.h"
#import "Coredatahelper.h"
#import "CommonFunction.h"
#import "NetworkLayer.h"
#import "Reachability.h"
#import "LocalizationSystem.h"
#import <UserNotifications/UserNotifications.h>
#import "ContainerViewController.h"

@interface AppDelegate ()
@property (nonatomic,retain)Reachability *reachability;

@end

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self enablingCoredata];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:SelecteLangauge];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsRegisterd]) {
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:kStoryboardIdDashboard bundle:nil];
        
//        UIViewController *myVC =[mainSB instantiateViewControllerWithIdentifier:@"dashBoardVC"];
        
        UINavigationController *vcLogin= [mainSB instantiateInitialViewController];
        [self.window setRootViewController:vcLogin];

//
    }
    /*
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kLoadingTutorial]) {
        
//        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:kStoryboardIdTutorial bundle:nil];
//
//        UIViewController *myVC =[mainSB instantiateViewControllerWithIdentifier:@"titorialRoot"];
//
//        self.window.rootViewController = myVC;
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        
        UINavigationController *vcLogin=[mainSB instantiateInitialViewController];;
        [self.window setRootViewController:vcLogin];

//        UIViewController *myVC =[mainSB instantiateViewControllerWithIdentifier:@"registerVC"];
//
//        self.window.rootViewController = myVC;
    }
    else{
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *middle =[mainSB instantiateViewControllerWithIdentifier:@"CenterViewControllerVC"];
//        UIViewController *leftVC =[mainSB instantiateViewControllerWithIdentifier:@"LeftViewControllerVC"];
        UINavigationController *leftVC = [mainSB instantiateViewControllerWithIdentifier:@"leftRoot"];
        UIViewController *rightVC =[mainSB instantiateViewControllerWithIdentifier:@"RightViewControllerVC"];
        
        ContainerViewController *container = [[ContainerViewController alloc] initWithLeftVC:leftVC rightVC:rightVC topVC:nil bottomVC:nil middleVC:middle];
        self.window.rootViewController = container;
    }
    */
    
    return YES;
}


-(void)mainViewController
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *middle =[mainSB instantiateViewControllerWithIdentifier:@"CenterViewControllerVC"];
    UIViewController *leftVC =[mainSB instantiateViewControllerWithIdentifier:@"LeftViewControllerVC"];
    UIViewController *rightVC =[mainSB instantiateViewControllerWithIdentifier:@"RightViewControllerVC"];
    
    ContainerViewController *container = [[ContainerViewController alloc] initWithLeftVC:leftVC rightVC:rightVC topVC:nil bottomVC:nil middleVC:middle];
    self.window.rootViewController = container;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // [self showRatingAlert];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Network Change Delegate

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        
    }
    
    
}

-(void)enableReachabilityFlags
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNetworkChange:) name: kReachabilityChangedNotification object: nil];
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
}

#pragma mark - Enabling PushNotification

-(void)enablePushNotification:(UIApplication*)application
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate =(id)self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            if(!error){
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
            }
            
        }];
        
    }
    
    else {
        
        // Code for old versions
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        
                                                        UIUserNotificationTypeBadge |
                                                        
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    

    
    
}
//Called when a notification is delivered to a foreground app.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:notification.request.content.userInfo];
    
}

//Called to let your app know which action was selected by the user for a given notification.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    completionHandler();
    
    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:response.notification.request.content.userInfo];
    
}



-(void) handleRemoteNotification:(UIApplication *) application   userInfo:(NSDictionary *) remoteNotif {
    
    NSLog(@"handleRemoteNotification");
    
    NSLog(@"Handle Remote Notification Dictionary: %@", remoteNotif);
    
    // Handle Click of the Push Notification From Here…
    // You can write a code to redirect user to specific screen of the app here….
    
}
#pragma mark - Notification Delegates


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    /*
     aps =     {
     alert = asdsadsa;
     badge = 1;
     sound = default;
     };
     id = 53;
     lang = arabic;
     section = news;
     slug = padel;
     "sports_category_id" = 4;
     */
    
    
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *deviceToken1 = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    //  UIPasteboard *pb = [UIPasteboard generalPasteboard];
    //  [pb setString:deviceToken1];
    
    if (deviceToken1!=NULL) {
        
        
        if ([[defaults valueForKey:pushNotificationToken] isEqualToString:deviceToken1])
        {
            [[NSUserDefaults standardUserDefaults] setValue:deviceToken1 forKey:pushNotificationToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPushTokenChanged];
            [[NSUserDefaults standardUserDefaults] setValue:deviceToken1 forKey:pushNotificationToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [CommonFunction updatingTokentoServer];
        
      
        
        
    }
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
}

#pragma mark - Notification Support

-(void)showNotification:(NSDictionary*)userInfo
{
//    UIImage *appIconImage = [UIImage imageNamed:@"Icon-40"];
//
//    CMNavBarNotificationView *notification = [CMNavBarNotificationView notifyWithText:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"]valueForKey:@"type"]]
//                                                                               detail:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"]valueForKey:@"alert"]]
//                                                                                image:appIconImage
//                                                                          andDuration:4.0];
//    notification.delegate=(id)self;
//    notification.backgroundColor=[UIColor blackColor];
//    notification.textLabel.textColor = [UIColor clearColor];
//    notification.userInfo=userInfo;
//    notification.tag=[[[userInfo objectForKey:@"aps"]valueForKey:@"nid"] intValue];
//
//    //notification.textLabel.backgroundColor = [UIColor clearColor];
//    notification.detailTextLabel.textColor = [UIColor whiteColor];
//
    // notification.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    
    
    
}

-(void)gotoNotificationTabAfterClickingNotification:(NSDictionary*)notification
{
    /*
     {
     aps =     {
     alert = jkhjkhjkhkjhjk;
     badge = 1;
     sound = default;
     };
     id = 261;
     lang = english;
     section = news;
     slug = futsal;
     "sports_category_id" = 1;
     }
     
     
     
     
     */
}
#pragma mark - Enabling COREDATA
-(void)enablingCoredata
{
    [COREDATAHELPER enablingCoredata];
}
#pragma mark - 3D Touch Support

-(void)set3DtouchMenuItems
{
    ;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(shortcutItems)])
    {
        
        
        /*  NSMutableArray *menuItemsArray=[[NSMutableArray alloc] init];
         for (NSDictionary *menu in [HHSingleton getInstance].HHMenuItemsArray)
         {
         int clikcedId=[menu[kMenuArrayIdKey] intValue];
         
         switch (clikcedId) {
         
         
         
         case 37:
         case 38:
         //Poetry
         {
         UIApplicationShortcutItem *menuItem;
         UIApplicationShortcutIcon *icon=[UIApplicationShortcutIcon iconWithTemplateImageName:@"poetry"];
         
         menuItem = [[UIApplicationShortcutItem alloc]initWithType:menu[kSubtitleMenuNameKey] localizedTitle:[CommonFunction getLocalisedString:@"POETRY3D"] localizedSubtitle: nil icon: icon userInfo: @{kMenuArrayIdKey:menu[kMenuArrayIdKey],kSubtitleMenuNameKey:menu[kSubtitleMenuNameKey]}];
         
         
         if(menuItem)
         
         [menuItemsArray addObject:menuItem];
         
         
         }
         break;
         
         case 3:
         case 4:
         //History
         
         break;
         
         case 31:
         case 32:
         //Multimedia
         
         break;
         
         case 23:
         case 27:
         //Foundations
         
         
         break;
         case 7:
         case 11:
         //Thoughts
         {
         UIApplicationShortcutItem * menuItem;
         UIApplicationShortcutIcon *icon=[UIApplicationShortcutIcon iconWithTemplateImageName:@"thoughts"];
         menuItem = [[UIApplicationShortcutItem alloc]initWithType:menu[kSubtitleMenuNameKey] localizedTitle:[CommonFunction getLocalisedString:@"THOUGHTS3D"] localizedSubtitle: nil icon: icon userInfo: @{kMenuArrayIdKey:menu[kMenuArrayIdKey],kSubtitleMenuNameKey:menu[kSubtitleMenuNameKey]}];
         
         if(menuItem)
         
         [menuItemsArray addObject:menuItem];
         
         
         }
         break;
         
         
         default:
         break;
         }
         
         
         }*/
        /*UIApplicationShortcutIconTypeCompose,
         UIApplicationShortcutIconTypePlay,
         UIApplicationShortcutIconTypePause,
         UIApplicationShortcutIconTypeAdd,
         UIApplicationShortcutIconTypeLocation,
         UIApplicationShortcutIconTypeSearch,
         UIApplicationShortcutIconTypeShare,
         UIApplicationShortcutIconTypeProhibit       NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeContact        NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeHome           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeMarkLocation   NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeFavorite       NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeLove           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeCloud          NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeInvitation     NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeConfirmation   NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeMail           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeMessage        NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeDate           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeTime           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeCapturePhoto   NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeCaptureVideo   NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeTask           NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeTaskCompleted  NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeAlarm          NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeBookmark       NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeShuffle        NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeAudio          NS_ENUM_AVAILABLE_IOS(9_1),
         UIApplicationShortcutIconTypeUpdate         NS_ENUM_AVAILABLE_IOS(9_1)*/
        
        
        
        
        //[UIApplication sharedApplication].shortcutItems = menuItemsArray;
        
        
    }
    
    
    
    
    
    
    
    
    
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%@", shortcutItem.userInfo);
    [self openAppBy3Dtouch:shortcutItem.userInfo];
    
}
-(void)openAppBy3Dtouch:(NSDictionary*)info
{}




#pragma mark - Show Rating Alert

int daysToAdd = 3;

-(void)showRatingAlert

{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kDateNextShow]==NULL)
    {
        NSDate *newDate1 = [[NSDate date] dateByAddingTimeInterval:60*60*24*daysToAdd];
        [[NSUserDefaults standardUserDefaults] setValue:[CommonFunction stringFromDate:newDate1 Format:kdFormat] forKey:kDateNextShow];
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:kShouldShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kShouldShow]==FALSE) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kdFormat];
    NSDate *nextDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:kDateNextShow]];
    NSLog(@"11newDate1 %@  -- >%@ ",nextDate,[[NSUserDefaults standardUserDefaults] valueForKey:kDateNextShow]);
    
    NSComparisonResult Compare = [nextDate compare: [NSDate date]];
    
    if (Compare != NSOrderedDescending)
    {
        NSLog(@"inside");
        //NSDate *now = [NSDate date];
        NSString  *appName=[[CommonFunction getInstance] getAppName];
        
       
        
        UIAlertController *alert            = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Rate %@",appName] message:[CommonFunction localizedString:@"If you love our app,Please take a moment to rate it in the App Store"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction             = [UIAlertAction actionWithTitle:[CommonFunction localizedString:@"Yes,Rate it!!"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:kShouldShow];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString * theUrl;
           
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.3")) {
                theUrl = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/us/app/itunes-u/id%@?action=write-review",kAppID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: theUrl] options:@{} completionHandler:nil];
                
            }
            else{
                theUrl = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: theUrl]];
                
            }
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction         = [UIAlertAction actionWithTitle:[CommonFunction localizedString:@"Remind me later"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            NSDate *newDate1 = [[NSDate date] dateByAddingTimeInterval:60*60*24*daysToAdd];
            NSLog(@"newDate1 %@ %@ ",newDate1,[CommonFunction stringFromDate:newDate1 Format:kdFormat]);
            [[NSUserDefaults standardUserDefaults] setValue:[CommonFunction stringFromDate:newDate1 Format:kdFormat] forKey:kDateNextShow];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alert addAction:yesAction];
        [alert addAction:cancelAction];
        [[self topViewController] presentViewController:alert animated:YES completion:nil];
        
        /*  UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Rate %@",appName] message:@"If you love our app,Please take a moment to rate it in the App Store" delegate:self cancelButtonTitle:@"Yes,Rate it!!" otherButtonTitles:@"Not Now", nil];
         
         [alt show];*/
    }
    
}
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

/*
 #define imageDimension 1200.0f

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
}*/

@end
