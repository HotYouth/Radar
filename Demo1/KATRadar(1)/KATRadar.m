//
//  KATRadar.m
//  Radar
//
//  Created by Kantice on 15/10/13.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//

#import "KATRadar.h"



@implementation KATRadar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (KATRadar *)radarWithFrame:(CGRect)frame
{
    KATRadar *rader=[[[self alloc] init] autorelease];
    rader.frame=frame;
    [rader initData];
    
    return rader;
}


//初始化数据，设置默认值等
- (void)initData
{
    self.backgroundColor=[UIColor clearColor];
    
    //代理
    self.eventDelegate=nil;
    
    //数据
    self.arrayDot=[KATArray arrayWithCapacity:2000];
    self.arrayDotSet=[KATArray arrayWithCapacity:100];
    self.arrayPhoto=[KATArray arrayWithCapacity:2000];
    self.arrayPhotoSet=[KATArray arrayWithCapacity:100];
    self.arrayAdd=[KATArray arrayWithCapacity:2000];
    self.arrayRemove=[KATArray arrayWithCapacity:2000];
    
    
    //扫描仪
    _scanAngle=0;//初始角度
    _scanDirection=RADAR_DIRECTION_ANTICLOCKWISE;//扫描旋转角度
    
    //圆心
    _centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //扫描动画
    _scanCycleFrame=180;
    _scanFrameInterval=1;
    _isScanPause=NO;
    _isScanStop=YES;
    _scanFrameTimeCount=0;
    _scanState=RADAR_SCAN_STATE_STOP;
    
    //半径
    _radiusRadar=self.bounds.size.height/2;//以高度为基准
    _radiusInner=0.3f;
    _radiusMiddle=0.65f;
    _radiusOuter=1.0f;
    _radiusRing=0.06f;
    _radiusOffsetScanner=_radiusInner-_radiusRing;
    _radiusScanner=1.0f;
    
    //宽,高,弧
    _arcArrow=M_PI*0.02f;
    _heightArrow=0.05f;
    _widthBorderLine=0.5f;
    _numberOfSector=8;
    _arcScanner=M_PI*0.25f;
    _widthScannerLine=1.0f;
    
    //颜色
    self.colorBorderLine=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.6];
    self.colorSectorInner=[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.6];
    self.colorSectorMiddle=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:0.6];
    self.colorSectorOuter=[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.6];
    self.colorRingInnerDark=[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:0.6];
    self.colorRingInnerLight=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.6];
    self.colorRingMiddleDark=[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.6];
    self.colorRingMiddleLight=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.6];
    self.colorRingOuterDark=[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:0.6];
    self.colorRingOuterLight=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.6];
    self.colorScannerLine=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0f];
    self.colorScannerArea=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.3f];
    
    //其他样式
    _styleLineJoin=kCALineJoinRound;
    _styleStartColor=RADAR_STYLE_START_COLOR_DARK;
    _styleStartAngle=M_PI*1.5;
    _hasArrow=YES;
    
    
    //圆点数据样式
    _dotShadowOffset=CGPointMake(1.0, 1.0);
    self.dotShadowColor=[UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    _hasDotShadow=YES;
    self.dotBorderColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:237/255.0 alpha:1.0f];
    _dotBorderWidth=1.0f;
    _dotRadius=0.4;
    _dotHeartbeatTime=0.2f;
    _dotHeartbeatScale=1.2f;
    _dotMoveInTime=2.0f;
    _dotMoveOutTime=1.0f;
    _dotSetExecuteFrequency=10;
    
    
    //照片数据样式
    self.photoBadgeTextColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:237/255.0 alpha:1.0f];
    self.photoBadgeBgColor=[UIColor colorWithRed:255/255.0 green:56/255.0 blue:36/255.0 alpha:1.0f];
    _photoBadgeSize=CGSizeMake(0.4, 0.4);
    _photoBadgeFontSize=0.6f;
    _photoBadgeNumberMax=99;
    _photoBadgeCornerRadius=0.5f;
    _photoBadgeBorderWidth=1.0f;
    _photoAlbumsOffset=1.5f;
    _photoAlbumsBorderWidth=0.5f;
    self.photoAlbumsBorderColor=[UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    self.photoAlbumsBgColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:237/255.0 alpha:1.0f];
    _photoHeartbeatTime=0.2f;
    _photoHeartbeatScale=1.2f;
    _photoMoveInTime=2.0f;
    _photoMoveOutTime=1.0f;
    _photoSetExecuteFrequency=10;
    
    
    //默认的圆点与照片集合位置（2，5，8，11点钟为照片位置，其余为圆点位置）
    for(int i=0;i<12;i++)
    {
        if(i%3==2)//照片位置
        {
            KATRadarPhotoSet *set=[KATRadarPhotoSet photoSetWithPlacement:CGPointMake(_radiusRadar+_radiusRadar*_radiusMiddle*cosf(i*M_PI*2.0/12.0), _radiusRadar+_radiusRadar*_radiusMiddle*sinf(i*M_PI*2.0/12.0)) andArea:CGSizeMake(0.75*_radiusRadar*(1.0-_radiusMiddle)*cosf(M_PI*2.0/12.0), 0.75*_radiusRadar*(1.0-_radiusMiddle)*sinf(M_PI*2.0/12.0)) andCapacity:200 andRadar:self];
            set.num=i<=9?i+3:i-9;//设置num为时钟方位
            
            [_arrayPhotoSet put:set];
        }
        else//圆点位置
        {
            
            KATRadarDotSet *set=[KATRadarDotSet dotSetWithPlacement:CGPointMake(_radiusRadar+_radiusRadar*_radiusMiddle*cosf(i*M_PI*2.0/12.0), _radiusRadar+_radiusRadar*_radiusMiddle*sinf(i*M_PI*2.0/12.0)) andArea:CGSizeMake(_radiusRadar*(1.0-_radiusMiddle)*cosf(M_PI*2.0/12.0), _radiusRadar*(1.0-_radiusMiddle)*sinf(M_PI*2.0/12.0)) andCapacity:200 andRadar:self];
            set.num=i<=9?i+3:i-9;//设置num为时钟方位
            
            [_arrayDotSet put:set];
        }
    }
    
    
    //点击事件设置
    UITapGestureRecognizer *singleTap=nil;
    singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    singleTap.numberOfTapsRequired=1;//点击次数
    [self addGestureRecognizer:singleTap];//添加点击事件
    [singleTap release];
}


