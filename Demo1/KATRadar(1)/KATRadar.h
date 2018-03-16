//
//  KATRadar.h
//  Radar
//
//  Created by Kantice on 15/10/13.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KATArray.h"
#import "KATRadarDot.h"
#import "KATRadarDotSet.h"
#import "KATRadarPhoto.h"
#import "KATRadarPhotoSet.h"




#define RADAR_DIRECTION_CLOCKWISE 1
#define RADAR_DIRECTION_ANTICLOCKWISE -1


#define RADAR_STYLE_START_COLOR_DARK 0
#define RADAR_STYLE_START_COLOR_LIGHT 1


#define RADAR_SCAN_STATE_STOP 0
#define RADAR_SCAN_STATE_PAUSE 1
#define RADAR_SCAN_STATE_RUN 2



//雷达数据选中和取消协议
@protocol KATRadarDataDelegate <NSObject>

@optional

//雷达数据被选中
- (void)dataSelectInRadar:(KATRadar *)radar;

//已经被选中的雷达数据被取消选中（点击被选中的数据）
- (void)selectedDataCancelInRadar:(KATRadar *)radar;

//雷达数据被取消选择（空点击）
- (void)dataCancelInRadar:(KATRadar *)radar;

@end




@interface KATRadar : UIView <KATRadarDotDelegate,KATRadarPhotoDelegate>


//事件代理
@property(nonatomic,assign) id<KATRadarDataDelegate> eventDelegate;


//数据
@property(nonatomic,retain) KATArray *arrayDot;//圆点数组
@property(nonatomic,retain) KATArray *arrayDotSet;//圆点集合数组
@property(nonatomic,retain) KATArray *arrayPhoto;//照片数组
@property(nonatomic,retain) KATArray *arrayPhotoSet;//照片集合数组
@property(nonatomic,retain) KATArray *arrayAdd;//添加队列数组
@property(nonatomic,retain) KATArray *arrayRemove;//删除队列数组



//扫描仪
@property(nonatomic,retain) UIView *scanner;//扫描仪(整体)，定义为UIVew是为了关闭隐式动画
@property(nonatomic,retain) CAShapeLayer *scannerClockwise;//扫描仪（顺时针方向）
@property(nonatomic,retain) CAShapeLayer *scannerAnticlockwise;//扫描仪(逆时针方向)
@property(nonatomic,assign) float scanAngle;//扫描的角度
@property(nonatomic,assign) int scanDirection;//扫描方向


//扫描动画(该动画以系统刷新刷新频率为基准，不作自定义动画帧率，即只根据系统画面刷新频率做次数计算，不以时间为单位计算)，scanCycle与scanFrameInterval共同决定了扫描仪旋转一周的时间，但该时间也受系统刷新频率影响，一般在流畅的情况下系统刷新频率为60帧
@property(nonatomic,assign) int scanCycleFrame;//扫描仪旋转一周的帧数（每帧旋转的角度为PI*2/帧数）
@property(nonatomic,assign) int scanFrameInterval;//扫描动画时间间隔，即系统刷新频率的间隔，如该值为2，则系统每2次刷新将执行一次旋转动画
@property(nonatomic,assign) BOOL isScanPause;//扫描是否暂停
@property(nonatomic,assign) BOOL isScanStop;//扫描是否停止
@property(nonatomic,assign) int scanState;//扫描状态
@property(nonatomic,assign) int scanFrameTimeCount;//扫描帧次计数器
@property(nonatomic,retain) CADisplayLink *scanTimer;//扫描定时器



//罗盘
@property(nonatomic,retain) CAShapeLayer *compass;
@property(nonatomic,assign) CGPoint centerPoint;//罗盘圆心



//雷达样式

//半径和宽度
@property(nonatomic,assign) float radiusRadar;//雷达半径(size的一半，自动计算)
@property(nonatomic,assign) float radiusInner;//内圆半径（雷达内部包含圆心位置），范围0~1(雷达半径的百分比，包含内层圆环)
@property(nonatomic,assign) float radiusMiddle;//中圆半径（雷达中间位置），范围0~1(雷达半径的百分比，包含中层圆环)
@property(nonatomic,assign) float radiusOuter;//外圆半径（雷达外部位置），范围0~1(雷达半径的百分比，包含外层圆环)
@property(nonatomic,assign) float radiusRing;//圆环半径（内，中，外层保持一致），范围0～1（雷达半径的百分比）
@property(nonatomic,assign) float radiusScanner;//扫描仪半径，范围0～1（雷达半径的百分比）
@property(nonatomic,assign) float radiusOffsetScanner;//扫描仪半径偏移（起点位置），范围0～1（雷达半径的百分比）

//宽,高,弧
@property(nonatomic,assign) float arcArrow;//箭头三角弧度（半个三角），范围0~PI/2
@property(nonatomic,assign) float heightArrow;//箭头三角高度，范围0～1（雷达半径的百分比）
@property(nonatomic,assign) float widthBorderLine;//边界线宽度
@property(nonatomic,assign) int numberOfSector;//扇形区块数量，每块扇形的弧度为PI*2/num
@property(nonatomic,assign) float arcScanner;//扫描仪弧度，范围0~PI*2
@property(nonatomic,assign) float widthScannerLine;//扫描仪基准线宽度

