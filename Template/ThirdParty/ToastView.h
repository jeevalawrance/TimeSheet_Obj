//
//  ToastView.h
//  ToastPOC
//
//  Created by Antony Joe Mathew on 5/8/14.
//  Copyright (c) 2014 MSI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToastView : UIView
-(void)showToastWithMessage:(NSString*)message withDuration:(float)duration;
@end