//初始化雷达
- (void)initRadar
{
    //绘制罗盘
    self.compass=[CAShapeLayer layer];
    UIBezierPath *compassPath=[[UIBezierPath alloc] init];
    [compassPath addArcWithCenter:_centerPoint radius:_radiusRadar startAngle:0 endAngle:M_PI*2 clockwise:YES];
    _compass.strokeColor=[UIColor clearColor].CGColor;
    _compass.fillColor=[UIColor clearColor].CGColor;
    _compass.lineWidth=0;
    _compass.lineJoin=_styleLineJoin;
    _compass.path=compassPath.CGPath;
    [self.layer addSublayer:_compass];
    [compassPath release];
    
    //绘制内圆
    CAShapeLayer *innerSector=[CAShapeLayer layer];
    UIBezierPath *innerSectorPath=[[UIBezierPath alloc] init];
    [innerSectorPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusInner-_radiusRing) startAngle:0 endAngle:M_PI*2 clockwise:YES];
    innerSector.strokeColor=[UIColor clearColor].CGColor;
    innerSector.fillColor=_colorSectorInner.CGColor;
    innerSector.lineWidth=0;
    innerSector.lineJoin=_styleLineJoin;
    innerSector.path=innerSectorPath.CGPath;
    [_compass addSublayer:innerSector];
    [innerSectorPath release];
    
    //顺时针方向绘制
    for(int i=0;i<_numberOfSector;i++)
    {
        //绘制内环
        CAShapeLayer *innerRing=[CAShapeLayer layer];
        UIBezierPath *innerRingPath=[[UIBezierPath alloc] init];
        [innerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusInner) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
        [innerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusInner-_radiusRing)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusInner-_radiusRing)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
        [innerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusInner-_radiusRing) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
        [innerRingPath closePath];
        innerRing.strokeColor=_colorBorderLine.CGColor;
        innerRing.lineWidth=_widthBorderLine;
        innerRing.fillColor=(i+_styleStartColor)%2==RADAR_STYLE_START_COLOR_DARK?_colorRingInnerDark.CGColor:_colorRingInnerLight.CGColor;
        innerRing.lineJoin=_styleLineJoin;
        innerRing.path=innerRingPath.CGPath;
        [_compass addSublayer:innerRing];
        [innerRingPath release];

        
        //绘制中扇区
        CAShapeLayer *middleSector=[CAShapeLayer layer];
        UIBezierPath *middleSectorPath=[[UIBezierPath alloc] init];
        [middleSectorPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusMiddle-_radiusRing) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
        [middleSectorPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusInner)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusInner)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
        [middleSectorPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusInner) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
        [middleSectorPath closePath];
        middleSector.strokeColor=_colorBorderLine.CGColor;
        middleSector.lineWidth=_widthBorderLine;
        middleSector.fillColor=_colorSectorMiddle.CGColor;
        middleSector.lineJoin=_styleLineJoin;
        middleSector.path=middleSectorPath.CGPath;
        [_compass addSublayer:middleSector];
        [middleSectorPath release];
        
        
        //绘制中环
        CAShapeLayer *middleRing=[CAShapeLayer layer];
        UIBezierPath *middleRingPath=[[UIBezierPath alloc] init];
        [middleRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusMiddle) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
        [middleRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusMiddle-_radiusRing)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusMiddle-_radiusRing)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
        [middleRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusMiddle-_radiusRing) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
        [middleRingPath closePath];
        middleRing.strokeColor=_colorBorderLine.CGColor;
        middleRing.lineWidth=_widthBorderLine;
        middleRing.fillColor=(i+_styleStartColor)%2==RADAR_STYLE_START_COLOR_DARK?_colorRingMiddleLight.CGColor:_colorRingMiddleDark.CGColor;
        middleRing.lineJoin=_styleLineJoin;
        middleRing.path=middleRingPath.CGPath;
        [_compass addSublayer:middleRing];
        [middleRingPath release];
        
        
        //绘制外扇区
        CAShapeLayer *outerSector=[CAShapeLayer layer];
        UIBezierPath *outerSectorPath=[[UIBezierPath alloc] init];
        [outerSectorPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter-_radiusRing) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
        [outerSectorPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusMiddle)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusMiddle)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
        [outerSectorPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusMiddle) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
        [outerSectorPath closePath];
        outerSector.strokeColor=_colorBorderLine.CGColor;
        outerSector.lineWidth=_widthBorderLine;
        outerSector.fillColor=_colorSectorOuter.CGColor;
        outerSector.lineJoin=_styleLineJoin;
        outerSector.path=outerSectorPath.CGPath;
        [_compass addSublayer:outerSector];
        [outerSectorPath release];
        
        
        //绘制外环，首个及最后一个外环需要带上箭头
        if(_hasArrow && i==0)
        {
            CAShapeLayer *outerRing=[CAShapeLayer layer];
            UIBezierPath *outerRingPath=[[UIBezierPath alloc] init];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector+_arcArrow endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
            [outerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter-_radiusRing)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter-_radiusRing)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter-_radiusRing) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
            [outerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter+_heightArrow)*cosf(_styleStartAngle+(i)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter+_heightArrow)*sinf(_styleStartAngle+(i)*M_PI*2/_numberOfSector))];
            [outerRingPath closePath];
            outerRing.strokeColor=_colorBorderLine.CGColor;
            outerRing.lineWidth=_widthBorderLine;
            outerRing.fillColor=(i+_styleStartColor)%2==RADAR_STYLE_START_COLOR_DARK?_colorRingOuterDark.CGColor:_colorRingOuterLight.CGColor;
            outerRing.lineJoin=_styleLineJoin;
            outerRing.path=outerRingPath.CGPath;
            [_compass addSublayer:outerRing];
            [outerRingPath release];
        }
        else if(_hasArrow && i==_numberOfSector-1)
        {
            CAShapeLayer *outerRing=[CAShapeLayer layer];
            UIBezierPath *outerRingPath=[[UIBezierPath alloc] init];
            [outerRingPath moveToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter+_heightArrow)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter+_heightArrow)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
            [outerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter-_radiusRing)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter+_heightArrow)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter-_radiusRing) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
            [outerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter)*cosf(_styleStartAngle+(i)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter)*sinf(_styleStartAngle+(i)*M_PI*2/_numberOfSector))];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector-_arcArrow clockwise:YES];
            [outerRingPath closePath];
            outerRing.strokeColor=_colorBorderLine.CGColor;
            outerRing.lineWidth=_widthBorderLine;
            outerRing.fillColor=(i+_styleStartColor)%2==RADAR_STYLE_START_COLOR_DARK?_colorRingOuterDark.CGColor:_colorRingOuterLight.CGColor;
            outerRing.lineJoin=_styleLineJoin;
            outerRing.path=outerRingPath.CGPath;
            [_compass addSublayer:outerRing];
            [outerRingPath release];
        }
        else
        {
            CAShapeLayer *outerRing=[CAShapeLayer layer];
            UIBezierPath *outerRingPath=[[UIBezierPath alloc] init];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter) startAngle:_styleStartAngle+i*M_PI*2/_numberOfSector endAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector clockwise:YES];
            [outerRingPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOuter-_radiusRing)*cosf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector), _centerPoint.y+_radiusRadar*(_radiusOuter-_radiusRing)*sinf(_styleStartAngle+(i+1)*M_PI*2/_numberOfSector))];
            [outerRingPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOuter-_radiusRing) startAngle:_styleStartAngle+(i+1)*M_PI*2/_numberOfSector endAngle:_styleStartAngle+i*M_PI*2/_numberOfSector clockwise:NO];
            [outerRingPath closePath];
            outerRing.strokeColor=_colorBorderLine.CGColor;
            outerRing.lineWidth=_widthBorderLine;
            outerRing.fillColor=(i+_styleStartColor)%2==RADAR_STYLE_START_COLOR_DARK?_colorRingOuterDark.CGColor:_colorRingOuterLight.CGColor;
            outerRing.lineJoin=_styleLineJoin;
            outerRing.path=outerRingPath.CGPath;
            [_compass addSublayer:outerRing];
            [outerRingPath release];
        }
    }
    
    
    
    //扫描仪
    
    //整体
    self.scanner=[[[UIView alloc] init] autorelease];
    _scanner.frame=self.bounds;
    _scanner.backgroundColor=[UIColor clearColor];
    _scanner.userInteractionEnabled=NO;
    [self.layer addSublayer:_scanner.layer];
    
