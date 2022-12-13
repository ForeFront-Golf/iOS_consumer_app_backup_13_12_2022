//
//  ImageViewCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-01-13.
//  Copyright © 2016 DDMAppDesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSManagedObject *object;

@end
