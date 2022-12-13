//
//  DDMTextField.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMTextField.h"

@implementation DDMTextField

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.inputAssistantItem.leadingBarButtonGroups = @[];       //remove undo buttons / view from keyboard
    self.inputAssistantItem.trailingBarButtonGroups = @[];
    
    NSString *placeholderString = self.placeholder;
    if(!placeholderString)
    {
        placeholderString = @"";
    }
    
    if(_placeholderColor)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderString attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
    }
    
    if(self.keyboardType == UIKeyboardTypeNumberPad)
    {
        [self addToolbarToKeyboard];
    }
    
    if(_isPickerView)
    {
        [self addPickerView];
    }
    
    if(_isDatePickerView)
    {
        [self addDatePickerView];
    }
}

- (void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    [super setDelegate:self];
    _forwardDelegate = delegate;
}

- (BOOL)respondsToSelector:(SEL)selector
{
    bool success = [_forwardDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
    return success;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:_forwardDelegate];
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [super setReturnKeyType:returnKeyType];
    
    if(self.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIToolbar *toolbar = (UIToolbar*)self.inputAccessoryView;
        if(toolbar)
        {
            for(UIBarButtonItem *doneButton in toolbar.items)
            {
                if(doneButton.tag == 1)
                {
                    NSString *returnKeyString = @"Done";
                    if(self.returnKeyType == UIReturnKeyNext)
                    {
                        returnKeyString = @"Next";
                    }
                    doneButton.title = returnKeyString;
                    doneButton.tintColor = [UIColor lightTextColor];
                }
            }
        }
    }
}

- (id)customOverlayContainer
{
    return self;
}

- (void)addToolbarToKeyboard
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320,44.0)];
    toolbar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    NSMutableArray *barItems = @[].mutableCopy;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
    [cancelBtn setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    NSString *returnKeyString = @"Done";
    if(self.returnKeyType == UIReturnKeyNext)
    {
        returnKeyString = @"Next";
    }
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:returnKeyString style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)];
    doneBtn.tag = 1;
    [doneBtn setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    self.inputAccessoryView = toolbar;
}

