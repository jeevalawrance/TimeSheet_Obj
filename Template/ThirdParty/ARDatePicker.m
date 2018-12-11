//
//  ANDatePicker.m
//  ANDatePicker
//
 //

#import "ARDatePicker.h"
#import "CommonHeaders.h"

NSString * const ANbackgroundColor = @"backgroundColor";
NSString * const ANtextColor = @"textColor";
NSString * const ANtoolbarColor = @"toolbarColor";
NSString * const ANbuttonTextColor = @"buttonColor";
NSString * const ANfont = @"font";
NSString * const ANvalueY = @"yValueFromTop";
NSString * const ANselectedIndex = @"selectedObject";
NSString * const ANtoolbarBackgroundImage = @"toolbarBackgroundImage";
NSString * const ANtextAlignment = @"textAlignment";
NSString * const ANshowsSelectionIndicator = @"showsSelectionIndicator";
NSString * const ANButtonBGColor = @"buttonBGColor";
NSString * const ANCurrentDate = @"currentDate";
NSString * const ANMaxtDate = @"maxtDate";
NSString * const ANMinDate = @"mintDate";
NSString * const ANtoolbarTitle = @"ANtoolbarTitle";
NSString * const ANReturnDateFormat = @"ANReturnDateFormat";

@interface ARDatePicker ()

@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) NSString *dateFormat;
@property (nonatomic, strong) UIView *pickerViewLabelView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;
@property (nonatomic, strong) UIImageView *pickerTopBarImageView;
@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItem;
@property (nonatomic, strong) UIButton *pickerDoneButton;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) NSArray *pickerViewArray;
@property (nonatomic, strong) UIColor *pickerViewTextColor;
@property (nonatomic, strong) UIFont *pickerViewFont;
@property (nonatomic, assign) CGFloat yValueFromTop;
@property (nonatomic, assign) NSInteger pickerViewTextAlignment;
@property (nonatomic, assign) BOOL pickerViewShowsSelectionIndicator;
@property (copy) void (^onDismissCompletion)(NSString *);
@property (copy) NSString *(^objectToStringConverter)(id object);

@end


@implementation ARDatePicker

#pragma mark - Singleton

+ (ARDatePicker*)sharedView {
  static dispatch_once_t once;
  static ARDatePicker *sharedView;
  dispatch_once(&once, ^ { sharedView = [[self alloc] init]; });
  return sharedView;
}


#pragma mark - Show Methods

+(void)showPickerViewInView:(UIView *)view withOptions:(NSDictionary *)options
                 completion:(void (^)(NSString *))completion{
  
  [[self sharedView] initializePickerViewInView:view withOptions:options];
  
  [[self sharedView] setPickerHidden:NO callBack:nil];
  [self sharedView].onDismissCompletion = completion;
  [view addSubview:[self sharedView]];
  
}

+(void)showPickerViewInView:(UIView *)view withOptions:(NSDictionary *)options
    objectToStringConverter:(NSString *(^)(id))converter
                 completion:(void (^)(id))completion {
  
  [self sharedView].objectToStringConverter = converter;
  [self sharedView].onDismissCompletion = completion;
  [[self sharedView] initializePickerViewInView:view withOptions:options];
  [[self sharedView] setPickerHidden:NO callBack:nil];
  [view addSubview:[self sharedView]];
  
}

#pragma mark - Dismiss Methods

+(void)dismissWithCompletion:(void (^)(NSString *))completion{
  [[self sharedView] setPickerHidden:YES callBack:completion];
}

-(void)dismiss{
 [ARDatePicker dismissWithCompletion:self.onDismissCompletion];
}
-(void)cancel{
    [ARDatePicker dismissWithCompletion:nil];
}

+(void)removePickerView{
  [[self sharedView] removeFromSuperview];
}

#pragma mark - Show/hide PickerView methods

-(void)setPickerHidden: (BOOL)hidden
              callBack: (void(^)(NSString *))callBack; {
  
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     
                     if (hidden) {
                       [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
                     } else {
                       [_pickerViewContainerView setAlpha:1.0];
                       [_pickerContainerView setTransform:CGAffineTransformIdentity];
                     }
                   } completion:^(BOOL completed) {
                     if(completed && hidden){
                         [_pickerViewContainerView setAlpha:0.0];

                       [ARDatePicker removePickerView];
                         if (callBack) {
                             callBack([self selectedObject]);
                         }
                       
                     }
                   }];
    
    
    
  
}