//    self.scanner=[CAShapeLayer layer];
//    UIBezierPath *scannerPath=[[UIBezierPath alloc] init];
//    [scannerPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusScanner) startAngle:_styleStartAngle-_arcScanner endAngle:_styleStartAngle+_arcScanner clockwise:YES];
//    [scannerPath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOffsetScanner)*cosf(_styleStartAngle+_arcScanner), _centerPoint.y+_radiusRadar*(_radiusOffsetScanner)*sinf(_styleStartAngle+_arcScanner))];
//    [scannerPath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOffsetScanner) startAngle:_styleStartAngle+_arcScanner endAngle:_styleStartAngle-_arcScanner clockwise:NO];
//    [scannerPath closePath];
//    _scanner.strokeColor=[UIColor clearColor].CGColor;
//    _scanner.lineWidth=0;
//    _scanner.fillColor=[UIColor clearColor].CGColor;
//    _scanner.lineJoin=_styleLineJoin;
//    _scanner.path=scannerPath.CGPath;
//    [self.layer addSublayer:_scanner];
//    [scannerPath release];
    
    
    //顺时针部分
    self.scannerClockwise=[CAShapeLayer layer];
    UIBezierPath *clockwisePath=[[UIBezierPath alloc] init];
    [clockwisePath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusScanner) startAngle:_styleStartAngle-_arcScanner endAngle:_styleStartAngle clockwise:YES];
    [clockwisePath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOffsetScanner)*cosf(_styleStartAngle), _centerPoint.y+_radiusRadar*(_radiusOffsetScanner)*sinf(_styleStartAngle))];
    [clockwisePath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOffsetScanner) startAngle:_styleStartAngle endAngle:_styleStartAngle-_arcScanner clockwise:NO];
    [clockwisePath closePath];
    _scannerClockwise.strokeColor=[UIColor clearColor].CGColor;
    _scannerClockwise.lineWidth=0;
    _scannerClockwise.fillColor=_colorScannerArea.CGColor;
    _scannerClockwise.lineJoin=_styleLineJoin;
    _scannerClockwise.path=clockwisePath.CGPath;
    [_scanner.layer addSublayer:_scannerClockwise];
    [clockwisePath release];
    
    
    //逆时针部分
    self.scannerAnticlockwise=[CAShapeLayer layer];
    UIBezierPath *anticlockwisePath=[[UIBezierPath alloc] init];
    [anticlockwisePath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusScanner) startAngle:_styleStartAngle endAngle:_styleStartAngle+_arcScanner clockwise:YES];
    [anticlockwisePath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOffsetScanner)*cosf(_styleStartAngle+_arcScanner), _centerPoint.y+_radiusRadar*(_radiusOffsetScanner)*sinf(_styleStartAngle+_arcScanner))];
    [anticlockwisePath addArcWithCenter:_centerPoint radius:_radiusRadar*(_radiusOffsetScanner) startAngle:_styleStartAngle+_arcScanner endAngle:_styleStartAngle clockwise:NO];
    [anticlockwisePath closePath];
    _scannerAnticlockwise.strokeColor=[UIColor clearColor].CGColor;
    _scannerAnticlockwise.lineWidth=0;
    _scannerAnticlockwise.fillColor=_colorScannerArea.CGColor;
    _scannerAnticlockwise.lineJoin=_styleLineJoin;
    _scannerAnticlockwise.path=anticlockwisePath.CGPath;
    [_scanner.layer addSublayer:_scannerAnticlockwise];
    [anticlockwisePath release];
    
    
    //基准线
    CAShapeLayer *scannerLine=[CAShapeLayer layer];
    UIBezierPath *linePath=[[UIBezierPath alloc] init];
    [linePath moveToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusOffsetScanner)*cosf(_styleStartAngle), _centerPoint.y+_radiusRadar*(_radiusOffsetScanner)*sinf(_styleStartAngle))];
    [linePath addLineToPoint:CGPointMake(_centerPoint.x+_radiusRadar*(_radiusScanner)*cosf(_styleStartAngle), _centerPoint.y+_radiusRadar*(_radiusScanner)*sinf(_styleStartAngle))];
    scannerLine.strokeColor=_colorScannerLine.CGColor;
    scannerLine.lineCap=_styleLineJoin;
    scannerLine.fillColor=[UIColor clearColor].CGColor;
    scannerLine.lineWidth=_widthScannerLine;
    scannerLine.path=linePath.CGPath;
    [_scanner.layer addSublayer:scannerLine];
    [linePath release];
    
    
    [self changeScanDirection:_scanDirection];
    
    _scanner.hidden=YES;
    
}



