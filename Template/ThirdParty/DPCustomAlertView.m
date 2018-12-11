//
//  RateView.m
//  NewDua
//
//  Created by xxx on 6/1/17.
//  Copyright © 2017 xxx. All rights reserved.
//

#import "DPCustomAlertView.h"
#import "CommonFunction.h"
#import "URLConstants.h"
#import "SingletonClass.h"


@interface DPCustomAlertView (){
}
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingX;

@property (strong, nonatomic) IBOutlet UIView *viewCardBg;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnRateNow;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnNotNow;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewRateThumb;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottomVerticalLine;
@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, assign) ClickedCustomAlertButtonIndex clickdButtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottomHorizontal;

@end


@implementation DPCustomAlertView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithViewController:(UIViewController*)viewController
{
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"DPCustomAlertView"
                                                    owner:self options:nil];
    self = [bundle firstObject];
    self.frame = viewController.view.bounds;

    if (self) {
        
        self.viewCardBg.layer.cornerRadius = 10.;
        self.viewCardBg.clipsToBounds = YES;
        self.btnOK.superview.layer.cornerRadius = self.viewCardBg.layer.cornerRadius;
        //  _imgBG.image = [UIImage imageNamed:@"RTA NOL_Bg-1"];
        self.tag = 90;
        
        _viewCardBg.layer.borderColor = NavigationBarColor.CGColor;
        _viewCardBg.layer.borderWidth=1.0;
        float heightMultificationFactor = 427/667;
        float widthMultificationFactor = 315/375;
        
        _imgBottomHorizontal.backgroundColor = NavigationBarColor;
        _imgBottomVerticalLine.backgroundColor =NavigationBarColor;
        CGRect rateBounds = CGRectMake([UIScreen mainScreen].bounds.size.width - widthMultificationFactor*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - heightMultificationFactor*[UIScreen mainScreen].bounds.size.height, widthMultificationFactor*[UIScreen mainScreen].bounds.size.width, heightMultificationFactor*[UIScreen mainScreen].bounds.size.height);
        self.viewCardBg.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.viewCardBg.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.viewCardBg.layer.shadowOpacity = 0.7f;
        self.viewCardBg.layer.shadowRadius = 4.0f;
        CGRect shadowRect = CGRectInset(rateBounds, 0, 4);  // inset top/bottom
        self.viewCardBg.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        self.viewCardBg.layer.masksToBounds = NO;
        
        [_btnOK setTitleColor:NavigationBarColor forState:UIControlStateNormal];
        [_btnRateNow setTitleColor:NavigationBarColor forState:UIControlStateNormal];
        [_btnNotNow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _btnRateNow.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _btnNotNow.titleLabel.font = [UIFont systemFontOfSize:16];
        
        //[self presentAnimateAction];
        
        //set font
        if (IS_ARABIC) {
            //_btnRateNow.superview.transform    = CGAffineTransformMakeScale(-1,1);
            //_btnRateNow.transform    = CGAffineTransformMakeScale(-1,1);
            //_btnNotNow.transform    = CGAffineTransformMakeScale(-1,1);
            
            //            _lblTitle.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            //            _lblDesc.font = [UIFont fontWithName:@"DroidArabicKufi" size:15.0];
            //            _btnRateNow.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            //            _btnNotNow.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            
        }
        else{
            
            /*
             "Poppins-Light",
             "Poppins-Medium",
             "Poppins-SemiBold",
             "Poppins-Regular",*/
            //            _lblTitle.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
            //            _lblDesc.font = [UIFont fontWithName:@"Poppins-Medium" size:15.0];
            //            _btnRateNow.titleLabel.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
            //            _btnNotNow.titleLabel.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
        }
        
        
        
        
        _viewCardBg.alpha = 0.0;
        _imgViewRateThumb.alpha = 0.0;
        _imgViewRateThumb.image = nil;
        //        UIView* window = viewController.view;
        //        if (!window)
        //            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *view = [viewController.view viewWithTag:90];
        
        if (view) {
            [view removeFromSuperview];
        }
        [viewController.view addSubview:self];
        
        //        [[[window subviews] objectAtIndex:0] addSubview:self];
        
        //    [self presentAnimateAction];
        
    }
    return self;
}
- (id)init
{
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"DPCustomAlertView"
                                                    owner:self options:nil];
    self = [bundle firstObject];
    self.frame = [UIScreen mainScreen].bounds;
    
    if (self) {
        
        self.viewCardBg.layer.cornerRadius = 10.;
        self.viewCardBg.clipsToBounds = YES;
        self.btnOK.superview.layer.cornerRadius = self.viewCardBg.layer.cornerRadius;
        //  _imgBG.image = [UIImage imageNamed:@"RTA NOL_Bg-1"];
        self.tag = 90;
        
        _viewCardBg.layer.borderColor = NavigationBarColor.CGColor;
        _viewCardBg.layer.borderWidth=1.0;
        float heightMultificationFactor = 427/667;
        float widthMultificationFactor = 315/375;
        
        _imgBottomHorizontal.backgroundColor = NavigationBarColor;
        _imgBottomVerticalLine.backgroundColor =NavigationBarColor;
        CGRect rateBounds = CGRectMake([UIScreen mainScreen].bounds.size.width - widthMultificationFactor*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - heightMultificationFactor*[UIScreen mainScreen].bounds.size.height, widthMultificationFactor*[UIScreen mainScreen].bounds.size.width, heightMultificationFactor*[UIScreen mainScreen].bounds.size.height);
        self.viewCardBg.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.viewCardBg.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.viewCardBg.layer.shadowOpacity = 0.7f;
        self.viewCardBg.layer.shadowRadius = 4.0f;
        CGRect shadowRect = CGRectInset(rateBounds, 0, 4);  // inset top/bottom
        self.viewCardBg.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        self.viewCardBg.layer.masksToBounds = NO;
        
        [_btnOK setTitleColor:NavigationBarColor forState:UIControlStateNormal];
        [_btnRateNow setTitleColor:NavigationBarColor forState:UIControlStateNormal];
        [_btnNotNow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _btnRateNow.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _btnNotNow.titleLabel.font = [UIFont systemFontOfSize:16];
        
        //[self presentAnimateAction];
        
        //set font
        if (IS_ARABIC) {
            //_btnRateNow.superview.transform    = CGAffineTransformMakeScale(-1,1);
            //_btnRateNow.transform    = CGAffineTransformMakeScale(-1,1);
            //_btnNotNow.transform    = CGAffineTransformMakeScale(-1,1);
            
            //            _lblTitle.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            //            _lblDesc.font = [UIFont fontWithName:@"DroidArabicKufi" size:15.0];
            //            _btnRateNow.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            //            _btnNotNow.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-Bold" size:15.0];
            
        }
        else{
            
            /*
             "Poppins-Light",
             "Poppins-Medium",
             "Poppins-SemiBold",
             "Poppins-Regular",*/
            //            _lblTitle.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
            //            _lblDesc.font = [UIFont fontWithName:@"Poppins-Medium" size:15.0];
            //            _btnRateNow.titleLabel.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
            //            _btnNotNow.titleLabel.font = [UIFont fontWithName:@"Poppins-Bold" size:15.0];
        }
        
        
        
        
        _viewCardBg.alpha = 0.0;
        _imgViewRateThumb.alpha = 0.0;
        _imgViewRateThumb.image = nil;
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:90];
        
        if (view) {
            [view removeFromSuperview];
        }
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        //        [[[window subviews] objectAtIndex:0] addSubview:self];
        
        //    [self presentAnimateAction];
        
    }
    return self;
}

