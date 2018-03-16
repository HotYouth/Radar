//
//  KATRadarPhoto.m
//  KATRadar
//
//  Created by Kantice on 15/10/17.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达照片

#import "KATRadarPhoto.h"
#import "KATRadar.h"


//常量
NSString * const kKATRadarPhotoAnimHeartbeat=@"kat_radar_photo_anim_heartbeat";
NSString * const kKATRadarPhotoAnimMoveIn=@"kat_radar_photo_anim_move_in";
NSString * const kKATRadarPhotoAnimMoveOut=@"kat_radar_photo_anim_move_out";


@implementation KATRadarPhoto

+ (KATRadarPhoto *)photoWithSize:(CGSize)size andImage:(UIImage *)image andRadar:(KATRadar *)radar
{
    KATRadarPhoto *photo=[[[self alloc] init] autorelease];
    
    photo.num=0;
    photo.type=RADAR_DATA_TYPE_PHOTO;
    photo.message=nil;
    photo.object=nil;
    photo.value=0.0;
    photo.size=size;
    photo.borderColor=[UIColor whiteColor];
    photo.borderWidth=1.0f;
    photo.cornerRadius=0.12f;
    photo.isSelected=NO;
    photo.isShow=NO;
    photo.isCover=NO;
    photo.eventDelegate=radar;
    photo.radar=radar;
    photo.image=image;
    photo.set=nil;
    photo.photo=nil;
    photo.badge=nil;
    photo.albums=nil;
    
    //点击事件设置
    UITapGestureRecognizer *singleTap=nil;
    singleTap=[[UITapGestureRecognizer alloc] initWithTarget:photo action:@selector(photoTap)];
    singleTap.numberOfTapsRequired=1;//点击次数
    [photo addGestureRecognizer:singleTap];//添加点击事件
    [singleTap release];
    
    return photo;
}



//初始化
- (void)initPhoto
{
    _state=RADAR_PHOTO_STATE_HIDE;
    
    self.frame=CGRectMake(-_size.width, -_size.height, _size.width, _size.height);
    self.backgroundColor=[UIColor clearColor];
    self.layer.borderWidth=0;
//    self.layer.borderColor=[UIColor clearColor].CGColor;
//    self.layer.cornerRadius=_cornerRadius*_size.width;
    
    self.photo=[CALayer layer];
    self.photo.frame=self.bounds;
    self.photo.backgroundColor=[UIColor clearColor].CGColor;
    self.photo.cornerRadius=_cornerRadius*_size.width;
    self.photo.borderColor=_borderColor.CGColor;
    self.photo.borderWidth=0;
    [self.layer addSublayer:_photo];
    
    [self initImage];
    
    self.photo.contents=(id)_image.CGImage;//设置照片内容
}


//初始化图片
- (void)initImage
{
    //图片性能调优
    
    //先改变图片尺寸
    self.image=[KATImageUtil fitImage:_image withSize:_size];
    
    //裁圆角
    CALayer *layer=[CALayer layer];
    layer.bounds=self.bounds;
    layer.contents=(id)_image.CGImage;
    layer.cornerRadius=_cornerRadius*_size.width;
    layer.masksToBounds=YES;
    
    //转化为最终图片
    self.image=[KATImageUtil imageFromLayer:layer];
}


