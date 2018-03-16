//
//  KATRadarPhotoSet.m
//  KATRadar
//
//  Created by Kantice on 15/10/17.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达照片集合


#import "KATRadarPhotoSet.h"
#import "KATRadar.h"



@implementation KATRadarPhotoSet

+ (KATRadarPhotoSet *)photoSetWithPlacement:(CGPoint)placement andArea:(CGSize)area andCapacity:(int)capacity andRadar:(KATRadar *)radar
{
    KATRadarPhotoSet *photoSet=[[[self alloc] init] autorelease];
    
    photoSet.num=0;
    photoSet.message=nil;
    photoSet.object=nil;
    photoSet.value=0.0;
    photoSet.radar=radar;
    photoSet.capacity=capacity;
    photoSet.placement=placement;
    photoSet.area=area;
    photoSet.isSelected=NO;
    photoSet.photos=[KATArray arrayWithCapacity:capacity];
    photoSet.addQueue=[KATQueue queueWithCapacity:capacity];
    photoSet.removeQueue=[KATQueue queueWithCapacity:capacity];
    photoSet.cover=nil;
    
    return photoSet;
}



//选中集合
- (void)selectSet
{
    for(int i=0;i<_photos.length;i++)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_photos get:i];
        [photo select];
    }
    
    _isSelected=YES;
}


//取消选中
- (void)cancelSet
{
    for(int i=0;i<_photos.length;i++)
    {
        KATRadarPhoto *photo=(KATRadarPhoto *)[_photos get:i];
        [photo cancel];
    }
    
    _isSelected=NO;
}


//放入照片（到添加队列）
- (BOOL)addPhoto:(KATRadarPhoto *)photo
{
    if(photo)
    {
        if(![_addQueue hasMember:photo] && ![_radar.arrayAdd hasMember:photo])
        {
            if([_addQueue put:photo])
            {
                [_radar.arrayAdd put:photo];
                
                if(!_cover)//没有封面
                {
                    //计算圆点落点
                    [photo setPlacement:CGPointMake(_placement.x-_area.width*0.5+arc4random()%((int)_area.width), _placement.y-_area.height*0.5+arc4random()%((int)_area.height))];
                    
                    [self setCoverWithPhoto:photo];
                }
                else
                {
                    [photo setPlacement:_cover.placement];
                }
                
                return YES;
            }
        }
    }
    
    return NO;
}


//删除照片（到删除队列）
- (BOOL)removePhoto:(KATRadarPhoto *)photo
{
    if(![_removeQueue hasMember:photo])
    {
        if([_removeQueue put:photo])
        {
            [_radar.arrayRemove put:photo];
            
            return YES;
        }
    }
    
    return NO;
}


//执行队列中的添加与删除操作(先删除操作，后添加操作)
- (void)execute
{
    KATRadarPhoto *photo=nil;
    
    //从删除队列里获取照片
    photo=(KATRadarPhoto *)[_removeQueue get];
    
    if(photo)
    {
        if([_photos hasMember:photo])//判断该照片是否已经在数组中
        {
            [_radar.arrayPhoto deleteMember:photo];//从圆点数组中删除
            [_photos deleteMember:photo];//从数组中删除
            
            //判断被删除的是否是封面
            if(photo==_cover)
            {
                photo.isCover=NO;
                
                if(photo.badge)//徽标隐藏
                {
                    photo.badge.hidden=YES;
                }
                
                if(photo.albums)//隐藏相册风格
                {
                    photo.albums.hidden=YES;
                }
                
                //数组第一个元素作为封面
                if(_photos.length>0)
                {
                    [self setCoverWithPhoto:(KATRadarPhoto *)[_photos get:0]];
                }
                else
                {
                    self.cover=nil;//数组没有成员则封面置空
                }
            }
            
            //取消选中状态
            [photo cancel];
            
            [photo moveOutWithDuration:_radar.photoMoveInTime];//执行动画
        }
        
        [_radar.arrayRemove deleteMember:photo];//从雷达的删除数组中删除
    }

    
    //从添加队列里获取照片
    photo=(KATRadarPhoto *)[_addQueue get];
    
    if(photo)
    {
        if(![_radar.arrayPhoto hasMember:photo] && ![_photos hasMember:photo] && _photos.length<_photos.capacity)//判断该照片是否已经在数组中，且数组没有满
        {
            [_radar.arrayPhoto put:photo];//添加照片到数组
            [_photos put:photo];//加入到数组
            photo.set=self;
            
            [photo moveInWithDuration:_radar.photoMoveInTime];//执行动画
        }
        
        [_radar.arrayAdd deleteMember:photo];//从雷达的添加数组中删除
    }
    
}



//设置封面
- (void)setCoverWithPhoto:(KATRadarPhoto *)photo
{
    if(photo)
    {
        self.cover=photo;
        self.cover.isCover=YES;
        self.cover.hidden=NO;
    }
}