//配置数据集合
//格式：*,编号(集合标识),类型(0圆点，1照片),容量(最多容纳的数据个数),落点x坐标,落点y坐标,宽度范围w,高度范围h,*
//例子：*,1,0,100,20.0,30.0,30,40,*,2,1,50,220.0,200.0,30.0,30.0,*
- (void)configSet:(NSString *)config
{
    //清除默认的集合数组
    [_arrayDotSet clear];
    [_arrayPhotoSet clear];
    
    //解析配置
    KATArray *setArray=[KATArray array];
    [setArray putFromString:config withSep:@"*" andBlank:NO];
    
    for(int i=0;i<setArray.length;i++)
    {
        KATArray *setAttr=[KATArray arrayWithCapacity:10];
        [setAttr putFromString:[setArray get:i] withSep:@"," andBlank:NO];
        
        if([@"0" isEqualToString:[setAttr get:1]])//圆点集合
        {
            KATRadarDotSet *set=[KATRadarDotSet dotSetWithPlacement:CGPointMake([[setAttr get:3] floatValue], [[setAttr get:4] floatValue]) andArea:CGSizeMake([[setAttr get:5] floatValue], [[setAttr get:6] floatValue]) andCapacity:[[setAttr get:2] floatValue] andRadar:self];
            set.num=[[setAttr get:0] intValue];
            
            [_arrayDotSet put:set];
        }
        else if([@"1" isEqualToString:[setAttr get:1]])//照片集合
        {
            KATRadarPhotoSet *set=[KATRadarPhotoSet photoSetWithPlacement:CGPointMake([[setAttr get:3] floatValue], [[setAttr get:4] floatValue]) andArea:CGSizeMake([[setAttr get:5] floatValue], [[setAttr get:6] floatValue]) andCapacity:[[setAttr get:2] floatValue] andRadar:self];
            set.num=[[setAttr get:0] intValue];
            
            [_arrayPhotoSet put:set];
        }
        
    }
    
}



