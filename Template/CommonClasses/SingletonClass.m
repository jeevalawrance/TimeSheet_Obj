//


//
//  Created by Antony Joe Mathew on 12/11/14.
//  Copyright (c) 2014 XXXX. All rights reserved.
//

#import "SingletonClass.h"
 @implementation SingletonClass


static SingletonClass* _sharedMySingleton = nil;


- (id)init
{
    self = [super init];
    if (self) {
      
        
      //  deviceID = [OpenUDID value];

        
        [self changingFontsAndAlignMent];
        
     }
    return self;
}
+ (SingletonClass *)getInstance {
    static SingletonClass *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SingletonClass alloc] init];
    });
    return sharedInstance;
}


-(void)changingFontsAndAlignMent
{
    
  
    
    //[CommonFunction updatingTokentoServer];
    
}


@end