//颜色
@property(nonatomic,retain) UIColor *colorBorderLine;//边界线颜色
@property(nonatomic,retain) UIColor *colorSectorInner;//内层扇形区块（中心圆）颜色
@property(nonatomic,retain) UIColor *colorSectorMiddle;//中层扇形区块颜色
@property(nonatomic,retain) UIColor *colorSectorOuter;//外层扇形区块颜色
@property(nonatomic,retain) UIColor *colorRingInnerLight;//内层圆环亮色
@property(nonatomic,retain) UIColor *colorRingInnerDark;//内层圆环暗色
@property(nonatomic,retain) UIColor *colorRingMiddleLight;//中层圆环亮色
@property(nonatomic,retain) UIColor *colorRingMiddleDark;//中层圆环暗色
@property(nonatomic,retain) UIColor *colorRingOuterLight;//外层圆环(包括箭头)亮色
@property(nonatomic,retain) UIColor *colorRingOuterDark;//外层圆环(包括箭头)暗色
@property(nonatomic,retain) UIColor *colorScannerLine;//扫描仪基准线颜色
@property(nonatomic,retain) UIColor *colorScannerArea;//扫描仪扇形区域颜色


//其他样式
@property(nonatomic,retain) NSString *styleLineJoin;//连接线样式
@property(nonatomic,assign) float styleStartAngle;//开始绘制的角度
@property(nonatomic,assign) int styleStartColor;//开始填充颜色（亮色或暗色）
@property(nonatomic,assign) BOOL hasArrow;//是否包含箭头


//圆点数据样式
@property(nonatomic,assign) CGPoint dotShadowOffset;//圆点阴影偏移
@property(nonatomic,retain) UIColor *dotShadowColor;//圆点阴影颜色
@property(nonatomic,retain) UIColor *dotBorderColor;//圆点边界线颜色
@property(nonatomic,assign) float dotBorderWidth;//圆点边界线宽度
@property(nonatomic,assign) float dotRadius;//圆点半径（范围0～0.5）相对size
@property(nonatomic,assign) BOOL hasDotShadow;//圆点是否有阴影
@property(nonatomic,assign) float dotHeartbeatTime;//圆点心跳时长
@property(nonatomic,assign) float dotHeartbeatScale;//圆点心跳缩放尺寸
@property(nonatomic,assign) float dotMoveInTime;//圆点进入动画时长
@property(nonatomic,assign) float dotMoveOutTime;//圆点出去动画时长
@property(nonatomic,assign) int dotSetExecuteFrequency;//圆点集合执行频率，即扫描N帧次执行一次（执行内容即圆点进出罗盘事件）


//照片数据样式
@property(nonatomic,retain) UIColor *photoBadgeTextColor;//照片数据徽标字体颜色
@property(nonatomic,retain) UIColor *photoBadgeBgColor;//照片数据徽标背景色
@property(nonatomic,assign) CGSize photoBadgeSize;//照片数据徽标尺寸(以照片宽高为基准的比例)，位置在右上角
@property(nonatomic,assign) float photoBadgeFontSize;//照片数据徽标字体大小（以徽标高度为基准的比例，居中模式）
@property(nonatomic,assign) int photoBadgeNumberMax;//照片数据徽标数字最大值
@property(nonatomic,assign) float photoBadgeCornerRadius;//照片数据徽标圆角半径(以徽标高度为基准的比例)
@property(nonatomic,assign) float photoBadgeBorderWidth;//照片数据徽标边界线宽度(选中时)
@property(nonatomic,assign) float photoAlbumsOffset;//照片封面相册形状偏移量
@property(nonatomic,assign) float photoAlbumsBorderWidth;//照片封面相册形状边界线宽
@property(nonatomic,retain) UIColor *photoAlbumsBorderColor;//照片封面相册形状边界线颜色
@property(nonatomic,retain) UIColor *photoAlbumsBgColor;//照片封面相册形状背景颜色
@property(nonatomic,assign) float photoHeartbeatTime;//照片心跳时长
@property(nonatomic,assign) float photoHeartbeatScale;//照片心跳缩放尺寸
@property(nonatomic,assign) float photoMoveInTime;//照片进入动画时长
@property(nonatomic,assign) float photoMoveOutTime;//照片出去动画时长
@property(nonatomic,assign) int photoSetExecuteFrequency;//照片集合执行频率，即扫描N帧次执行一次（执行内容即照片进出罗盘事件）




//构造，frame不包含箭头区域
+ (KATRadar *)radarWithFrame:(CGRect)frame;


//初始化雷达
- (void)initRadar;


//配置数据集合
//格式：*,编号(集合标识),类型(0圆点，1照片),容量(最多容纳的数据个数),落点x坐标,落点y坐标,宽度范围w,高度范围h,*
//例子：*,1,0,100,20.0,30.0,30,40,*,2,1,50,220.0,200.0,30.0,30.0,*
- (void)configSet:(NSString *)config;


//开始扫描
- (void)scanStart;

//暂停扫描
- (void)scanPause;

//恢复扫描（取消暂停）
- (void)scanResume;

//停止扫描（停止后需要重新启动）
- (void)scanStop;

//改变扫描方向
- (void)changeScanDirection:(int)direction;


//添加数据到随机的集合中
- (BOOL)addData:(KATRadarData *)data;

//添加数据到指定的集合中
- (BOOL)addData:(KATRadarData *)data toSet:(int)setNum;

//删除数据
- (BOOL)removeData:(KATRadarData *)data;

//通过obj删除数据
- (void)removeDataByObject:(id)object;

//通过num删除数据
- (void)removeDataByNum:(int)num;

//通过数值范围删除数据
- (void)removeDataFromValue:(double)fValue toValue:(double)tValue;

//清空添加队列
- (void)clearAddQueue;

//清空删除队列
- (void)clearRemoveQueue;

//清除雷达上的所有数据（包括队列里的）
- (void)clearData;


//获取所有数据
- (NSArray *)getAllData;

//获取所有圆点数据
- (NSArray *)getAllDotData;

//获取所有照片数据
- (NSArray *)getAllPhotoData;

//获取选中的数据
- (NSArray *)getSelectedData;


//销毁
- (void)dealloc;

@end
