//
//  KATRadarDot.m
//  KATRadar
//
//  Created by Kantice on 15/10/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达圆点

#import "KATRadarDot.h"
#import "KATRadar.h"


//常量
NSString * const kKATRadarDotAnimHeartbeat=@"kat_radar_dot_anim_heartbeat";
NSString * const kKATRadarDotAnimMoveIn=@"kat_radar_dot_anim_move_in";
NSString * const kKATRadarDotAnimMoveOut=@"kat_radar_dot_anim_move_out";


@implementation KATRadarDot

+ (KATRadarDot *)dotWithSize:(CGSize)size andColor:(UIColor *)color andRadar:(KATRadar *)radar
{
    KATRadarDot *dot=[[[self alloc] init] autorelease];
    
    dot.num=0;
    dot.type=RADAR_DATA_TYPE_DOT;
    dot.message=nil;
    dot.object=nil;
    dot.value=0.0;
    dot.size=size;
    dot.color=color;
    dot.isSelected=NO;
    dot.isShow=NO;
    dot.shape=nil;
    dot.eventDelegate=radar;
    dot.radar=radar;
    dot.shadow=nil;
    
    
    //点击事件设置
    UITapGestureRecognizer *singleTap=nil;
    singleTap=[[UITapGestureRecognizer alloc] initWithTarget:dot action:@selector(dotTap)];
    singleTap.numberOfTapsRequired=1;//点击次数
    [dot addGestureRecognizer:singleTap];//添加点击事件
    [singleTap release];
    
    return dot;
}