-(void)presentAnimateAction{
    
    CGRect originalFrame = _viewCardBg.frame;
    CGRect initialFrame = originalFrame;
    initialFrame.origin.y   = originalFrame.origin.y - originalFrame.size.height;
    _viewCardBg.frame = initialFrame;
    _imgViewRateThumb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _viewCardBg.frame = originalFrame;
                         _viewCardBg.alpha = 1.0;
                         _imgViewRateThumb.alpha = 1.0;
                         _imgViewRateThumb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         //                         _viewCardBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         
                         
                     }completion:^(BOOL finished) {
                         
                         {
                             
                         }
                         
                         if ([_delegate respondsToSelector:@selector(rateViewPresentAnimationCompleted)]) {
                             [_delegate rateViewPresentAnimationCompleted];
                         }
                     }];
    
    
}
-(void)imageAnimationExtentedAction:(id)sender{
    
}
-(void)closePopup{
    _completionBlock(_clickdButtn);
    
    CGRect originalFrame = _viewCardBg.frame;
    CGRect finalFrame = originalFrame;
    finalFrame.origin.y   = originalFrame.origin.y + originalFrame.size.height;
    //_viewCardBg.frame = initialFrame;
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _viewCardBg.frame = finalFrame;
                         _viewCardBg.alpha = 0.0;
                         _imgViewRateThumb.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                         
                         
                     }completion:^(BOOL finished) {
                         _viewCardBg.frame = originalFrame;
                         
                         [self removeFromSuperview];
                         if ([_delegate respondsToSelector:@selector(rateViewCloseAnimationCompleted)]) {
                             [_delegate rateViewCloseAnimationCompleted];
                         }
                     }];
    
    
}
-(void)showCustomAlertWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitle Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion
{
    _completionBlock = completion;
    _imgBottomVerticalLine.hidden = TRUE;
    _btnRateNow.hidden = TRUE;
    _btnNotNow.hidden = TRUE;
    _btnOK.hidden = FALSE;
    [_btnOK setTitle:buttonTitle forState:UIControlStateNormal];
    
    [self loadViewWithTitle:nil andDescription:message];
    
}
-(void)showCustomAlertWithMessage:(NSString*)message Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion
{
    _completionBlock = completion;
    _imgBottomVerticalLine.hidden = TRUE;
    _btnRateNow.hidden = TRUE;
    _btnNotNow.hidden = TRUE;
    _btnOK.hidden = FALSE;
    [_btnOK setTitle:[CommonFunction localizedString:@"OK"] forState:UIControlStateNormal];
    
    [self loadViewWithTitle:nil andDescription:message];
    
}
-(void)showCustomAlertWithTitle:(NSString*)title Message:(NSString*)message Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion;
{
    _completionBlock = completion;
    
    [self showCustomAlertWithTitle:title Message:message yesButtonTitle:[CommonFunction localizedString:@"OK"] noButtonTitle:[CommonFunction localizedString:@"Cancel"] Completion:^(ClickedCustomAlertButtonIndex buttonClikd) {
        completion(buttonClikd);
    }];
}
-(void)showCustomAlertWithTitle:(NSString*)title Message:(NSString*)message yesButtonTitle:(NSString*)yesTitle noButtonTitle:(NSString*)noTitle Completion:(void (^)(ClickedCustomAlertButtonIndex buttonClikd))completion
{
    
    
    _completionBlock = completion;
    
    if (IS_ARABIC) {
        _btnRateNow.superview.transform    = CGAffineTransformMakeScale(-1,1);
        _btnRateNow.transform    = CGAffineTransformMakeScale(-1,1);
        _btnNotNow.transform    = CGAffineTransformMakeScale(-1,1);
        
    }
    
    [_btnNotNow setTitle:noTitle forState:UIControlStateNormal];
    [_btnRateNow setTitle:yesTitle forState:UIControlStateNormal];
    [self loadViewWithTitle:title andDescription:message];
    
}

