//
//  ImageResizer.h
//  Hotels-CoreData
//
//  Created by User on 4/28/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageResizer : NSObject

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

@end