#pragma -mark 扫描操作相关

//开始扫描
- (void)scanStart
{
    if(!_scanTimer && _scanState==RADAR_SCAN_STATE_STOP)//在停止的情况下才可以启动扫描
    {
        _isScanStop=NO;
        _isScanPause=NO;
        
        if(!_scanTimer)
        {
            self.scanTimer=[CADisplayLink displayLinkWithTarget:self selector:@selector(scanning)];
        }
        
        _scanTimer.frameInterval=_scanFrameInterval;
        
        //添加定时器对象到主运行循环
        //可以同时加入NSDefaultRunLoopMode和UITrackingRunLoopMode来保证它不会被滑动打断，也不会被其他UIKit控件动画影响性能
        [_scanTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_scanTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
        
        //显示扫描仪
        _scanner.hidden=NO;
        
        _scanState=RADAR_SCAN_STATE_RUN;//改变状态
    }
}

//暂停扫描
- (void)scanPause
{
    if(_scanTimer && _scanState==RADAR_SCAN_STATE_RUN)//扫描仪运行情况下才能暂停
    {
        _isScanPause=YES;
        
        _scanState=RADAR_SCAN_STATE_PAUSE;//改变状态
    }
}


//恢复扫描（取消暂停）
- (void)scanResume
{
    if(_scanTimer && _scanState==RADAR_SCAN_STATE_PAUSE)//扫描仪暂停情况下才能取消
    {
        _isScanPause=NO;
        
        _scanState=RADAR_SCAN_STATE_RUN;//改变状态
    }
}


//停止扫描（停止后需要重新启动）
- (void)scanStop
{
    if(_scanTimer)//启动后才可以停止
    {
        [_scanTimer removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_scanTimer release];
        _scanTimer=nil;
        
        //隐藏扫描仪
        _scanner.hidden=YES;
        
        _isScanStop=YES;
        _scanState=RADAR_SCAN_STATE_STOP;//改变状态
    }
}


//改变扫描方向
- (void)changeScanDirection:(int)direction
{
    if(direction==RADAR_DIRECTION_CLOCKWISE)//顺时针方向
    {
        //隐藏一个区块
        _scannerClockwise.hidden=NO;
        _scannerAnticlockwise.hidden=YES;
        
        _scanDirection=RADAR_DIRECTION_CLOCKWISE;//改变方向
    }
    else//逆时针方向
    {
        //隐藏一个区块
        _scannerClockwise.hidden=YES;
        _scannerAnticlockwise.hidden=NO;
        
        _scanDirection=RADAR_DIRECTION_ANTICLOCKWISE;//改变方向
    }
}


//扫描进行
- (void)scanning
{
    if(!_isScanStop)
    {
        if(!_isScanPause)
        {
            _scanFrameTimeCount++;//计算次数
            
            
            
            //改变扫描仪角度
                        
            //重新计算角度
            _scanAngle+=_scanDirection*(M_PI*2/_scanCycleFrame);
            
            //边界修正
            if(_scanAngle<0)
            {
                _scanAngle+=M_PI*2;
            }
            else if(_scanAngle>M_PI*2)
            {
                _scanAngle-=M_PI*2;
            }
            
            //旋转角度
            CGAffineTransform transform=CGAffineTransformMakeRotation(_scanAngle);
            
            //改变图像角度
            _scanner.transform=transform;
            
            
            
            //心跳
            
            //实际角度
            float angle=_scanAngle+_styleStartAngle;
            
            //边界修正
            if(angle<0)
            {
                angle+=M_PI*2;
            }
            else if(angle>M_PI*2)
            {
                angle-=M_PI*2;
            }
    
            
            //圆点心跳
            for(int i=0;i<_arrayDot.length;i++)
            {
                KATRadarDot *dot=(KATRadarDot *)[_arrayDot get:i];
                
                if(dot.angle>=angle+MIN(_scanDirection,-_scanDirection)*(M_PI*2/_scanCycleFrame)*1 && dot.angle<=angle+MAX(_scanDirection,-_scanDirection)*(M_PI*2/_scanCycleFrame)*1)//判断角度是否与扫描线重合(在角度变化步长范围内)
                {
                    [dot heartbeatWithScale:_dotHeartbeatScale andDuration:_dotHeartbeatTime];
                }
            }
            
            //照片心跳
            for(int i=0;i<_arrayPhotoSet.length;i++)
            {
                KATRadarPhotoSet *photoSet=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
                
                KATRadarPhoto *cover=photoSet.cover;//获取封面
                
                if(cover && cover.angle>=angle+MIN(_scanDirection,-_scanDirection)*(M_PI*2/_scanCycleFrame)*1 && cover.angle<=angle+MAX(_scanDirection,-_scanDirection)*(M_PI*2/_scanCycleFrame)*1)//判断角度是否与扫描线重合(在角度变化步长范围内)
                {
                    [cover heartbeatWithScale:_photoHeartbeatScale andDuration:_photoHeartbeatTime];
                }
            }
            
            
            //圆点集合执行进出事件
            if(_scanFrameTimeCount%_dotSetExecuteFrequency==0)
            {
                for(int i=0;i<_arrayDotSet.length;i++)
                {
                    KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
                    
                    [set execute];
                }
            }
            
            //照片集合执行进出事件
            if(_scanFrameTimeCount%_photoSetExecuteFrequency==0)
            {
                for(int i=0;i<_arrayPhotoSet.length;i++)
                {
                    KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
                    
                    [set execute];
                }
            }
        }
    }
    else
    {
        [self scanStop];
    }
}



#pragma -mark 数据操作相关

//添加数据
- (BOOL)addData:(KATRadarData *)data
{
    if(data)
    {
        if(data.type==RADAR_DATA_TYPE_DOT)//圆点数据类型
        {
            if(![_arrayDot hasMember:data] && ![_arrayAdd hasMember:data] && _arrayDotSet.length>0)//数组中不存在该圆点
            {
                KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:arc4random()%_arrayDotSet.length];//先随机获取一个集合
                
                if(set.dots.length+set.addQueue.length>=set.dots.capacity)//随机集合已经存满数据
                {
                    set=nil;
                    
                    //遍历集合数组，找到未满集合
                    for(int i=0;i<_arrayDotSet.length;i++)
                    {
                        set=(KATRadarDotSet *)[_arrayDotSet get:i];
                        
                        if(set.dots.length+set.addQueue.length<set.dots.capacity)//未满集合
                        {
                            break;
                        }
                        else
                        {
                            set=nil;
                        }
                    }
                }
                
                if(set)//找到未满集合
                {
                    [set addDot:(KATRadarDot *)data];
                }
            }
        }
        else if(data.type==RADAR_DATA_TYPE_PHOTO)//照片数据类型
        {
            if(![_arrayPhoto hasMember:data] && ![_arrayAdd hasMember:data]  && _arrayPhotoSet.length>0)//数组中不存在该照片
            {
                KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:arc4random()%_arrayPhotoSet.length];//先随机获取一个集合
                
                if(set.photos.length+set.addQueue.length>=set.photos.capacity)//随机集合已经存满数据
                {
                    set=nil;
                    
                    //遍历集合数组，找到未满集合
                    for(int i=0;i<_arrayPhotoSet.length;i++)
                    {
                        set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
                        
                        if(set.photos.length+set.addQueue.length<set.photos.capacity)//未满集合
                        {
                            break;
                        }
                        else
                        {
                            set=nil;
                        }
                    }
                }
                
                if(set)//找到未满集合
                {
                    [set addPhoto:(KATRadarPhoto *)data];
                }
            }
        }
        
        
        
    }
    
    
    return NO;
}


