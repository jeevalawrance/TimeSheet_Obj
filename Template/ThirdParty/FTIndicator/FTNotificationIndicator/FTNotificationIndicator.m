//
//  FTNotificationIndicator.m
//  FTIndicator
//
//  Created by liufengting on 16/7/26.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import "FTNotificationIndicator.h"
#import "CommonHeaders.h"

#pragma mark - Defines

#define kFTNotificationMaxHeight                        (200.f)
#define kFTNotificationTitleHeight                      (24.f)
#define kFTNotificationMargin_X                         (10.f)
#define kFTNotificationMargin_Y                         (10.f)
#define kFTNotificationImageSize                        (20.f)
#define kFTNotificationStatusBarHeight                  ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kFTNotificationDefaultAnimationDuration         (0.2f)
#define kFTNotificationDefaultTitleFont                 [UIFont boldSystemFontOfSize:15]
#define kFTNotificationDefaultMessageFont               [UIFont systemFontOfSize:13]
#define kFTNotificationDefaultTextColor                 [UIColor whiteColor]
#define kFTNotificationDefaultTextColor_ForDarkStyle    [UIColor whiteColor]

#define kFTScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kFTScreenHeight   [UIScreen mainScreen].bounds.size.height

#pragma mark - FTNotificationIndicator

@interface FTNotificationIndicator ()

@property (nonatomic, weak)UIWindow *backgroundWindow;
@property (nonatomic, strong)FTNotificationIndicatorView *notificationView;
@property (nonatomic, assign)UIBlurEffectStyle indicatorStyle;
@property (nonatomic, strong)UIImage *notificationImage;
@property (nonatomic, strong)id notificationBackgroundImageOrColor;

@property (nonatomic, strong)NSString *notificationTitle;
@property (nonatomic, strong)NSString *notificationMessage;
@property (nonatomic, strong)NSTimer *dismissTimer;
@property (nonatomic, assign)BOOL isCurrentlyOnScreen;
@property (nonatomic, assign)BOOL shouldAutoDismiss;
@property (nonatomic, copy, nullable) FTNotificationTapHandler tapHandler;
@property (nonatomic, copy, nullable) FTNotificationCompletion completion;

@end

@implementation FTNotificationIndicator

#pragma mark - class methods

+ (FTNotificationIndicator *)sharedInstance
{
    static FTNotificationIndicator *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FTNotificationIndicator alloc] init];
    });
    return shared;
}

+ (void)setNotificationIndicatorStyleToDefaultStyle
{
    [self sharedInstance].indicatorStyle = UIBlurEffectStyleLight;

}

+ (void)setNotificationIndicatorStyle:(UIBlurEffectStyle)style
{
    [self sharedInstance].indicatorStyle = style;
}

+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message
{
    [self showNotificationWithImage:nil title:title message:message backgroundProperty:nil tapHandler:nil completion:nil];
}

+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler
{
    [self showNotificationWithImage:nil title:title message:message backgroundProperty:nil tapHandler:tapHandler completion:nil];
}

+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [self showNotificationWithImage:nil title:title message:message backgroundProperty:nil tapHandler:tapHandler completion:completion];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message
{
    [self showNotificationWithImage:image title:title message:message backgroundProperty:nil tapHandler:nil completion:nil];
}
+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message backgroundProperty:backGroundProperty
{
    [self showNotificationWithImage:image title:title message:message backgroundProperty:backGroundProperty tapHandler:nil completion:nil];
}
+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler
{
    [self showNotificationWithImage:image title:title message:message backgroundProperty:nil tapHandler:tapHandler completion:nil];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message  backgroundProperty:(id)backGroundProperty tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [[self sharedInstance] showNotificationWithImage:image title:title message:message backgroundProperty:backGroundProperty autoDismiss:YES tapHandler:tapHandler completion:completion];
}