//更新封面（徽标和重叠）
- (void)updateCover
{
    if(_cover)
    {
        if(_photos.length>1)
        {
            //更新徽标
            if(!_cover.badge)//没有则创建徽标
            {
                _cover.badge=[[[UILabel alloc] init] autorelease];
                _cover.badge.frame=CGRectMake(_cover.bounds.size.width-_cover.bounds.size.width*_radar.photoBadgeSize.width*0.5, 0-_cover.bounds.size.height*_radar.photoBadgeSize.height*0.5, _cover.bounds.size.width*_radar.photoBadgeSize.width, _cover.bounds.size.height*_radar.photoBadgeSize.height);
                _cover.badge.backgroundColor=_radar.photoBadgeBgColor;
                _cover.badge.textColor=_radar.photoBadgeTextColor;
                _cover.badge.font=[UIFont systemFontOfSize:_cover.bounds.size.height*_radar.photoBadgeSize.height*_radar.photoBadgeFontSize];
                _cover.badge.layer.cornerRadius=_cover.bounds.size.height*_radar.photoBadgeSize.height*_radar.photoBadgeCornerRadius;
                _cover.badge.layer.borderColor=_radar.photoBadgeTextColor.CGColor;
                _cover.badge.layer.borderWidth=0;
                _cover.badge.textAlignment=NSTextAlignmentCenter;
                _cover.badge.layer.masksToBounds=YES;
                
                [_cover addSubview:_cover.badge];
            }
            
            _cover.badge.hidden=NO;
            _cover.badge.text=[NSString stringWithFormat:@"%i",_photos.length>_radar.photoBadgeNumberMax?_radar.photoBadgeNumberMax:_photos.length];
            
            
            //更新相册样式
            if(!_cover.albums)
            {
                _cover.albums=[CALayer layer];
                _cover.albums.frame=_cover.bounds;
                
                //第三层
                CAShapeLayer *shape3=[CAShapeLayer layer];
                UIBezierPath *path3=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(_radar.photoAlbumsOffset*3, _radar.photoAlbumsOffset*3, _cover.albums.bounds.size.width, _cover.albums.bounds.size.height) cornerRadius:_cover.size.width*_cover.cornerRadius];
                shape3.strokeColor=_radar.photoAlbumsBorderColor.CGColor;
                shape3.fillColor=_radar.photoAlbumsBgColor.CGColor;
                shape3.lineWidth=_radar.photoAlbumsBorderWidth;
                shape3.path=path3.CGPath;
                [_cover.albums addSublayer:shape3];
                
                //第二层
                CAShapeLayer *shape2=[CAShapeLayer layer];
                UIBezierPath *path2=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(_radar.photoAlbumsOffset*2, _radar.photoAlbumsOffset*2, _cover.albums.bounds.size.width, _cover.albums.bounds.size.height) cornerRadius:_cover.size.width*_cover.cornerRadius];
                shape2.strokeColor=_radar.photoAlbumsBorderColor.CGColor;
                shape2.fillColor=_radar.photoAlbumsBgColor.CGColor;
                shape2.lineWidth=_radar.photoAlbumsBorderWidth;
                shape2.path=path2.CGPath;
                [_cover.albums addSublayer:shape2];
                
                //第一层
                CAShapeLayer *shape1=[CAShapeLayer layer];
                UIBezierPath *path1=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(_radar.photoAlbumsOffset*1, _radar.photoAlbumsOffset*1, _cover.albums.bounds.size.width, _cover.albums.bounds.size.height) cornerRadius:_cover.size.width*_cover.cornerRadius];
                shape1.strokeColor=_radar.photoAlbumsBorderColor.CGColor;
                shape1.fillColor=_radar.photoAlbumsBgColor.CGColor;
                shape1.lineWidth=_radar.photoAlbumsBorderWidth;
                shape1.path=path1.CGPath;
                [_cover.albums addSublayer:shape1];
                
                [_cover.layer addSublayer:_cover.albums];
                
                //图层顺序
                _cover.albums.zPosition=0.1;
                _cover.photo.zPosition=1.0;
                _cover.badge.layer.zPosition=10.0;
                
            }
            
            _cover.albums.hidden=NO;
        }
        else
        {
            if(_cover.badge)//隐藏徽标
            {
                _cover.badge.hidden=YES;
            }
            
            if(_cover.albums)//隐藏相册风格
            {
                _cover.albums.hidden=YES;
            }
        }
    }
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"KATRadarPhotoSet(%i)(%i/%i): placement(%.1f,%.1f), area(%.1f,%.1f)",_num,_photos.length,_photos.capacity,_placement.x,_placement.y,_area.width,_area.height];
}

- (void)dealloc
{
//    NSLog(@"%@ is delloc!",self);
    
    [_message release];
    [_object release];
    [_photos release];
    [_addQueue release];
    [_removeQueue release];
    [_cover release];
    
    [super dealloc];
}

@end
