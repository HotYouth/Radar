//
//  KATRadarData.h
//  KATRadar
//
//  Created by Kantice on 15/10/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达数据（圆点和照片的基类）

#import <UIKit/UIKit.h>


#define RADAR_DATA_TYPE_DOT 0
#define RADAR_DATA_TYPE_PHOTO 1


@interface KATRadarData : UIView

@property(nonatomic,assign) int num;//数据标识号
@property(nonatomic,assign) int type;//类型
@property(nonatomic,retain) NSString *message;//携带的信息
@property(nonatomic,retain) id object;//携带的对象
@property(nonatomic,assign) double value;//携带的数值


//描述
- (NSString *)description;

//销毁
- (void)dealloc;

@end
