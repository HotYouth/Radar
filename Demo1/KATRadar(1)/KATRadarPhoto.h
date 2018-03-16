//
//  KATRadarPhoto.h
//  KATRadar
//
//  Created by Kantice on 15/10/17.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达照片

#import <UIKit/UIKit.h>
#import "KATRadarData.h"
#import "KATImageUtil.h"


#define RADAR_PHOTO_STATE_HIDE 0
#define RADAR_PHOTO_STATE_READY 1
#define RADAR_PHOTO_STATE_MOVE_IN 2
#define RADAR_PHOTO_STATE_MOVE_OUT 3
#define RADAR_PHOTO_STATE_HEARTBEAT 4
#define RADAR_PHOTO_STATE_STOP 9


#define RADAR_PHOTO_DURATION_MIN 0.1
#define RADAR_PHOTO_DURATION_MAX 10.0


//常量
extern NSString * const kKATRadarPhotoAnimHeartbeat;
extern NSString * const kKATRadarPhotoAnimMoveIn;
extern NSString * const kKATRadarPhotoAnimMoveOut;


@class KATRadar;
@class KATRadarPhoto;
@class KATRadarPhotoSet;

//照片数据协议
@protocol KATRadarPhotoDelegate <NSObject>

@optional

//照片被选中
- (void)selectRadarPhoto:(KATRadarPhoto *)photo;

//照片被取消
- (void)cancelRadarPhoto:(KATRadarPhoto *)photo;


@end


@interface KATRadarPhoto : KATRadarData

@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) BOOL isShow;//是否在显示
@property(nonatomic,assign) BOOL isSelected;//是否被选中
@property(nonatomic,assign) BOOL isCover;//是否是封面

@property(nonatomic,retain) UIImage *image;//图片

@property(nonatomic,retain) UIColor *borderColor;//边界线颜色
@property(nonatomic,assign) float borderWidth;//边界线宽度
@property(nonatomic,assign) float cornerRadius;//照片圆角半径（范围0～0.5）相对size

@property(nonatomic,assign,readonly) int state;//状态
@property(nonatomic,assign,readonly) float angle;//角度（即圆点在圆盘相对圆心的角度）
@property(nonatomic,assign,readonly) CGPoint placement;//落点（即圆点落在圆盘的位置）

@property(nonatomic,retain) CALayer *photo;//照片图层
@property(nonatomic,retain) UILabel *badge;//徽标
@property(nonatomic,retain) CALayer *albums;//相册样式层


@property(nonatomic,assign) id<KATRadarPhotoDelegate> eventDelegate;//事件代理
@property(nonatomic,assign) KATRadar *radar;//关联的雷达
@property(nonatomic,assign) KATRadarPhotoSet *set;//关联的集合




//构造函数
+ (KATRadarPhoto *)photoWithSize:(CGSize)size andImage:(UIImage *)image andRadar:(KATRadar *)radar;


//初始化
- (void)initPhoto;


//心跳
- (void)heartbeatWithScale:(float)scale andDuration:(float)duration;


//移进雷达罗盘
- (void)moveInWithDuration:(float)duration;


//移出雷达罗盘
- (void)moveOutWithDuration:(float)duration;


//选中
- (void)select;


//取消选中
- (void)cancel;


//设置落点和角度
- (void)setPlacement:(CGPoint)placement;


//点击事件
- (void)photoTap;


//停止并移除动画
- (void)stopAnimation;



//描述
- (NSString *)description;

//销毁
- (void)dealloc;

@end