//初始化
- (void)initDot
{
    _state=RADAR_DOT_STATE_HIDE;
    
    self.frame=CGRectMake(-_size.width, -_size.height, _size.width, _size.height);
    self.backgroundColor=[UIColor clearColor];
    self.layer.borderWidth=0;
    self.layer.borderColor=_radar.dotBorderColor.CGColor;
    self.layer.cornerRadius=_size.height*0.5;
    
    if(_radar.hasDotShadow)
    {
        if(!_shadow)
        {
            self.shadow=[CAShapeLayer layer];
            UIBezierPath *path=[[UIBezierPath alloc] init];
            [path addArcWithCenter:CGPointMake(_size.width*0.5+_radar.dotShadowOffset.x, _size.height*0.5+_radar.dotShadowOffset.y) radius:_size.height*_radar.dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            _shadow.strokeColor=[UIColor clearColor].CGColor;
            _shadow.fillColor=_radar.dotShadowColor.CGColor;
            _shadow.lineWidth=0;
            _shadow.path=path.CGPath;
            [path release];
        }
        
        [self.layer addSublayer:_shadow];
    }
    
    if(!_shape)
    {
        self.shape=[CAShapeLayer layer];
        UIBezierPath *path=[[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(_size.width*0.5, _size.height*0.5) radius:_size.height*_radar.dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _shape.strokeColor=[UIColor clearColor].CGColor;
        _shape.fillColor=_color.CGColor;
        _shape.lineWidth=0;
        _shape.path=path.CGPath;
        [path release];
    }
    
    [self.layer addSublayer:_shape];
    
}


//心跳
- (void)heartbeatWithScale:(float)scale andDuration:(float)duration
{
    if(_state==RADAR_DOT_STATE_READY)//判断状态(只有在圆点进入罗盘，且没有其他动画时才有心跳动画)
    {
        //范围判断
        if(duration<RADAR_DOT_DURATION_MIN)
        {
            duration=RADAR_DOT_DURATION_MIN;
        }
        else if(duration>RADAR_DOT_DURATION_MAX)
        {
            duration=RADAR_DOT_DURATION_MAX;
        }
        
        //创建动画并指定动画属性
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        //设置动画属性初始值、结束值
        basicAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        basicAnimation.toValue=[NSNumber numberWithFloat:scale];
        
        //设置其他动画属性
        basicAnimation.duration=duration;
        basicAnimation.autoreverses=true;//旋转后再旋转到原来的位置
        
//        basicAnimation.repeatCount=1;//设置循环
//        basicAnimation.removedOnCompletion=YES;
        
        basicAnimation.delegate=self;
        
        //设置属性
        [basicAnimation setValue:kKATRadarDotAnimHeartbeat forKey:@"aid"];
        
        //添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [self.layer addAnimation:basicAnimation forKey:kKATRadarDotAnimHeartbeat];
    }
}


//移进罗盘
- (void)moveInWithDuration:(float)duration
{
//    if(_state==RADAR_DOT_STATE_HIDE)//判断状态(只有在圆点未进入罗盘时)
    {
        if(_state==RADAR_DOT_STATE_MOVE_IN || _state==RADAR_DOT_STATE_HEARTBEAT || _state==RADAR_DOT_STATE_MOVE_OUT)//有动画时先停止动画
        {
            [self stopAnimation];
        }
        
        //先改变位置并加入雷达图层
//        self.layer.position=CGPointMake(_radar.radiusRadar*2-_placement.x, _radar.radiusRadar*2-_placement.y);//半径位相对落点与圆心的距离
        self.layer.position=CGPointMake(_radar.radiusRadar-_radar.radiusRadar*cosf(_angle), _radar.radiusRadar-_radar.radiusRadar*sinf(_angle));//起始点在圆弧上
        self.layer.opacity=1.0f;
        [_radar addSubview:self];
        
        //范围判断
        if(duration<RADAR_DOT_DURATION_MIN)
        {
            duration=RADAR_DOT_DURATION_MIN;
        }
        else if(duration>RADAR_DOT_DURATION_MAX)
        {
            duration=RADAR_DOT_DURATION_MAX;
        }
        
        //轨迹动画
        CAKeyframeAnimation *pathAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        //圆弧
        CGMutablePathRef path=CGPathCreateMutable();
        float radius=0.5*sqrt((_placement.x-self.layer.position.x)*(_placement.x-self.layer.position.x)+(_placement.y-self.layer.position.y)*(_placement.y-self.layer.position.y));//半径
//        CGPathMoveToPoint(path, NULL, self.layer.position.x, self.layer.position.y);//移动到起始点
//        CGPathAddArc(path, NULL, _radar.centerPoint.x, _radar.centerPoint.y, sqrt((_placement.x-_radar.centerPoint.x)*(_placement.x-_radar.centerPoint.x)+(_placement.y-_radar.centerPoint.y)*(_placement.y-_radar.centerPoint.y)), _angle>M_PI?_angle-M_PI:_angle+M_PI, _angle, true);//半径位相对落点与圆心的距离
        CGPathAddArc(path, NULL, _placement.x-radius*cosf(_angle), _placement.y-radius*sinf(_angle), radius, _angle>M_PI?_angle-M_PI:_angle+M_PI, _angle, true);//起始点在圆弧上
        pathAnimation.path=path;//设置path属性
        CGPathRelease(path);//释放路径对象
        pathAnimation.duration=duration;
        pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//由快到慢模式

        
        
        //透明变化动画
//        CABasicAnimation *alphaAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//        
//        //设置透明度初始值、结束值，动画时长，填充模式
//        alphaAnimation.fromValue=[NSNumber numberWithFloat:0.6];
//        alphaAnimation.toValue=[NSNumber numberWithFloat:1.0];
        
        //缩放
//        CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        
//        //设置动画属性初始值、结束值，动画时长，填充模式
//        scaleAnimation.fromValue=[NSNumber numberWithFloat:1.3];
//        scaleAnimation.toValue=[NSNumber numberWithFloat:1.0];

        
        
        //创建动画组
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        
        //设置组中的动画和其他属性
        animationGroup.animations=@[pathAnimation];//@[alphaAnimation,scaleAnimation,pathAnimation];
        animationGroup.delegate=self;
        animationGroup.duration=duration;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效，该时间为动画总时长
        
        
        //设置属性
        [animationGroup setValue:kKATRadarDotAnimMoveIn forKey:@"aid"];
        
        //给图层添加动画
        [self.layer addAnimation:animationGroup forKey:kKATRadarDotAnimMoveIn];
        
    }
}


//移出罗盘
- (void)moveOutWithDuration:(float)duration
{
//    if(_state==RADAR_DOT_STATE_READY || _state==RADAR_DOT_STATE_STOP || _state==RADAR_DOT_STATE_MOVE_IN || _state==RADAR_DOT_STATE_HEARTBEAT)//判断状态(只有在圆点进入罗盘或停止时)
    {
        if(_state==RADAR_DOT_STATE_MOVE_IN || _state==RADAR_DOT_STATE_HEARTBEAT || _state==RADAR_DOT_STATE_MOVE_OUT)//有动画时先停止动画
        {
            [self stopAnimation];
        }
        
        //范围判断
        if(duration<RADAR_DOT_DURATION_MIN)
        {
            duration=RADAR_DOT_DURATION_MIN;
        }
        else if(duration>RADAR_DOT_DURATION_MAX)
        {
            duration=RADAR_DOT_DURATION_MAX;
        }
        
        [_radar addSubview:self];
        
        //位移动画
 
        //创建动画并指定动画属性
        CABasicAnimation *positionAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
        
        //计算当前位置角度
        float angle=[self getCurrentAngle];
        angle-=M_PI/2.0;//逆时针偏移90度，切线轨迹
        
        if(angle<0)//负值修正
        {
            angle=M_PI*2+angle;
        }
        
        //设置初始值、结束值，动画时长，填充模式
        positionAnimation.fromValue=[NSValue valueWithCGPoint:self.layer.position];//可以不设置，默认为图层初始状态
        positionAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(self.layer.position.x+cosf(angle)*_radar.radiusRadar, self.layer.position.y+sinf(angle)*_radar.radiusRadar)];
        positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//由快到慢模式
        
        //透明变化动画
        CABasicAnimation *alphaAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        
        //设置透明度初始值、结束值，动画时长，填充模式
        alphaAnimation.fromValue=[NSNumber numberWithFloat:self.layer.opacity];
        alphaAnimation.toValue=[NSNumber numberWithFloat:0.0f];
        
        
        
        //创建动画组
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        
        //设置组中的动画和其他属性
        animationGroup.animations=@[alphaAnimation,positionAnimation];
        animationGroup.delegate=self;
        animationGroup.duration=duration;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效，该时间为动画总时长
        
        
        //设置属性
        [animationGroup setValue:kKATRadarDotAnimMoveOut forKey:@"aid"];
        
        //给图层添加动画
        [self.layer addAnimation:animationGroup forKey:kKATRadarDotAnimMoveOut];
    }

}


//选中
- (void)select
{
    if(!_isSelected)
    {
        self.layer.borderWidth=_radar.dotBorderWidth;
        
        [_radar bringSubviewToFront:self];
        
        _isSelected=YES;
    }
}


//取消选中
- (void)cancel
{
    if(_isSelected)
    {
        self.layer.borderWidth=0;
        
        _isSelected=NO;
    }
}




//设置落点，自动计算角度
- (void)setPlacement:(CGPoint)placement
{
    if(_state==RADAR_DOT_STATE_HIDE)//只有在圆点隐藏未显示的情况下，才可以设置落点和角度
    {
        _placement=placement;
        
        //计算角度，反正切函数
        _angle=atan2f((_placement.y-_radar.centerPoint.y),(_placement.x-_radar.centerPoint.x));
        
        if(_angle<0)//负角度修正
        {
            _angle=M_PI*2+_angle;
        }
    }
}


//计算当前角度
- (float)getCurrentAngle
{
    //计算角度，反正切函数
    float angle=atan2f((self.layer.position.y-_radar.centerPoint.y),(self.layer.position.x-_radar.centerPoint.x));
    
    if(angle<0)//负角度修正
    {
        angle=M_PI*2+angle;
    }
    
    return angle;
}


//点击事件
- (void)dotTap
{
    if(_isSelected)
    {
        [self cancel];
        
        //回调函数
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(cancelRadarDot:)])
        {
            [_eventDelegate cancelRadarDot:self];
        }
    }
    else
    {
        [self select];
        
        //回调函数
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(selectRadarDot:)])
        {
            [_eventDelegate selectRadarDot:self];
        }
    }
}


