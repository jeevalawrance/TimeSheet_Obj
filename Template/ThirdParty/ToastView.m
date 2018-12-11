//
//  ToastView.m
//  ToastPOC
//
//  Created by Antony Joe Mathew on 5/8/14.
//  Copyright (c) 2014 MSI. All rights reserved.
//

#import "ToastView.h"

static const CGFloat ANToastFadeDuration        = 0.3;
@interface ToastView(){
    BOOL isClosed;
    
}
@end
@implementation ToastView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)removeSuperView
{
    [self removeFromSuperview];
}

- (void)closeToast
{
    if (isClosed) {
        return;
    }
    isClosed=TRUE;
    
   [UIView animateWithDuration:ANToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeSuperView];
                     }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeToast];
}



-(void)showToastWithMessage:(NSString*)message withDuration:(float)interval
{
    isClosed=FALSE;
    if ([[[[UIApplication sharedApplication] windows] firstObject] viewWithTag:-100001])
    {
        //Checking if there is already atoast is present
         return;
    }
    
  
    self.userInteractionEnabled=TRUE;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    [self addingMessage:message];
   
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    self.tag=-100001;
    
    void (^animations)() = ^{
        self.alpha = 1.0f;
        
    };
    
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:ANToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:^(BOOL completed) {
                       
                         [self performSelector:@selector(closeToast) withObject:nil afterDelay:interval];
                     
                     }];
    
    
    
}



#pragma ADDING VIEWS FOR IMAGE AND MESSAGE

-(void)addingMessage:(NSString*)message
{
    float xOffSet=10;
    float spacingBetweenView=9.0f;
    float imageSize=35.0f;
    CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-2*xOffSet, [UIScreen mainScreen].bounds.size.height/2);
    
    UIView *containerView=[[UIView alloc] init];
    containerView.backgroundColor=[UIColor colorWithRed:(50.0f/255.0f) green:(50.0f/255.0f) blue:(50.0f/255.0f) alpha:1.0f];
    containerView.layer.cornerRadius=5.0f;
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    messageLabel.text =message;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor=[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    //messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    messageLabel.textAlignment=NSTextAlignmentLeft;
    messageLabel.backgroundColor=[UIColor clearColor];
    
    CGSize maximumLabelSize = CGSizeMake(frame.size.width-imageSize-3*spacingBetweenView, 9999); // this width will be as per your requirement
    CGSize expectedSize = [messageLabel sizeThatFits:maximumLabelSize];
    
    if (expectedSize.height<imageSize) {
        expectedSize.height=imageSize;
    }
    if (expectedSize.width<(frame.size.width-3*spacingBetweenView-imageSize))
    {
        frame.size.width=expectedSize.width+imageSize+3*spacingBetweenView;
        xOffSet=[UIScreen mainScreen].bounds.size.width/2-frame.size.width/2;
    }
    containerView.frame=CGRectMake(xOffSet, (([UIScreen mainScreen].bounds.size.height/2.0)-(expectedSize.height/2)-spacingBetweenView), frame.size.width, (expectedSize.height+2*spacingBetweenView));
    ;
    messageLabel.frame=CGRectMake(2*spacingBetweenView+imageSize,((containerView.frame.size.height/2.0f)-(expectedSize.height/2.0f)), expectedSize.width, expectedSize.height);
    
    
    UIImageView *logoImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon40x40"]];
    frame.origin.x=spacingBetweenView;
    frame.origin.y=containerView.frame.size.height/2.0f-imageSize/2.0f;
    frame.size.width=imageSize;
    frame.size.height=imageSize;
    logoImage.frame=frame;
    
    [self addSubview:containerView];
    [containerView addSubview:messageLabel];
    [containerView addSubview:logoImage];
    
}
@end
