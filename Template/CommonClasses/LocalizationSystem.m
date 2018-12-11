//
//  LocalizationSystem.m
//  Template
//
//  Created by Anthony on 7/14/15.
//  Copyright (c) 2015 CPD. All rights reserved.
//

#import "LocalizationSystem.h"
#import "CommonHeaders.h"

@implementation LocalizationSystem

//Singleton instance
static LocalizationSystem *_sharedLocalSystem = nil;
static LocalizationSystem *sharedInstance = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;


- (id)init
{
    self = [super init];
    if (self) {
        [self setLanguage:[[NSUserDefaults standardUserDefaults] valueForKey:SelecteLangauge]];

     }
    return self;
}


+(LocalizationSystem *) sharedLocalSystem
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



+(id)alloc
{
    @synchronized([LocalizationSystem class])
    {
         _sharedLocalSystem = [super alloc];
        return _sharedLocalSystem;
    }
    // to avoid compiler warning
    return nil;
}


// Gets the current localized string as in NSLocalizedString.
//
// example calls:
// AMLocalizedString(@"Text to localize",@"Alternative text, in case hte other is not find");
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{

    return [bundle localizedStringForKey:key value:comment table:nil];
}


// Sets the desired language of the ones you have.
// example calls:
// LocalizationSetLanguage(@"Italian");
// LocalizationSetLanguage(@"German");
// LocalizationSetLanguage(@"Spanish");
//
// If this function is not called it will use the default OS language.
// If the language does not exists y returns the default OS language.
- (void) setLanguage:(NSString*) l{

    l=[[NSUserDefaults standardUserDefaults] valueForKey:SelecteLangauge];
   
    NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
    
    
    if (path == nil)
        //in case the language does not exists
        [self resetLocalization];
    else
        bundle = [NSBundle bundleWithPath:path];
}

// Just gets the current setted up language.
// returns "es","fr",...
//
// example call:
// NSString * currentL = LocalizationGetLanguage;
- (NSString*) getLanguage{
   /* if(IS_ARABIC)
    {
        return @"ar";
    }
    else
    {
      return @"en";
    }*/
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    NSString *preferredLang = [languages objectAtIndex:0];
    
    return preferredLang;
}

// Resets the localization system, so it uses the OS default language.
//
// example call:
// LocalizationReset;
- (void) resetLocalization
{
    bundle = [NSBundle mainBundle];
}


@end