//添加数据到指定的集合中
- (BOOL)addData:(KATRadarData *)data toSet:(int)setNum
{
    if(data)
    {
        if(data.type==RADAR_DATA_TYPE_DOT)//圆点数据类型
        {
            if(![_arrayDot hasMember:data] && ![_arrayAdd hasMember:data])//数组中不存在该圆点
            {
                //遍历集合数组，找到相应的集合
                for(int i=0;i<_arrayDotSet.length;i++)
                {
                    KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
                    
                    if(set.num==setNum)//找到
                    {
                        if(set.dots.length+set.addQueue.length<set.dots.capacity)//集合未满
                        {
                            [set addDot:(KATRadarDot *)data];
                            
                            return YES;
                        }
                        
                        break;
                    }
                }
            }
        }
        else if(data.type==RADAR_DATA_TYPE_PHOTO)//照片数据类型
        {
            if(![_arrayPhoto hasMember:data] && ![_arrayAdd hasMember:data])//数组中不存在该圆点
            {
                //遍历集合数组，找到相应的集合
                for(int i=0;i<_arrayPhotoSet.length;i++)
                {
                    KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
                    
                    if(set.num==setNum)//找到
                    {
                        if(set.photos.length+set.addQueue.length<set.photos.capacity)//集合未满
                        {
                            [set addPhoto:(KATRadarPhoto *)data];
                            
                            return YES;
                        }
                        
                        break;
                    }
                }
            }
        }
    }
    
    return NO;
}


