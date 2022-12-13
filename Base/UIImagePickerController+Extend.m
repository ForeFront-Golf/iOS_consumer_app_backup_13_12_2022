//
//  UIImagePickerController+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "UIImagePickerController+Extend.h"

@implementation UIImagePickerController (Extend)

+ (UIImagePickerController*)createImagePickerWithSourceType:(NSNumber*)sourceType andDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = delegate;
    if([UIImagePickerController isSourceTypeAvailable:sourceType.integerValue])
    {
        imagePicker.sourceType = sourceType.integerValue;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [[UINavigationController getController] presentViewController:imagePicker animated:YES completion:nil];
    return imagePicker;
}

@end
