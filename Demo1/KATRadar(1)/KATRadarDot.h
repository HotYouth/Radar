//
//  KATRadarDot.h
//  KATRadar
//
//  Created by Kantice on 15/10/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达圆点

#import <UIKit/UIKit.h>
#import "KATRadarData.h"


#define RADAR_DOT_STATE_HIDE 0
#define RADAR_DOT_STATE_READY 1
#define RADAR_DOT_STATE_MOVE_IN 2
#define RADAR_DOT_STATE_MOVE_OUT 3
#define RADAR_DOT_STATE_HEARTBEAT 4
#define RADAR_DOT_STATE_STOP 9


#define RADAR_DOT_DURATION_MIN 0.1
#define RADAR_DOT_DURATION_MAX 10.0


//常量
extern NSString * const kKATRadarDotAnimHeartbeat;
extern NSString * const kKATRadarDotAnimMoveIn;
extern NSString * const kKATRadarDotAnimMoveOut;


@class KATRadar;
@class KATRadarDot;

//圆点选中和取消协议
@protocol KATRadarDotDelegate <NSObject>

@optional

//圆点被选中
- (void)selectRadarDot:(KATRadarDot *)dot;

//圆点被取消
- (void)cancelRadarDot:(KATRadarDot *)dot;

@end


@interface KATRadarDot : KATRadarData

@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) BOOL isShow;//是否在显示
@property(nonatomic,assign) BOOL isSelected;//是否被选中

@property(nonatomic,retain) UIColor *color;//颜色
@property(nonatomic,retain) CAShapeLayer *shape;//形状图层
@property(nonatomic,retain) CAShapeLayer *shadow;//阴影层


@property(nonatomic,assign,readonly) int state;//状态
@property(nonatomic,assign,readonly) float angle;//角度（即圆点在圆盘相对圆心的角度）
@property(nonatomic,assign,readonly) CGPoint placement;//落点（即圆点落在圆盘的位置）


@property(nonatomic,assign) id<KATRadarDotDelegate> eventDelegate;//事件代理
@property(nonatomic,assign) KATRadar *radar;//关联的雷达




//构造函数
+ (KATRadarDot *)dotWithSize:(CGSize)size andColor:(UIColor *)color andRadar:(KATRadar *)radar;


//初始化
- (void)initDot;


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


//设置落点和角度，并初始化动画
- (void)setPlacement:(CGPoint)placement;


//点击事件
- (void)dotTap;


//停止并移除动画
- (void)stopAnimation;



//描述
- (NSString *)description;

//销毁
- (void)dealloc;

@end
