//


//
//  Created by Antony Joe Mathew on 12/11/14.
//  Copyright (c) 2014 XXXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"


@interface SingletonClass : NSObject{

    

}


@property(strong, nonatomic) NSString* deviceID;
 
@property(assign, nonatomic) kHorizontalScrolIndex currentHorizontalIndex;
@property(assign, nonatomic) kVerticalScrolIndex currentVerticalIndex;

+ (SingletonClass *)getInstance;

-(void)changingFontsAndAlignMent;


@end