//停止并移除动画
- (void)stopAnimation
{
    if(_state==RADAR_DOT_STATE_MOVE_IN || _state==RADAR_DOT_STATE_HEARTBEAT)//动画中可以停止
    {
        //动画终止时，保留图层位置和透明度
        CALayer *present=(CALayer *)self.layer.presentationLayer;
        
        if(present)
        {
            self.layer.position=present.position;
            self.layer.opacity=present.opacity;
        }
        
        //移除所有动画
        [self.layer removeAllAnimations];
    }
}


#pragma mark - 动画代理方法

//动画开始
-(void)animationDidStart:(CAAnimation *)anim
{
    NSString *aid=[anim valueForKey:@"aid"];//获取动画标识
    
    if([aid isEqualToString:kKATRadarDotAnimHeartbeat])//心跳动画
    {
        _state=RADAR_DOT_STATE_HEARTBEAT;
        
//        [_radar bringSubviewToFront:self];
    }
    else if([aid isEqualToString:kKATRadarDotAnimMoveIn])//进入动画
    {
        _state=RADAR_DOT_STATE_MOVE_IN;
        
        //设置终点位置
        self.layer.position=_placement;
    }
    else if([aid isEqualToString:kKATRadarDotAnimMoveOut])//出去动画
    {
        _state=RADAR_DOT_STATE_MOVE_OUT;
        
        //透明
        self.layer.opacity=0.0f;
    }
}


//动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)//完成动画
    {
        NSString *aid=[anim valueForKey:@"aid"];//获取动画标识
        
        if([aid isEqualToString:kKATRadarDotAnimHeartbeat])//心跳动画
        {
            _state=RADAR_DOT_STATE_READY;
        }
        else if([aid isEqualToString:kKATRadarDotAnimMoveIn])//进入动画
        {
            _state=RADAR_DOT_STATE_READY;
        }
        else if([aid isEqualToString:kKATRadarDotAnimMoveOut])//出去动画
        {
            _state=RADAR_DOT_STATE_HIDE;
            
            //移除
            [self removeFromSuperview];
        }
    }
    else//终止动画
    {
        NSString *aid=[anim valueForKey:@"aid"];//获取动画标识
        
        if([aid isEqualToString:kKATRadarDotAnimHeartbeat])//心跳动画
        {
            _state=RADAR_DOT_STATE_STOP;
        }
        else if([aid isEqualToString:kKATRadarDotAnimMoveIn])//进入动画
        {
            _state=RADAR_DOT_STATE_STOP;
        }
        else if([aid isEqualToString:kKATRadarDotAnimMoveOut])//出去动画
        {
            _state=RADAR_DOT_STATE_HIDE;
            
            //移除
//            [self removeFromSuperview];
        }
                
    }
}




- (NSString *)description
{
    return [NSString stringWithFormat:@"KATRadarDot(%i):%.2lf",self.num,self.value];
}

- (void)dealloc
{
//    NSLog(@"%@ is delloc!",self);
    
    [_color release];
    [_shape release];
    [_shadow release];
    
    [super dealloc];
}

@end