#pragma mark - Initialize PickerView

-(void)initializePickerViewInView: (UIView *)view withOptions: (NSDictionary *)options {
  
 
  
  id chosenObject = options[ANselectedIndex];
  NSInteger selectedRow;
  
  if (chosenObject!=nil) {
    selectedRow = [chosenObject intValue];
  }else{
    selectedRow = 0;
  }
  
  
  NSNumber *textAlignment = [[NSNumber alloc] init];
  textAlignment = options[ANtextAlignment];
  //Default value is NSTextAlignmentCenter
  _pickerViewTextAlignment = 1;
  
  if (textAlignment != nil) {
  _pickerViewTextAlignment = [options[ANtextAlignment] integerValue];
  }
  
  BOOL showSelectionIndicator = [options[ANshowsSelectionIndicator] boolValue];
  
  if (!showSelectionIndicator) {
    _pickerViewShowsSelectionIndicator = 1;
  }
  _pickerViewShowsSelectionIndicator = showSelectionIndicator;
  
  UIColor *pickerViewBackgroundColor = [[UIColor alloc] initWithCGColor:[options[ANbackgroundColor] CGColor]];
  UIColor *pickerViewTextColor = [[UIColor alloc] initWithCGColor:[options[ANtextColor] CGColor]];
  UIColor *toolbarBackgroundColor = [[UIColor alloc] initWithCGColor:[options[ANtoolbarColor] CGColor]];
  UIColor *buttonTextColor = [[UIColor alloc] initWithCGColor:[options[ANbuttonTextColor] CGColor]];
  UIColor *buttonBGColor = [[UIColor alloc] initWithCGColor:[options[ANButtonBGColor] CGColor]];
  UIFont *pickerViewFont = [[UIFont alloc] init];
  pickerViewFont = options[ANfont];
  _yValueFromTop = [options[ANvalueY] floatValue];
  
  [self setFrame: view.bounds];
  [self setBackgroundColor:[UIColor clearColor]];
  
  UIImage * toolbarImage = options[ANtoolbarBackgroundImage];
  
  //Whole screen with PickerView and a dimmed background
  _pickerViewContainerView = [[UIView alloc] initWithFrame:view.bounds];
  [_pickerViewContainerView setBackgroundColor: [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
  [self addSubview:_pickerViewContainerView];
  
  //PickerView Container with top bar
  _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, view.frame.size.width, 260.0)];
    
  //Default Color Values (if colors == nil)
  
  //PickerViewBackgroundColor - White
  if (pickerViewBackgroundColor==nil) {
    pickerViewBackgroundColor = [UIColor whiteColor];
  }
  
    if (buttonBGColor==nil) {
        buttonBGColor = [UIColor clearColor];
    }
  //PickerViewTextColor - Black
  if (pickerViewTextColor==nil) {
    pickerViewTextColor = [UIColor blackColor];
  }
  _pickerViewTextColor = pickerViewTextColor;
  
  //ToolbarBackgroundColor - Black
  if (toolbarBackgroundColor==nil) {
    toolbarBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:0.8];
  }
  
  //ButtonTextColor - Blue
  if (buttonTextColor==nil) {
    buttonTextColor = [UIColor colorWithRed:0.000 green:0.486 blue:0.976 alpha:1];
  }
  
  if (pickerViewFont==nil) {
    _pickerViewFont = [UIFont systemFontOfSize:22];
  }
  _pickerViewFont = pickerViewFont;
  
  /*
   //ToolbackBackgroundImage - Clear Color
   if (toolbarBackgroundImage!=nil) {
   //Top bar imageView
   _pickerTopBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
   //[_pickerContainerView addSubview:_pickerTopBarImageView];
   _pickerTopBarImageView.image = toolbarBackgroundImage;
   [_pickerViewToolBar setHidden:YES];
   
   }
   */
  
  _pickerContainerView.backgroundColor = pickerViewBackgroundColor;
  [_pickerViewContainerView addSubview:_pickerContainerView];
  
  
  //Content of pickerContainerView
  
  //Top bar view
  _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
  [_pickerContainerView addSubview:_pickerTopBarView];
  [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
  
  
  _pickerViewToolBar = [[UIToolbar alloc] initWithFrame:_pickerTopBarView.frame];
  [_pickerContainerView addSubview:_pickerViewToolBar];
  
  CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
  //NSLog(@"%f",iOSVersion);
  
  if (iOSVersion < 7.0) {
    _pickerViewToolBar.tintColor = toolbarBackgroundColor;
    //[_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
  }else{
     [_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];

     //_pickerViewToolBar.tintColor = toolbarBackgroundColor;
  
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    _pickerViewToolBar.barTintColor = toolbarBackgroundColor;
    #endif
  }
  
  if (toolbarImage!=nil) {
    [_pickerViewToolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  }
  
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
    UIButton *cancelButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 60, 35);
    cancelButton.backgroundColor = [UIColor clearColor];
    if (IS_ARABIC) {
        [cancelButton setTitle:@"إلغاء" forState:UIControlStateNormal];

    }
    else
    {
       
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];

    }
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    
    //UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIButton *doneButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 45, 35);
    doneButton.backgroundColor = [UIColor clearColor];
    if (IS_ARABIC) {
        [doneButton setTitle:@"موافق" forState:UIControlStateNormal];
        
    }
    else
    {
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        
    }
    
   [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    doneButton.titleLabel.textAlignment = NSTextAlignmentRight;
    doneButton.titleLabel.textColor = [UIColor whiteColor];
    [doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

        if (options[ANReturnDateFormat])
        {
            _dateFormat=options[ANReturnDateFormat];
        }
    if (options[ANtoolbarTitle]) {
        float xOffset=60;
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0,  _pickerViewToolBar.frame.size.width-2*xOffset, _pickerViewToolBar.frame.size.height)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = _pickerViewTextColor;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font=[UIFont systemFontOfSize:13];
        
        //   lblTitle.font=[UIFont boldSystemFontOfSize:14];
        lblTitle.text=options[ANtoolbarTitle];
        UIBarButtonItem *typeField = [[UIBarButtonItem alloc] initWithCustomView:lblTitle];
        _pickerViewToolBar.items = @[cancel,flexibleSpace,typeField,flexibleSpace, _pickerViewBarButtonItem];
        
    }
    else
    {
        _pickerViewToolBar.items = @[cancel,flexibleSpace, _pickerViewBarButtonItem];
        
    }
    
 //_pickerViewToolBar.items = @[cancel,flexibleSpace, _pickerViewBarButtonItem];
   
  [_pickerViewBarButtonItem setTintColor:buttonTextColor];
 
  //[_pickerViewBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Neue" size:23.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
  
      [cancel setTintColor:buttonTextColor];
 
    

    
    
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, view.frame.size.width, 216.0)];
    _pickerView.datePickerMode = UIDatePickerModeDate;
    _pickerView.hidden = NO;
    if (options[ANCurrentDate])
    {
        _pickerView.date = options[ANCurrentDate];
    }
   
    if (options[ANMaxtDate])
    {
        [_pickerView setMaximumDate: options[ANMaxtDate]];
    }
    if (options[ANMinDate])
    {
        [_pickerView setMinimumDate:options[ANMinDate]];
    }
   
    
    
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];

   
  
   // [_pickerView addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    [_pickerContainerView addSubview:_pickerView];
    
    
}
- (void)LabelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
  
    NSLog(@"date is ---->%@",[NSString stringWithFormat:@"%@",
                              [df stringFromDate:_pickerView.date]]);
}




- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component {
  if (self.objectToStringConverter == nil){
    return [_pickerViewArray objectAtIndex:row];
  } else{
    return (self.objectToStringConverter ([_pickerViewArray objectAtIndex:row]));
  }
}



- (id)selectedObject {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
     //df.dateStyle = NSDateFormatterMediumStyle;
    if (!_dateFormat)
    {
        _dateFormat=@"dd-MMMM-YYYY";
     }
    
      [df setDateFormat:_dateFormat];
    return [NSString stringWithFormat:@"%@",
            [df stringFromDate:_pickerView.date]];
  }





@end
