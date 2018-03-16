//
//  KATImageUtil.h
//  KATUtil
//
//  Created by Kantice on 15/10/11.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  图片工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface KATImageUtil : NSObject


/**UIView转化为图片
 */
+ (UIImage *)imageFromView:(UIView *)view;


/**CALayer转化为图片
 */
+ (UIImage *)imageFromLayer:(CALayer *)layer;


/**保存png图片到地址
 */
+ (void)savePngImage:(UIImage *)image withPath:(NSString *)path;


/**保存jpg图片到地址(质量为0~1)
 */
+ (void)saveJpgImage:(UIImage *)image withPath:(NSString *)path andQuality:(float)quality;


/**将图片缩放到指定的尺寸
 */
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;


/**将图片等比例缩放到指定的尺寸
 */
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size;




@end