+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message backgroundProperty:(id)backGroundProperty autoDismiss:(BOOL)autoDismiss tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [[self sharedInstance] showNotificationWithImage:image title:title message:message backgroundProperty:backGroundProperty autoDismiss:autoDismiss tapHandler:tapHandler completion:completion];
}

+ (void)dismiss
{
    [[self sharedInstance] dismiss];
}

#pragma mark - instance methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

- (FTNotificationIndicatorView *)notificationView
{
    if (!_notificationView) {
        _notificationView = [[FTNotificationIndicatorView alloc] initWithFrame:CGRectZero];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGuestureRecognized:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureRecognized:)];
        [_notificationView addGestureRecognizer:pan];
        [_notificationView addGestureRecognizer:tap];
    }
    return _notificationView;
}

- (void)onPanGuestureRecognized:(UIPanGestureRecognizer *)sender
{
    if (self.isCurrentlyOnScreen) {
        CGPoint translation = [sender translationInView:[[UIApplication sharedApplication] keyWindow]];
        switch (sender.state) {
            case UIGestureRecognizerStateBegan: case UIGestureRecognizerStateChanged:
                if (translation.y < 0) {
                    [self.notificationView setFrame:CGRectMake(0,translation.y,kFTScreenWidth,self.notificationView.frame.size.height)];
                }
                break;
            case UIGestureRecognizerStateEnded:
                [self dismiss];
                break;
            default:
                break;
        }
    }
}

- (void)onTapGestureRecognized:(UITapGestureRecognizer*)sender{
    if(self.isCurrentlyOnScreen){
        switch (sender.state) {
            case UIGestureRecognizerStateEnded:
                [self dismissOnTapped:YES];
                if(self.tapHandler){
                    self.tapHandler();
                }
                break;
            default:
                break;
        }
    }
}

- (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message backgroundProperty:(id)backgroundProperty autoDismiss:(BOOL)autoDismiss tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.notificationImage = image;
        self.notificationBackgroundImageOrColor = backgroundProperty;
        self.notificationTitle = title;
        self.notificationMessage = message;
        self.isCurrentlyOnScreen = NO;
        self.shouldAutoDismiss = autoDismiss;
        self.tapHandler = tapHandler;
        self.completion = completion;
        
        [self stopDismissTimer];
        [self adjustIndicatorFrame];
    });
}

- (void)dismiss{
    [self dismissOnTapped:NO];
}

- (void)dismissOnTapped:(BOOL)tapped
{
    [self stopDismissTimer];
    [self dismissingNotificationtViewByTap:tapped];
}

- (void)adjustIndicatorFrame
{
    CGSize notificationSize = [self.notificationView getFrameForNotificationViewWithImage:self.notificationImage message:self.notificationMessage andTitle:self.notificationTitle];
    
    [self.notificationView setFrame:CGRectMake(0,- (notificationSize.height),kFTScreenWidth,notificationSize.height)];
    
    [self.notificationView showWithImage:self.notificationImage title:self.notificationTitle message:self.notificationMessage bckgroundPropert:self.notificationBackgroundImageOrColor style:self.indicatorStyle];
    
    [self.backgroundWindow addSubview:self.notificationView];
    
    [self startShowingNotificationView];
}

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isCurrentlyOnScreen) {
            [self adjustIndicatorFrame];
        }
    });
}

- (void)startDismissTimer
{
    [self stopDismissTimer];
    if (!self.shouldAutoDismiss) {
        return;
    }
    CGFloat timeInterval = MAX(self.notificationMessage.length * 0.04 + 0.5, 2.0);
    _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                     target:self
                                                   selector:@selector(dismissingNotificationtView)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (void)stopDismissTimer
{
    if (_dismissTimer) {
        [_dismissTimer invalidate];
        _dismissTimer = nil;
    }
}

- (void)startShowingNotificationView
{
    [UIView animateWithDuration:kFTNotificationDefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [self.notificationView setFrame:CGRectMake(0,0,kFTScreenWidth,self.notificationView.frame.size.height)];
                         
                     } completion:^(BOOL finished) {
                         if (!self.isCurrentlyOnScreen) {
                             [self startDismissTimer];
                         }
                         self.isCurrentlyOnScreen = YES;
                     }];
}

