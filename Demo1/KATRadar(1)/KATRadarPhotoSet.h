//
//  KATRadarPhotoSet.h
//  KATRadar
//
//  Created by Kantice on 15/10/17.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达照片集合

#import <UIKit/UIKit.h>

#import "KATRadarPhoto.h"
#import "KATArray.h"
#import "KATQueue.h"


@class KATRadar;

@interface KATRadarPhotoSet : NSObject

@property(nonatomic,assign) int num;//数据标识号
@property(nonatomic,retain) NSString *message;//携带的信息
@property(nonatomic,retain) id object;//携带的对象
@property(nonatomic,assign) double value;//携带的数值
@property(nonatomic,assign) CGPoint placement;//落点中心
@property(nonatomic,assign) CGSize area;//范围
@property(nonatomic,assign) int capacity;//容量
@property(nonatomic,assign) BOOL isSelected;//是否被选中

@property(nonatomic,retain) KATArray *photos;//圆点数组
@property(nonatomic,retain) KATQueue *addQueue;//添加队列
@property(nonatomic,retain) KATQueue *removeQueue;//删除队列


@property(nonatomic,assign) KATRadar *radar;//关联的雷达

@property(nonatomic,retain) KATRadarPhoto *cover;//封面照片





//构造函数
+ (KATRadarPhotoSet *)photoSetWithPlacement:(CGPoint)placement andArea:(CGSize)area andCapacity:(int)capacity andRadar:(KATRadar *)radar;


//选中集合
- (void)selectSet;

//取消选中
- (void)cancelSet;

//放入照片（到添加队列）
- (BOOL)addPhoto:(KATRadarPhoto *)photo;

//删除照片（到删除队列）
- (BOOL)removePhoto:(KATRadarPhoto *)photo;

//执行队列中的添加与删除操作(先添加操作，后删除操作)
- (void)execute;

//设置封面
- (void)setCoverWithPhoto:(KATRadarPhoto *)photo;

//更新封面（徽标和重叠）
- (void)updateCover;

//描述
- (NSString *)description;

//销毁
- (void)dealloc;

@end
