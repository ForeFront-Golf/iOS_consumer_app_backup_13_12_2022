//
//  MainView.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "MainView.h"

///////////////////////////////////////////////////////////////////////////////
@implementation MainView

+ (MainView*)view
{
    static MainView *view = nil;
    @synchronized(self)
    {
        if(view == nil)
        {
            view = [[MainView alloc] initFromNib];
            [view setupView];
        }
    }
    return view;
}

+ (void)resignFirstResponder
{
    [[self view].rootTextField becomeFirstResponder];
    [[self view].rootTextField resignFirstResponder];
}

+ (void)setTitleLabel:(NSString*)text
{
    MainView *mainView = [self view];
    [mainView.titleButton setTitle:text forState:UIControlStateNormal];
}

+ (void)setProfileName:(NSString*)name andImage:(UIImage*)image;
{
    MainView *mainView = [self view];
    [mainView.profileButton setTitle:name forState:UIControlStateNormal];
    [mainView.profileImageView.superview setNeedsLayout];
    [mainView.profileImageView.superview layoutIfNeeded];
    [mainView.profileView animateAlphaTo:name != nil withDuration:0.3 andDelay:0];
}

+ (void)setTitleButtonVisibility:(BOOL)visibility
{
    [[self view].titleButton animateAlphaTo:visibility withDuration:0.3 andDelay:0.1];
}

+ (void)setPickerAtRow:(NSInteger)row forObject:(id)object withTitle:(NSString*)title
{
    MainView *mainView = [self view];
    UIPickerView *picker = mainView.picker;
    picker.dataSource = object;
    picker.delegate = object;
    [picker selectRow:row inComponent:0 animated:NO];
    mainView.pickerLabel.text = title;
    [mainView.pickerView animateAlphaTo:1 withDuration:0.3 andDelay:0];
}

+ (void)setActivityIndicatorVisibility:(BOOL)visibility
{
    [self resignFirstResponder];
    
    CGFloat duration = visibility ? 0.2f : 0.4f;
    CGFloat delay = visibility ? 0 : 0.2f;
    CGFloat alpha = visibility ? 0.3 : 0;
    [self view].activityIndicatorLabel.hidden = YES;
    [[self view].activityIndicatorView animateAlphaTo:alpha withDuration:duration andDelay:delay];
}

+ (void)setActivityIndicatorVisibilityGreyBackground:(BOOL)visibility
{
    [self resignFirstResponder];
    
    CGFloat duration = visibility ? 0.2f : 0.4f;
    CGFloat delay = visibility ? 0 : 0.2f;
    CGFloat alpha = visibility ? 0.95 : 0;
    [self view].activityIndicatorLabel.hidden = NO;
    [[self view].activityIndicatorView animateAlphaTo:alpha withDuration:duration andDelay:delay];
}

+ (void)setNavBarVisibility:(BOOL)visibility
{
    MainView *mainView = [self view];
    
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height - 20;
    NSInteger topConstant = visibility ? statusBarHeight : -mainView.navBarView.frame.size.height;
    [mainView animateConstraint:mainView.navBarViewTopConstraint toConstant:topConstant withDuration:0.3 andDelay:0];
    [mainView.navBarView animateAlphaTo:visibility withDuration:0.3 andDelay:0];
}

+ (void)setNavBarColor:(UIColor*)color
{
    MainView *mainView = [self view];
    [mainView.navBarView animateToColor:color withDuration:0.3 andDelay:0];
}

+ (void)setNavBarButton:(NavButtonType)type
{
    MainView *mainView = [self view];
    NSArray *buttonsConstraints = [mainView.navButtonsConstraints subarrayWithRange:NSMakeRange(0, NBT_EmptyLeft + 1)];
    NSArray *buttons = [mainView.navButtons subarrayWithRange:NSMakeRange(0, NBT_EmptyLeft + 1)];
    if(type > NBT_EmptyLeft)
    {
        buttonsConstraints = [mainView.navButtonsConstraints subarrayWithRange:NSMakeRange(NBT_EmptyLeft, NBT_EmptyRight - NBT_EmptyLeft)];
        buttons = [mainView.navButtons subarrayWithRange:NSMakeRange(NBT_EmptyLeft, NBT_EmptyRight - NBT_EmptyLeft)];

    }

    NSLayoutConstraint *buttonConstraint = mainView.navButtonsConstraints[type];
    NSArray *constraints = [buttonsConstraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"constant != -80 && self != %@",buttonConstraint]];
    for(NSLayoutConstraint *constraint in constraints)
    {
        [mainView animateConstraint:constraint toConstant:-80 withDuration:0.3 andDelay:0];
    }
    [mainView animateConstraint:buttonConstraint toConstant:0 withDuration:0.3 andDelay:0.2];
    
    for(UIButton *button in buttons)
    {
        [button animateAlphaTo:0 withDuration:0.3 andDelay:0];
    }
    [mainView.navButtons[type] animateAlphaTo:1 withDuration:0.3 andDelay:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _navButtonsConstraints = _navButtonsConstraints.mutableCopy;
    [_navButtonsConstraints insertObject:[NSLayoutConstraint new] atIndex:NBT_EmptyLeft];
    [_navButtonsConstraints insertObject:[NSLayoutConstraint new] atIndex:NBT_EmptyRight];

    _navButtons = _navButtons.mutableCopy;
    [_navButtons insertObject:[UIButton new] atIndex:NBT_EmptyLeft];
    [_navButtons insertObject:[UIButton new] atIndex:NBT_EmptyRight];
}

- (void)setupView
{
    _navigationController = [UINavigationController getController];
    [_navigationController.view addSubview:self];
    _backgroundTapped = [[UITapGestureRecognizer alloc] initWithTarget:[MainView class] action:@selector(resignFirstResponder)];
    _backgroundTapped.cancelsTouchesInView = false;
    [_navigationController.view addGestureRecognizer:_backgroundTapped];
    
    [self constrainToSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    
    if(hitView == _navBarView)
    {
        return nil;
    }
    
    return hitView;
}

- (IBAction)navButtonPressed:(UIButton*)button
{
    if(![_navigationController.topViewController navButtonPressed:button.tag])
    {
        if(button.tag == NBT_Back)
        {
            [_navigationController.topViewController backButtonPressed];
        }
        else if(button.tag == NBT_Close)
        {
            [_navigationController.topViewController backButtonPressed];
        }
        else if(button.tag == NBT_Settings)
        {
            [PKRevealController showLeftViewController];
        }
    }
}

- (IBAction)pickerCancelButtonPressed
{
    [_pickerView animateAlphaTo:0 withDuration:0.3 andDelay:0];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (IBAction)pickerDoneButtonPressed
{
    [_pickerView animateAlphaTo:0 withDuration:0.3 andDelay:0];
    
    id forwardDelegate = _picker.delegate;
    if([forwardDelegate respondsToSelector:@selector(pickerDidComplete:)])
    {
        [forwardDelegate performSelector:@selector(pickerDidComplete:) withObject:_picker];
    }
}
#pragma clang diagnostic pop

@end