- (void)addPickerView
{
    _pickerView = [[DDMPickerView alloc] initFromNib];
    _pickerView.frame = [UIScreen mainScreen].bounds;
    _pickerView.picker.dataSource = self;
    _pickerView.picker.delegate = self;
    _pickerView.titleLabel.text = _pickerTitle;
    [_pickerView.cancelButton addTarget:self action:@selector(pickerCancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView.doneButton addTarget:self action:@selector(pickerDoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.inputView = [UIView new];
    self.inputAccessoryView = _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([_forwardDelegate respondsToSelector:@selector(numberOfComponentsInPickerView:)])
    {
        return [_forwardDelegate numberOfComponentsInPickerView:pickerView];
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([_forwardDelegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
    {
        return [_forwardDelegate pickerView:pickerView numberOfRowsInComponent:component];
    }
    return 5;
}

- (IBAction)pickerCancelButtonPressed
{
    if([_forwardDelegate respondsToSelector:@selector(pickerView:cancelledForTextFIeld:)])
    {
        [_forwardDelegate performSelector:@selector(pickerView:cancelledForTextFIeld:) withObject:_pickerView withObject:self];
    }
    [self resignFirstResponder];
}

- (IBAction)pickerDoneButtonPressed
{
    NSString *string = nil;
    for(NSInteger i = 0; i < _pickerView.picker.numberOfComponents; i++)
    {
        NSString *newString = [_forwardDelegate pickerView:_pickerView.picker titleForRow:[_pickerView.picker selectedRowInComponent:i] forComponent:i];
        if(string)
        {
            string = [NSString stringWithFormat:@"%@ %@",string, newString];
        }
        else
        {
            string = newString;
        }
    }
    self.text = string;
    
    [self resignFirstResponder];
    if([_forwardDelegate respondsToSelector:@selector(pickerView:completedForTextFIeld:)])
    {
        [_forwardDelegate performSelector:@selector(pickerView:completedForTextFIeld:) withObject:_pickerView withObject:self];
    }
}

- (void)addDatePickerView
{
    _datePickerView = [[DDMDatePickerView alloc] initFromNib];
    _datePickerView.frame = [UIScreen mainScreen].bounds;
    _datePickerView.picker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    _datePickerView.titleLabel.text = _pickerTitle;
    [_datePickerView.cancelButton addTarget:self action:@selector(datePickerCancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView.doneButton addTarget:self action:@selector(datePickerDoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.inputView = [UIView new];
    self.inputAccessoryView = _datePickerView;
}

- (IBAction)datePickerCancelButtonPressed
{
    if([_forwardDelegate respondsToSelector:@selector(datePickerView:cancelledForTextFIeld:)])
    {
        [_forwardDelegate performSelector:@selector(datePickerView:cancelledForTextFIeld:) withObject:_datePickerView withObject:self];
    }
    [self resignFirstResponder];
}

- (IBAction)datePickerDoneButtonPressed
{
    self.text = [_datePickerView.picker.date toStringWithFormat:_dateFormat];
    
    [self resignFirstResponder];
    if([_forwardDelegate respondsToSelector:@selector(datePickerView:completedForTextFIeld:)])
    {
        [_forwardDelegate performSelector:@selector(datePickerView:completedForTextFIeld:) withObject:_datePickerView withObject:self];
    }
}

- (void)cancelPressed
{
    NSInteger tag = self.tag;
    self.tag = kTextFieldCancelled;
    [self.superview endEditing:YES];
    self.tag = tag;
}

- (void)donePressed
{
    [self textFieldShouldReturn:self];
}

- (BOOL)endEditing:(BOOL)force
{
    return [super endEditing:force];
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if(self.textAlignment == NSTextAlignmentCenter)
    {
        return [super textRectForBounds:bounds];
    }
    else
    {
        return CGRectInset(bounds, _textXInset, 0);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if(self.textAlignment == NSTextAlignmentCenter)
    {
        return [super textRectForBounds:bounds];
    }
    else
    {
        return CGRectInset(bounds, _textXInset, 0);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil userInfo:nil];
    _previousScrollOffset = _scrollView.contentOffset;
    [_scrollView scrollToView:textField];
    
    if(_isDatePickerView)
    {
        NSDate *date = [self.text toDateWithFormat:_dateFormat];
        if(!date)
        {
            date = [NSDate localUTCDate];
        }
        _datePickerView.picker.date = date;
    }
    
    if([_forwardDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [_forwardDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_nextField && [_nextField isKindOfClass:[UITextField class]])
    {
        [self resignFirstResponder];
        bool isFirstResponder = [self isFirstResponder];
        UITextField *nextTextField = (UITextField*)_nextField;
        if(!isFirstResponder && ![nextTextField.text trimWhitespace].length)
        {
            [_nextField becomeFirstResponder];
            [_scrollView scrollToView:_nextField];
        }
    }
    else
    {
        [_scrollView setContentOffset:_previousScrollOffset animated:YES];
    }
    
    if([_forwardDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [_forwardDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    bool returnValue = true;
    if(_maxLength)
    {
        if(self.text.length + string.length > _maxLength && range.length == 0)
        {
            return NO;
        }
    }
    
    if(_isCurrency)
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [formatter setLenient:YES];
        [formatter setGeneratesDecimalNumbers:YES];
        
        NSString *replaced = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSDecimalNumber *amount = (NSDecimalNumber*) [formatter numberFromString:replaced];
        if (amount == nil)
        {
            return NO;                      // Something screwed up the parsing. Probably an alpha character.
        }
        // If the field is empty (the inital case) the number should be shifted to
        // start in the right most decimal place.
        short powerOf10 = 0;
        if ([textField.text isEqualToString:@""])
        {
            powerOf10 = -formatter.maximumFractionDigits;
        }
        // If the edit point is to the right of the decimal point we need to do
        // some shifting.
        else if (range.location + formatter.maximumFractionDigits >= textField.text.length)
        {
            // If there's a range of text selected, it'll delete part of the number
            // so shift it back to the right.
            if (range.length)
            {
                powerOf10 = -range.length;
            }
            // Otherwise they're adding this many characters so shift left.
            else
            {
                powerOf10 = [string length];
            }
        }
        amount = [amount decimalNumberByMultiplyingByPowerOf10:powerOf10];
        
        // Replace the value and then cancel this change.
        textField.text = [formatter stringFromNumber:amount];
        returnValue = false;
    }
    else if(_isDecimalNumber)
    {
        if(string.length)
        {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSMutableString *formattedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""].mutableCopy;
            textField.text = formattedString;
            return NO;
        }
    }
    else if(_isPhoneNumber)
    {
        if(string.length)
        {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSMutableString *formattedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""].mutableCopy;
            
            if(formattedString.length)
            {
                [formattedString insertString:@"(" atIndex:0];
            }
            if(formattedString.length > 3)
            {
                [formattedString insertString:@") " atIndex:4];
            }
            if(formattedString.length > 9)
            {
                [formattedString insertString:@"-" atIndex:9];
            }
            if(formattedString.length < 15)
            {
                textField.text = formattedString;
            }
            return NO;
        }
    }
    if([_forwardDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        return [_forwardDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return returnValue;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_nextField && [_nextField isKindOfClass:[UITextField class]])
    {
        [self resignFirstResponder];
    }
    else
    {
        [self.superview endEditing:YES];
        if(_nextField && [_nextField isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)_nextField;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if([_forwardDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        return [_forwardDelegate textFieldShouldReturn:textField];
    }
    return TRUE;
}

#pragma clang diagnostic pop

@end