- (void)dismissingNotificationtView{
    [self dismissingNotificationtViewByTap:NO];
}

- (void)dismissingNotificationtViewByTap:(BOOL)tap
{
    [UIView animateWithDuration:kFTNotificationDefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [self.notificationView setFrame:CGRectMake(0,- (self.notificationView.frame.size.height),kFTScreenWidth,(self.notificationView.frame.size.height))];
                         
                     } completion:^(BOOL finished) {
                         self.isCurrentlyOnScreen = NO;
                         [self.notificationView removeFromSuperview];
                         if(self.completion && !tap){
                             self.completion();
                         }
                     }];
}

@end

#pragma mark - FTNotificationIndicatorView

@interface FTNotificationIndicatorView ()

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation FTNotificationIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return self;
}

#pragma mark - getters
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:64.0f/255.0f blue:68.0f/255.0f alpha:1.0];
        [self.contentView addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFTNotificationMargin_X, kFTNotificationStatusBarHeight + kFTNotificationMargin_Y, kFTNotificationImageSize, kFTNotificationImageSize)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFTNotificationMargin_X*2 + kFTNotificationImageSize, kFTNotificationStatusBarHeight, kFTScreenWidth - kFTNotificationMargin_X*2 - kFTNotificationImageSize,  kFTNotificationTitleHeight)];
        _titleLabel.font = kFTNotificationDefaultTitleFont;
        _titleLabel.textColor = kFTNotificationDefaultTextColor;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFTNotificationMargin_X*2 + kFTNotificationImageSize, kFTNotificationStatusBarHeight+kFTNotificationTitleHeight, kFTScreenWidth - kFTNotificationMargin_X*2 - kFTNotificationImageSize, 40)];
        _messageLabel.textColor = kFTNotificationDefaultTextColor;
        _messageLabel.font = kFTNotificationDefaultMessageFont;
        _messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIColor *)getTextColorWithStyle:(UIBlurEffectStyle)style
{
    switch (style) {
        case UIBlurEffectStyleDark:
            return kFTNotificationDefaultTextColor_ForDarkStyle;
            break;
        default:
            return kFTNotificationDefaultTextColor;
            break;
    }
}

#pragma mark - main methods

- (void)showWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message bckgroundPropert:(id)backgroundProperty style:(UIBlurEffectStyle)style
{
    self.effect = [UIBlurEffect effectWithStyle:style];
    
    self.backgroundImageView.image = nil;// [UIImage imageNamed:@"errorbg"];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    
    if ([backgroundProperty isKindOfClass:[UIImage class]]) {
        self.backgroundImageView.image = backgroundProperty;
    }
    else if ([backgroundProperty isKindOfClass:[UIColor class]]) {
         self.backgroundImageView.backgroundColor = backgroundProperty;
    }
    else{
        self.backgroundImageView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:64.0f/255.0f blue:68.0f/255.0f alpha:1.0];

    }
    if (image) {
        self.iconImageView.image = image;
    }
    self.iconImageView.hidden = !(image);
    self.titleLabel.text = title;
    self.messageLabel.text = message;
    self.titleLabel.textColor = [self getTextColorWithStyle:style];
    self.messageLabel.textColor = [self getTextColorWithStyle:style];
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    //self.messageLabel.backgroundColor = [UIColor greenColor];
    
    CGSize messageSize = [self getFrameForNotificationMessageLabelWithImage:self.iconImageView.image message:message andTitle:title];
    
    CGFloat text_X = image ? kFTNotificationMargin_X*2 + kFTNotificationImageSize : kFTNotificationMargin_X;
    
    _iconImageView.frame = CGRectMake(kFTNotificationMargin_X, kFTNotificationStatusBarHeight + kFTNotificationMargin_Y, kFTNotificationImageSize, kFTNotificationImageSize);
    _iconImageView.center = CGPointMake(_iconImageView.center.x, self.contentView.frame.size.height/2);

    
    if (self.titleLabel.text.length > 0) {
        self.titleLabel.frame = CGRectMake(text_X, kFTNotificationStatusBarHeight, kFTScreenWidth - kFTNotificationMargin_X - text_X,  kFTNotificationTitleHeight);
        
        self.messageLabel.frame = CGRectMake(text_X, kFTNotificationStatusBarHeight+kFTNotificationTitleHeight, kFTScreenWidth - kFTNotificationMargin_X - text_X, messageSize.height);
    }
    else{
        self.titleLabel.frame = CGRectMake(text_X, kFTNotificationStatusBarHeight, kFTScreenWidth - kFTNotificationMargin_X - text_X,  0);
        
        self.messageLabel.frame = CGRectMake(text_X, kFTNotificationStatusBarHeight+0, kFTScreenWidth - kFTNotificationMargin_X - text_X, messageSize.height);
        self.messageLabel.center = CGPointMake(self.messageLabel.center.x, self.contentView.frame.size.height/2);

    }
   
    
    if (IS_ARABIC) {
        [self setUpForArabic];
    }
}

