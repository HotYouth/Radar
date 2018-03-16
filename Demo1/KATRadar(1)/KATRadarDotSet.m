//  KATRadarDotSet.h
//  KATRadar
//
//  Created by Kantice on 15/10/16.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  雷达圆点集合


#import "KATRadarDotSet.h"
#import "KATRadar.h"



@implementation KATRadarDotSet

+ (KATRadarDotSet *)dotSetWithPlacement:(CGPoint)placement andArea:(CGSize)area andCapacity:(int)capacity andRadar:(KATRadar *)radar
{
    KATRadarDotSet *dotSet=[[[self alloc] init] autorelease];
    
    dotSet.num=0;
    dotSet.message=nil;
    dotSet.object=nil;
    dotSet.value=0.0;
    dotSet.radar=radar;
    dotSet.capacity=capacity;
    dotSet.placement=placement;
    dotSet.area=area;
    dotSet.isSelected=NO;
    dotSet.dots=[KATArray arrayWithCapacity:capacity];
    dotSet.addQueue=[KATQueue queueWithCapacity:capacity];
    dotSet.removeQueue=[KATQueue queueWithCapacity:capacity];
    
    return dotSet;
}



//选中集合
- (void)selectSet
{
    for(int i=0;i<_dots.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_dots get:i];
        [dot select];
    }
    
    _isSelected=YES;
}


//取消选中
- (void)cancelSet
{
    for(int i=0;i<_dots.length;i++)
    {
        KATRadarDot *dot=(KATRadarDot *)[_dots get:i];
        [dot cancel];
    }
    
    _isSelected=NO;
}


//放入圆点（到添加队列）
- (BOOL)addDot:(KATRadarDot *)dot
{
    if(dot)
    {
        if(![_addQueue hasMember:dot] && ![_radar.arrayAdd hasMember:dot])
        {
            if([_addQueue put:dot])
            {
                [_radar.arrayAdd put:dot];
                
                //计算圆点落点
                [dot setPlacement:CGPointMake(_placement.x-_area.width*0.5+arc4random()%((int)_area.width), _placement.y-_area.height*0.5+arc4random()%((int)_area.height))];
                
                return YES;
            }
        }
    }
    
    return NO;
}


//删除圆点（到删除队列）
- (BOOL)removeDot:(KATRadarDot *)dot
{
    if(![_removeQueue hasMember:dot])
    {
        if([_removeQueue put:dot])
        {
            [_radar.arrayRemove put:dot];
            
            return YES;
        }
    }
    
    return NO;
}


//执行队列中的添加与删除操作(先删除操作，后添加操作)
- (void)execute
{
    KATRadarDot *dot=nil;
    
    //从删除队列里获取圆点
    dot=(KATRadarDot *)[_removeQueue get];
    
    if(dot)
    {
        if([_dots hasMember:dot])//判断该圆点是否已经在数组中
        {
            [dot cancel];//取消选中
            
            [_radar.arrayDot deleteMember:dot];//从圆点数组中删除
            [_dots deleteMember:dot];//从数组中删除
            
            [dot moveOutWithDuration:_radar.dotMoveOutTime];//执行动画
        }
        
        [_radar.arrayRemove deleteMember:dot];//从雷达的删除数组中删除
    }
    
    //从添加队列里获取圆点
    dot=(KATRadarDot *)[_addQueue get];
    
    if(dot)
    {
        if(![_radar.arrayDot hasMember:dot] && ![_dots hasMember:dot] && _dots.length<_dots.capacity)//判断该圆点是否已经在数组中，且数组没有满
        {
            [_radar.arrayDot put:dot];//添加圆点到数组
            [_dots put:dot];//加入到数组
            
            [dot moveInWithDuration:_radar.dotMoveInTime];//执行动画
        }
        
        [_radar.arrayAdd deleteMember:dot];//从雷达的添加数组中删除
    }
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"KATRadarDotSet(%i)(%i/%i): placement(%.1f,%.1f), area(%.1f,%.1f)",_num,_dots.length,_dots.capacity,_placement.x,_placement.y,_area.width,_area.height];
}

- (void)dealloc
{
//    NSLog(@"%@ is delloc!",self);
    
    [_message release];
    [_object release];
    [_dots release];
    [_addQueue release];
    [_removeQueue release];
    
    
    [super dealloc];
}

@end