-(void)loadViewWithTitle:(NSString*)title andDescription:(NSString*)message
{
    
    _imgViewRateThumb.image                  = [UIImage imageNamed:@"AppIcon40x40"];
    
    
    if (![title isKindOfClass:[NSString class]]|| title.length==0) {
        title = [[CommonFunction getInstance] getAppName];
        
        
    }
    _lblTitle.text = title;
    
    NSDictionary *attrsDictionary = [self newsAttributes];
    if (![message isKindOfClass:[NSString class]]) {
        message = [CommonFunction localizedString:@"Try Again"];
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attrsDictionary];
    //  [attrString addAttributes:attrsDictionary range:NSMakeRange(0, attrString.length)];
    
    
    float wdth = ([UIScreen mainScreen].bounds.size.width*_constraintWidthratio.multiplier)- 2.0*_constraintLeadingX.constant;
    float descHeight = [CommonFunction heightframeOfLableFromWidth:wdth fromText:attrString minHeight:20];
    
    _txtViewDescriptionHeight.constant = descHeight;
    _txtDescription.scrollEnabled = NO;
    _txtDescription.textContainerInset = UIEdgeInsetsZero;
    _txtDescription.textContainer.lineFragmentPadding = 0;
    //    _txtDescription.backgroundColor = [UIColor greenColor];
    if (descHeight > 250) {
        _txtDescription.scrollEnabled = YES;
        _txtViewDescriptionHeight.constant = 250;
    }
    else
        
    {
        _txtViewDescriptionHeight.constant = _txtViewDescriptionHeight.constant+20;
    }
    UIImage *img =[UIImage imageNamed:@"Bg_White-1"];
    UIImageView *imgBG =[[UIImageView alloc] initWithImage:img];
    imgBG.frame = _viewCardBg.bounds;
    imgBG.contentMode = UIViewContentModeScaleAspectFill;
    [_viewCardBg addSubview:imgBG];
    [_viewCardBg sendSubviewToBack:imgBG];
    [self layoutIfNeeded];
    
    imgBG.clipsToBounds = TRUE;
    _viewCardBg.clipsToBounds = TRUE;
    
    //  _lblDesc.attributedText = attrString;
    _txtDescription.attributedText = attrString;
    
    [self presentAnimateAction];
    
}
-(NSDictionary*)newsAttributes
{
    NSDictionary *attrsDictionary;
    NSMutableParagraphStyle *newsParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    newsParagraphStyle.alignment=NSTextAlignmentCenter;
    
    attrsDictionary = @{NSBackgroundColorAttributeName:[UIColor clearColor], NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:newsParagraphStyle, NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    return attrsDictionary;
    
    newsParagraphStyle.headIndent = 0.0;
    /*  if(IS_ARABIC)
     {
     newsParagraphStyle.lineSpacing=2.5;
     newsParagraphStyle.alignment=NSTextAlignmentCenter;
     
     
     }
     else
     {
     newsParagraphStyle.lineSpacing=2.5;
     newsParagraphStyle.alignment=NSTextAlignmentCenter;
     
     //   newsParagraphStyle.lineHeightMultiple=1.25;
     }*/
    newsParagraphStyle.lineSpacing=2.5;
    newsParagraphStyle.alignment=NSTextAlignmentCenter;
    
    
    newsParagraphStyle.paragraphSpacing = 0.0;
    
    newsParagraphStyle.firstLineHeadIndent = 0.0;
    // newsParagraphStyle.tailIndent = 0.0;
    
    
    if(IS_ARABIC)
    {
        newsParagraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;// NSWritingDirectionLeftToRight
        // [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName
        attrsDictionary = @{NSBaselineOffsetAttributeName:[NSNumber numberWithFloat:0],NSBackgroundColorAttributeName:[UIColor clearColor], NSFontAttributeName : [UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:newsParagraphStyle, NSForegroundColorAttributeName : [UIColor darkGrayColor]};
        
    }
    else{
        attrsDictionary= @{ NSFontAttributeName : [UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:newsParagraphStyle,NSBackgroundColorAttributeName:[UIColor clearColor], NSForegroundColorAttributeName : [UIColor darkGrayColor]};
        
    }
    
    return attrsDictionary;
    
    
}


#pragma mark - Button ACTIONS
- (IBAction)btnRateNowAction:(id)sender {
    _clickdButtn = OKButtonClicked;
    [self closePopup];
    
    if ([_delegate respondsToSelector:@selector(rateViewRateNowSelected)]) {
        [_delegate rateViewRateNowSelected];
    }
}
- (IBAction)btnLaterAction:(id)sender {
    _clickdButtn = CancelButtonClicked;
    
    [self closePopup];
    
    if ([_delegate respondsToSelector:@selector(rateViewNotNowSelected)]) {
        [_delegate rateViewNotNowSelected];
    }
    
}

@end