-(void)setUpForArabic{
    
    self.titleLabel.transform = CGAffineTransformMakeScale(-1,1);
    self.messageLabel.transform = CGAffineTransformMakeScale(-1,1);
    self.iconImageView.transform = CGAffineTransformMakeScale(-1,1);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.messageLabel.textAlignment = NSTextAlignmentRight;
    self.iconImageView.superview.transform = CGAffineTransformMakeScale(-1,1);
    
}

#pragma mark - getFrameForNotificationMessageLabelWithImage

- (CGSize )getFrameForNotificationMessageLabelWithImage:(UIImage *)image message:(NSString *)notificationMessage andTitle:(NSString *)notificationTitle
{
    float titleLabelheight = 0;
    if (notificationTitle.length > 0) {
        titleLabelheight = kFTNotificationTitleHeight;
    }
    
    CGFloat textWidth = image ? (kFTScreenWidth - kFTNotificationMargin_X*3 - kFTNotificationImageSize) : (kFTScreenWidth - kFTNotificationMargin_X*2);
    
    
    CGRect textSize = [notificationMessage boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT)
                                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName : kFTNotificationDefaultMessageFont}
                                                        context:nil];
    
    //CGSize size = CGSizeMake(textSize.size.width, MAX(MIN(textSize.size.height ,kFTNotificationMaxHeight - titleLabelheight - kFTNotificationStatusBarHeight - kFTNotificationMargin_Y),  kFTNotificationImageSize));
    CGSize size = CGSizeMake(textSize.size.width, MIN(textSize.size.height ,kFTNotificationMaxHeight - titleLabelheight - kFTNotificationStatusBarHeight - kFTNotificationMargin_Y));
    return size;
}

#pragma mark - getFrameForNotificationViewWithImage

- (CGSize )getFrameForNotificationViewWithImage:(UIImage *)image message:(NSString *)notificationMessage andTitle:(NSString *)notificationTitle
{
    float titleLabelheight = 0;
    if (notificationTitle.length > 0) {
        titleLabelheight = kFTNotificationTitleHeight;
    }
    CGSize textSize = [self getFrameForNotificationMessageLabelWithImage:image message:notificationMessage andTitle:notificationTitle];
    CGSize size = CGSizeMake(kFTScreenWidth, MAX(MIN(textSize.height + kFTNotificationMargin_Y + titleLabelheight + kFTNotificationStatusBarHeight,kFTNotificationMaxHeight), kFTNotificationStatusBarHeight + kFTNotificationMargin_Y*2 + kFTNotificationImageSize));
    return size;
}

@end