//删除数据
- (BOOL)removeData:(KATRadarData *)data
{
    if(data && ![_arrayRemove hasMember:data])//删除队列中没有该数据
    {
        if(data.type==RADAR_DATA_TYPE_DOT)//圆点数据类型
        {
            KATRadarDotSet *set=nil;
                
            //遍历集合数组，找到该圆点所在的集合
            for(int i=0;i<_arrayDotSet.length;i++)
            {
                set=(KATRadarDotSet *)[_arrayDotSet get:i];
                
                if([set.dots hasMember:data] || [set.addQueue hasMember:data])//找到该圆点所在的集合
                {
                    break;
                }
                else
                {
                    set=nil;
                }
            }
            
            if(set)//找到该圆点所在的集合
            {
                [set removeDot:(KATRadarDot *)data];
            }
            
        }
        else if(data.type==RADAR_DATA_TYPE_PHOTO)//照片数据类型
        {
            KATRadarPhotoSet *set=nil;
            
            //遍历集合数组，找到该圆点所在的集合
            for(int i=0;i<_arrayPhotoSet.length;i++)
            {
                set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
                
                if([set.photos hasMember:data] || [set.addQueue hasMember:data])//找到该圆点所在的集合
                {
                    break;
                }
                else
                {
                    set=nil;
                }
            }
            
            if(set)//找到该圆点所在的集合
            {
                [set removePhoto:(KATRadarPhoto *)data];
            }
        }
        
        
        
    }
    
    
    return NO;
}


//通过obj删除数据
- (void)removeDataByObject:(id)object
{
    //圆点数组
    for(int i=0;i<_arrayDot.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_arrayDot get:i];
        
        if(dot.object==object)
        {
            [self removeData:dot];
        }
    }
    
    
    //照片数组
    for(int i=0;i<_arrayPhoto.length;i++)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_arrayPhoto get:i];
        
        if(photo.object==object)
        {
            [self removeData:photo];
        }
    }
}


//通过num删除数据
- (void)removeDataByNum:(int)num
{
    //圆点数组
    for(int i=0;i<_arrayDot.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_arrayDot get:i];
        
        if(dot.num==num)
        {
            [self removeData:dot];
        }
    }
    
    
    //照片数组
    for(int i=0;i<_arrayPhoto.length;i++)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_arrayPhoto get:i];
        
        if(photo.num==num)
        {
            [self removeData:photo];
        }
    }
}


//通过数值范围删除数据
- (void)removeDataFromValue:(double)fValue toValue:(double)tValue
{
    //圆点数组
    for(int i=0;i<_arrayDot.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_arrayDot get:i];
        
        if(dot.value>=fValue && dot.value<=tValue)
        {
            [self removeData:dot];
        }
    }
    
    
    //照片数组
    for(int i=0;i<_arrayPhoto.length;i++)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_arrayPhoto get:i];
        
        if(photo.value>=fValue && photo.value<=tValue)
        {
            [self removeData:photo];
        }
    }
}


//清空添加队列
- (void)clearAddQueue
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        [set.addQueue clear];
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        [set.addQueue clear];
    }
}


//清空删除队列
- (void)clearRemoveQueue
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        [set.removeQueue clear];
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        [set.removeQueue clear];
    }
}



