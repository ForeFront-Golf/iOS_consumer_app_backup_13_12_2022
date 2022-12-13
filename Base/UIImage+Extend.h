//
//  UIImage+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

- (CGSize)aspectFitSizeForBounds:(CGSize)boundingSize;
- (CGSize)aspectFillSizeForBounds:(CGSize)boundingSize;
- (UIImage*)addImage:(UIImage *)image withFrame:(CGRect)frame;
- (UIImage *)addCornerRadius:(CGFloat)radius;
- (UIImage *)resizeAndCropTo:(CGSize)size withCornerRadius:(CGFloat)cornerRadius;
- (UIImage *)resizeTo:(CGSize)size;
- (UIImage*)changeSizeTo:(CGSize)size;          //maintains aspect and adds bars.
- (UIImage *)cropToRect:(CGRect)cropRect;
- (UIImage*)cropCenterSquare;
- (UIImage *)getImageInScrollView:(UIScrollView*)scrollView;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyMiddleDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius iterationsCount:(NSInteger)iterationsCount tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
