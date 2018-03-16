//
//  KATImageUtil.m
//  KATUtil
//
//  Created by Kantice on 15/10/11.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//

#import "KATImageUtil.h"



@implementation KATImageUtil


//UIView转化为图片
+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    
    return image;
}


//CALayer转化为图片
+ (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    
    return image;
}


//保存图片到地址
+ (void)savePngImage:(UIImage *)image withPath:(NSString *)path
{
    //保存图片
    NSData *data=UIImagePNGRepresentation(image);
    
    [data writeToFile:path atomically:YES];
}


//保存jpg图片到地址
+ (void)saveJpgImage:(UIImage *)image withPath:(NSString *)path andQuality:(float)quality
{
    //保存图片
    NSData *data=UIImageJPEGRepresentation(image, quality);
    
    [data writeToFile:path atomically:YES];
}


//将图片缩放到指定的尺寸
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


//将图片等比例缩放到指定的尺寸
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size
{
    //获取图片的高和宽
    float height=image.size.height;
    float width=image.size.width;
    float rate=height/width;//高宽比
    CGSize fitSize;//修正后的尺寸
    
    //以小的为基准
    if(size.height/rate<=width)//以高为基准
    {
        fitSize=CGSizeMake(size.height/rate, size.height);
    }
    else//以宽为基准
    {
        fitSize=CGSizeMake(size.width, size.width*rate);
    }
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(fitSize, NO, [UIScreen mainScreen].scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, fitSize.width, fitSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}




@end
