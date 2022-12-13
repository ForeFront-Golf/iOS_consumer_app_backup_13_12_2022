//
//  DDMTextField.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMDatePickerView.h"
#import "DDMPickerView.h"

static NSInteger const kTextFieldCancelled = 98;

@interface DDMTextField : UITextField <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property IBInspectable BOOL resetScrollOnResign;
@property IBInspectable BOOL isCurrency;
@property IBInspectable BOOL isDecimalNumber;
@property IBInspectable BOOL isPhoneNumber;
@property IBInspectable BOOL isPickerView;
@property IBInspectable BOOL isDatePickerView;
@property IBInspectable NSString *dateFormat;
@property IBInspectable NSString *pickerTitle;
@property IBInspectable NSInteger maxLength;
@property IBInspectable NSInteger textXInset;
@property IBInspectable UIColor *placeholderColor;

@property IBOutlet UIView *nextField;
@property IBOutlet UIScrollView *scrollView;

//@property (nonatomic,assign) id<UITextFieldDelegate> forwardDelegate;
@property (nonatomic,weak) id forwardDelegate;

@property DDMPickerView *pickerView;
@property DDMDatePickerView *datePickerView;
@property CGPoint previousScrollOffset;

- (IBAction)pickerDoneButtonPressed;
- (IBAction)datePickerDoneButtonPressed;

@end