//心跳
- (void)heartbeatWithScale:(float)scale andDuration:(float)duration
{
    if(_state==RADAR_PHOTO_STATE_READY)//判断状态(只有在照片进入罗盘，且没有其他动画时才有心跳动画)
    {
        //范围判断
        if(duration<RADAR_PHOTO_DURATION_MIN)
        {
            duration=RADAR_PHOTO_DURATION_MIN;
        }
        else if(duration>RADAR_PHOTO_DURATION_MAX)
        {
            duration=RADAR_PHOTO_DURATION_MAX;
        }
        
        if(_set)
        {
            [_set updateCover];//更新封面
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
        [basicAnimation setValue:kKATRadarPhotoAnimHeartbeat forKey:@"aid"];
        
        //添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [self.layer addAnimation:basicAnimation forKey:kKATRadarPhotoAnimHeartbeat];
    }
}


//移进罗盘
- (void)moveInWithDuration:(float)duration
{
//    if(_state==RADAR_PHOTO_STATE_HIDE)//判断状态(只有在圆点未进入罗盘时)
    {
        if(_state==RADAR_PHOTO_STATE_MOVE_IN || _state==RADAR_PHOTO_STATE_HEARTBEAT || _state==RADAR_DOT_STATE_MOVE_OUT)//有动画时先停止动画
        {
            [self stopAnimation];
        }
        
        //先改变位置并加入雷达图层
//        self.layer.position=CGPointMake(_radar.radiusRadar*2-_placement.x, _radar.radiusRadar*2-_placement.y);//半径位相对落点与圆心的距离
        self.layer.position=CGPointMake(_radar.radiusRadar-_radar.radiusRadar*cosf(_angle), _radar.radiusRadar-_radar.radiusRadar*sinf(_angle));//起始点在圆弧上
        self.layer.opacity=1.0f;
        [_radar addSubview:self];
        
        //范围判断
        if(duration<RADAR_PHOTO_DURATION_MIN)
        {
            duration=RADAR_PHOTO_DURATION_MIN;
        }
        else if(duration>RADAR_PHOTO_DURATION_MAX)
        {
            duration=RADAR_PHOTO_DURATION_MAX;
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
//        alphaAnimation.fromValue=[NSNumber numberWithFloat:0.4];
//        alphaAnimation.toValue=[NSNumber numberWithFloat:1.0];

        
        
        //缩放
        CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        //设置动画属性初始值、结束值，动画时长，填充模式
        scaleAnimation.fromValue=[NSNumber numberWithFloat:1.28];
        scaleAnimation.toValue=[NSNumber numberWithFloat:1.0];

        
        
        //创建动画组
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        
        //设置组中的动画和其他属性
        animationGroup.animations=@[scaleAnimation,pathAnimation];
        animationGroup.delegate=self;
        animationGroup.duration=duration;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效，该时间为动画总时长
        
        
        //设置属性
        [animationGroup setValue:kKATRadarPhotoAnimMoveIn forKey:@"aid"];
        
        //给图层添加动画
        [self.layer addAnimation:animationGroup forKey:kKATRadarPhotoAnimMoveIn];
    }
}


//移出罗盘
- (void)moveOutWithDuration:(float)duration
{
//    if(_state==RADAR_PHOTO_STATE_READY || _state==RADAR_PHOTO_STATE_STOP || _state==RADAR_PHOTO_STATE_MOVE_IN || _state==RADAR_PHOTO_STATE_HEARTBEAT)//判断状态(只有在圆点进入罗盘或停止时)
    {
        if(_state==RADAR_PHOTO_STATE_MOVE_IN || _state==RADAR_PHOTO_STATE_HEARTBEAT || _state==RADAR_DOT_STATE_MOVE_OUT)//有动画时先停止动画
        {
            [self stopAnimation];
        }
        
        //范围判断
        if(duration<RADAR_PHOTO_DURATION_MIN)
        {
            duration=RADAR_PHOTO_DURATION_MIN;
        }
        else if(duration>RADAR_PHOTO_DURATION_MAX)
        {
            duration=RADAR_PHOTO_DURATION_MAX;
        }
        
        [_radar addSubview:self];
        
        //取消隐藏
        self.hidden=NO;
        
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
        [animationGroup setValue:kKATRadarPhotoAnimMoveOut forKey:@"aid"];
        
        //给图层添加动画
        [self.layer addAnimation:animationGroup forKey:kKATRadarPhotoAnimMoveOut];
    }

}


//选中
- (void)select
{
    if(!_isSelected)
    {
        self.photo.borderWidth=_borderWidth;
        
        if(_badge)
        {
            _badge.layer.borderWidth=_radar.photoBadgeBorderWidth;
        }
        
        [_radar bringSubviewToFront:self];//移至最前
        
        _isSelected=YES;
    }
}


//取消选中
- (void)cancel
{
    if(_isSelected)
    {
        self.photo.borderWidth=0;
        
        if(_badge)
        {
            _badge.layer.borderWidth=0;
        }
        
        _isSelected=NO;
    }
}



//设置落点，并自动计算角度
- (void)setPlacement:(CGPoint)placement
{
    if(_state==RADAR_PHOTO_STATE_HIDE)//只有在圆点隐藏未显示的情况下，才可以设置落点和角度
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
- (void)photoTap
{
    if(_isSelected)
    {
        [self cancel];
        
        //回调函数
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(cancelRadarPhoto:)])
        {
            [_eventDelegate cancelRadarPhoto:self];
        }
    }
    else
    {
        [self select];
        
        //回调函数
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(selectRadarPhoto:)])
        {
            [_eventDelegate selectRadarPhoto:self];
        }
    }
}