//清除雷达上的所有数据（包括队列里的）
- (void)clearData
{
    //先清除添加队列里的数据
    [self clearAddQueue];
    
    //圆点数组
    for(int i=0;i<_arrayDot.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_arrayDot get:i];

        [self removeData:dot];
    }
    
    
    //照片数组
    for(int i=_arrayPhoto.length-1;i>=0;i--)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_arrayPhoto get:i];
        
        [self removeData:photo];
    }
}


//选中集合（通过选中的数据）
- (void)selectSetByData:(KATRadarData *)data
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        if([set.dots hasMember:data])
        {
            [set selectSet];
        }
        else
        {
            [set cancelSet];
        }
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        if([set.photos hasMember:data])
        {
            [set selectSet];
        }
        else
        {
            [set cancelSet];
        }
    }
    
    
    //回调函数
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(dataSelectInRadar:)])
    {
        [_eventDelegate dataSelectInRadar:self];
    }
}


//取消选中集合（通过取消的数据）
- (void)cancelSetByData:(KATRadarData *)data
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        if([set.dots hasMember:data])
        {
            [set cancelSet];
        }
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        if([set.photos hasMember:data])
        {
            [set cancelSet];
        }
    }
    
    
    //回调函数
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(selectedDataCancelInRadar:)])
    {
        [_eventDelegate selectedDataCancelInRadar:self];
    }
}


//取消选中集合（通过背景点击）
- (void)cancelSet
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        if(set.isSelected)
        {
            [set cancelSet];
        }
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        if(set.isSelected)
        {
            [set cancelSet];
        }
    }
    
    
    //回调函数
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(dataCancelInRadar:)])
    {
        [_eventDelegate dataCancelInRadar:self];
    }
}



//获取所有数据
- (NSArray *)getAllData
{
    KATArray *data=[KATArray arrayWithCapacity:_arrayDot.length+_arrayPhoto.length];
    [data putArray:_arrayDot withIndex:0];//先插入圆点数组
    [data putArray:_arrayPhoto withIndex:_arrayDot.length];
    
    return [data getNSArray];
}

//获取所有圆点数据
- (NSArray *)getAllDotData
{
    return [_arrayDot getNSArray];
}

//获取所有照片数据
- (NSArray *)getAllPhotoData
{
    return [_arrayPhoto getNSArray];
}

//获取选中的数据
- (NSArray *)getSelectedData
{
    //圆点集合数组
    for(int i=0;i<_arrayDotSet.length;i++)
    {
        KATRadarDotSet *set=(KATRadarDotSet *)[_arrayDotSet get:i];
        
        if(set.isSelected)
        {
            return [set.dots getNSArray];
        }
    }
    
    
    //照片集合数组
    for(int i=0;i<_arrayPhotoSet.length;i++)
    {
        KATRadarPhotoSet *set=(KATRadarPhotoSet *)[_arrayPhotoSet get:i];
        
        if(set.isSelected)
        {
            return [set.photos getNSArray];
        }
    }
    
    
    return nil;
}


//背景点击事件
- (void)backgroundTap
{
    [self cancelSet];
}


#pragma -mark 数据选中和取消事件

//圆点被选中事件
- (void)selectRadarDot:(KATRadarDot *)dot
{
    [self selectSetByData:dot];
}

//圆点被取消事件
- (void)cancelRadarDot:(KATRadarDot *)dot
{
    [self cancelSetByData:dot];
}

//照片被选中事件
- (void)selectRadarPhoto:(KATRadarPhoto *)photo
{
    [self selectSetByData:photo];
}

//照片被取消事件
- (void)cancelRadarPhoto:(KATRadarPhoto *)photo
{
    [self cancelSetByData:photo];
}



//内存释放
- (void)dealloc
{
    [self scanStop];
    
    [_arrayDot release];
    [_arrayDotSet release];
    [_arrayPhoto release];
    [_arrayPhotoSet release];
    [_arrayAdd release];
    [_arrayRemove release];
    
    [_scanner release];
    [_scannerAnticlockwise release];
    [_scannerClockwise release];
    
    [_compass release];
    
    [_colorBorderLine release];
    [_colorRingInnerDark release];
    [_colorRingInnerLight release];
    [_colorRingMiddleDark release];
    [_colorRingMiddleLight release];
    [_colorRingOuterDark release];
    [_colorRingOuterLight release];
    [_colorSectorOuter release];
    [_colorSectorInner release];
    [_colorSectorMiddle release];
    [_colorScannerLine release];
    [_colorScannerArea release];
    
    [_styleLineJoin release];
    
    [_dotShadowColor release];
    [_dotBorderColor release];
    
    [_photoBadgeBgColor release];
    [_photoBadgeTextColor release];
    [_photoAlbumsBgColor release];
    [_photoAlbumsBorderColor release];
    
    [super dealloc];
}


@end
