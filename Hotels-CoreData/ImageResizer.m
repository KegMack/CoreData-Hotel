//
//  ImageResizer.m
//  Hotels-CoreData
//
//  Created by User on 4/28/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "ImageResizer.h"

//#import <UIKit/UIKit.h>

@implementation ImageResizer

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