//停止并移除动画
- (void)stopAnimation
{
    if(_state==RADAR_PHOTO_STATE_MOVE_IN || _state==RADAR_PHOTO_STATE_HEARTBEAT)//动画中可以停止
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
    
    if([aid isEqualToString:kKATRadarPhotoAnimHeartbeat])//心跳动画
    {
        _state=RADAR_PHOTO_STATE_HEARTBEAT;
        
//        [_radar bringSubviewToFront:self];
    }
    else if([aid isEqualToString:kKATRadarPhotoAnimMoveIn])//进入动画
    {
        _state=RADAR_PHOTO_STATE_MOVE_IN;
        
        //设置终点位置
        self.layer.position=_placement;
        
        //将封面移动到顶层
        if(_set && _set.cover)
        {
            [_radar bringSubviewToFront:_set.cover];
            
            if(_set.cover!=self)//非封面
            {
                _isCover=NO;
                
                if(_badge)
                {
                    _badge.hidden=YES;
                }
                
                if(_albums)
                {
                    _albums.hidden=YES;
                }
            }
        }
    }
    else if([aid isEqualToString:kKATRadarPhotoAnimMoveOut])//出去动画
    {
        _state=RADAR_PHOTO_STATE_MOVE_OUT;
        
        if(_set && _set.cover==self)//判断是否为封面
        {
            _set.cover=nil;//封面置空
            self.isCover=NO;
            
            //设置新封面
            //数组第一个元素作为封面
            if(_set.photos.length>0)
            {
                [_set setCoverWithPhoto:(KATRadarPhoto *)[_set.photos get:0]];
            }
        }
        else//非封面
        {
            
        }
        
        //透明
        self.layer.opacity=0.0f;
        
        if(_set)
        {
            [_set updateCover];//更新封面
        }
    }
}


//动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)//完成动画
    {
        NSString *aid=[anim valueForKey:@"aid"];//获取动画标识
        
        if([aid isEqualToString:kKATRadarPhotoAnimHeartbeat])//心跳动画
        {
            _state=RADAR_PHOTO_STATE_READY;
        }
        else if([aid isEqualToString:kKATRadarPhotoAnimMoveIn])//进入动画
        {
            _state=RADAR_PHOTO_STATE_READY;
            
            if(_set && _set.cover==self)//判断是否为封面
            {
                
            }
            else//非封面，在完成进入动画后隐藏
            {
                self.hidden=YES;
            }
            
            if(_set)
            {
                [_set updateCover];//更新封面
            }
        }
        else if([aid isEqualToString:kKATRadarPhotoAnimMoveOut])//出去动画
        {
            _state=RADAR_PHOTO_STATE_HIDE;
            self.set=nil;
            
            //移除
            [self removeFromSuperview];
            
            if(_set)
            {
                [_set updateCover];//更新封面
            }
        }
    }
    else//终止动画
    {
        NSString *aid=[anim valueForKey:@"aid"];//获取动画标识
        
        if([aid isEqualToString:kKATRadarPhotoAnimHeartbeat])//心跳动画
        {
            _state=RADAR_PHOTO_STATE_STOP;
        }
        else if([aid isEqualToString:kKATRadarPhotoAnimMoveIn])//进入动画
        {
            _state=RADAR_PHOTO_STATE_STOP;
            
            if(_set)
            {
                [_set updateCover];//更新封面
            }
        }
        else if([aid isEqualToString:kKATRadarPhotoAnimMoveOut])//出去动画
        {
            _state=RADAR_PHOTO_STATE_HIDE;
//            self.set=nil;
            
            //移除
//            [self removeFromSuperview];
            
            if(_set)
            {
                [_set updateCover];//更新封面
            }
        }
                
    }
}




- (NSString *)description
{
    return [NSString stringWithFormat:@"KATRadarPhoto(%i):%.2lf",self.num,self.value];
}

- (void)dealloc
{
    NSLog(@"%@ is delloc!",self);
    
    [_image release];
    [_borderColor release];
    [_photo release];
    [_badge release];
    [_albums release];
    
    [super dealloc];
}

@end
