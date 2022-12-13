//
//  UIImage+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Accelerate/Accelerate.h>

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

- (CGSize)aspectFitSizeForBounds:(CGSize)boundingSize
{
    float mW = boundingSize.width / self.size.width;
    float mH = boundingSize.height / self.size.height;
    if(mH < mW)
    {
        boundingSize.width = floorf(boundingSize.height / self.size.height * self.size.width);
    }
    else if(mW < mH)
    {
        boundingSize.height = floorf(boundingSize.width / self.size.width * self.size.height);
    }
    return boundingSize;
}

- (CGSize)aspectFillSizeForBounds:(CGSize)boundingSize
{
    float mW = boundingSize.width / self.size.width;
    float mH = boundingSize.height / self.size.height;
    if(mH > mW)
    {
        boundingSize.width = floorf(boundingSize.height / self.size.height * self.size.width);
    }
    else if(mW > mH)
    {
        boundingSize.height = floorf(boundingSize.width / self.size.width * self.size.height);
    }
    return boundingSize;
}

- (UIImage*)addImage:(UIImage *)image withFrame:(CGRect)frame
{
    CGRect rect1 = CGRectMake(0, 0, self.size.width, self.size.height);
    // Begin context
    UIGraphicsBeginImageContextWithOptions(rect1.size, NO, 0);
    
    // draw images
    [self drawInRect:rect1];
    [image drawInRect:frame];
    
    // grab context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)addCornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    //    UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
    //    [[UIColor redColor] set]; //set the desired background color
    //    UIRectFill(CGRectMake(0.0, 0.0, temp.size.width, temp.size.height)); //fill the bitmap context
    
    const CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius] addClip];
    [self drawInRect:bounds];
    UIImage* roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedCornerImage;
}
- (UIImage *)resizeAndCropTo:(CGSize)size withCornerRadius:(CGFloat)cornerRadius
{
    UIImage *scaledImage = [self resizeTo:size];
    UIImage *croppedImage = [scaledImage cropFromCenterToSize:size];
    UIImage *roundedCornersImage = [croppedImage addCornerRadius:cornerRadius];
    return roundedCornersImage;
}

- (UIImage *)resizeTo:(CGSize)size
{
    CGSize aspectRatioSize = [self aspectFillSizeForBounds:size];
    UIGraphicsBeginImageContext(aspectRatioSize);
    [self drawInRect:CGRectMake(0, 0, aspectRatioSize.width, aspectRatioSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage*)changeSizeTo:(CGSize)size
{
    CGRect scaledImageRect = CGRectZero;
    CGFloat aspectWidth = size.width / self.size.width;
    CGFloat aspectHeight = size.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) * 0.5f;
    scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) * 0.5f;
    UIGraphicsBeginImageContextWithOptions( size, YES, 0 );
    
//    [[UIColor whiteColor] set];
//    UIRectFill(CGRectMake(0.0, 0.0, kAttachmentCropFrame.size.width, kAttachmentCropFrame.size.height));
    
    [self drawInRect:scaledImageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)cropFromCenterToSize:(CGSize)size
{
    CGPoint center = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    CGRect cropRect = CGRectMake(center.x - size.width * 0.5, center.y - size.height * 0.5, size.width, size.height);
    return [self cropToRect:cropRect];
}

- (UIImage*)cropToRect:(CGRect)cropRect
{
    CGAffineTransform rectTransform;
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(cropRect, rectTransform));
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage*)cropCenterSquare
{
    const CGFloat MAX_SIZE_DIFF = 5;
    if(fabs(self.size.width - self.size.height) < MAX_SIZE_DIFF)
    {
        return self;
    }
    
    CGFloat squareDistance = MIN(self.size.width, self.size.height);
    CGRect cropRect = CGRectMake((self.size.width - squareDistance) * 0.5, (self.size.height - squareDistance) * 0.5, squareDistance, squareDistance);
    return [self cropToRect:cropRect];
}

- (UIImage*)getImageInScrollView:(UIScrollView*)scrollView
{
    CGFloat zoomScale = 1.0f / scrollView.zoomScale;
    CGFloat widthPercent = scrollView.bounds.origin.x / scrollView.bounds.size.width * zoomScale;
    CGFloat heightPercent = scrollView.bounds.origin.y / scrollView.bounds.size.height * zoomScale;
    
    CGRect cropFrame;
    cropFrame.origin.x = self.size.width * widthPercent;
    cropFrame.origin.y = self.size.height * heightPercent;
    cropFrame.size.width = self.size.width / scrollView.zoomScale;
    cropFrame.size.height = self.size.height / scrollView.zoomScale;
    CGFloat aspectRatio = self.size.width / self.size.height;
    CGFloat scrollViewRatio = scrollView.frame.size.width / scrollView.frame.size.height;
    CGFloat ratio = aspectRatio / scrollViewRatio;
    if(ratio > 1)
    {
        cropFrame.origin.x /= ratio;
        cropFrame.size.width /= ratio;
    }
    else
    {
        cropFrame.origin.y *= ratio;
        cropFrame.size.height *= ratio;
    }
    
    return [self cropToRect:cropFrame];
}

- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyMiddleDarkEffect
{
    UIColor *tintColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:.8];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:0.0 maskImage:nil];
}

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    return [self applyBlurWithRadius:blurRadius iterationsCount:3 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius iterationsCount:(NSInteger)iterationsCount tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // check pre-conditions
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        BOOL resultImageAtInputBuffer = YES;
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            for (int i = 0; i+1 < iterationsCount; i+=2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            }
            if (iterationsCount % 2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                resultImageAtInputBuffer = NO;
            }
        }
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur ^ resultImageAtInputBuffer) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // set up output context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // draw base image
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // draw effect image
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // add in color tint
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // output image is ready
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;

}

@end
