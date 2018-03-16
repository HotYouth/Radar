//
//  KATQueue.m
//  KATUtil
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATQueue.h"

@implementation KATQueue


#pragma mark - 类方法

//构造方法
+ (KATQueue *)queue
{
    KATQueue *queue=[[[self alloc] init] autorelease];
    
    //初始化
    [queue initData:KAT_QUEUE_CAPACITY];
    
    return queue;
}


//设置数组容量的构造方法
+ (KATQueue *)queueWithCapacity:(int)capacity
{
    KATQueue *queue=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [queue initData:capacity];
    }
    else
    {
        [queue initData:KAT_QUEUE_CAPACITY];
    }
    
    return queue;
}



#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _length=0;
    _head=0;
    _tail=0;
    
    //给成员分配空间
    _member=(id *)malloc(sizeof(id)*capacity);
    
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _member[i]=nil;
    }
}


//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//获取member指针
- (id *)member
{
    return _member;
}


//获取头节点下标
- (int)head
{
    return _head;
}


//获取尾节点下标
- (int)tail
{
    return _tail;
}


//设置头节点下标
- (void)setHead:(int)value
{
    _head=value;
}


//设置尾节点下标
- (void)setTail:(int)value
{
    _tail=value;
}



#pragma mark - 对象方法

//在队尾添加节点，成功则返回YES
- (BOOL)put:(id)value
{
    //判断数组是否已经满员
    if(_length<_capacity)
    {
        //添加成员
        _member[_tail]=[value retain];
        
        _tail++;
        
        if(_tail==_capacity)//队列已经到了数组末尾
        {
            _tail=0;
        }
        
        _length++;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//获取头节点，得到后将从队列中删除该头节点，失败则返回nil
- (id)get
{
    if(_length>0)
    {
        id tmp=_member[_head];
        
        _member[_head]=nil;//置空
        
        _head++;
        
        if(_head==_capacity)//队列已经到了数组末尾
        {
            _head=0;
        }
        
        _length--;
        
        return [tmp autorelease];//不需要外面接收的代码释放内存
    }
    else
    {
        return nil;
    }
}


//获取头节点，但不在队列中删除
- (id)header
{
    //如果没有任何节点，也会返回nil
    return _member[_head];
}


//判断队列是否为空
- (BOOL)isEmpty
{
    if(_length>0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


//是否包含成员
- (BOOL)hasMember:(id)member
{
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                if(_member[i]==member)//找到
                {
                    return YES;
                }
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                if(_member[i]==member)//找到
                {
                    return YES;
                }
            }
            
            for(int i=0;i<_tail;i++)
            {
                if(_member[i]==member)//找到
                {
                    return YES;
                }
            }
            
        }
    }
    
    
    return NO;
}


//清除队列
- (void)clear
{
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
            for(int i=0;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
    }
    
    _length=0;
    _head=0;
    _tail=0;
}


//是否已经存满
- (BOOL)isFull
{
    if(_length<_capacity)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - 重载方法

//描述
- (NSString *)description
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATQueue: cap=%i, len=%i head=%i tail=%i\n{\n",_capacity,_length,_head,_tail];
    
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [ms appendFormat:@" %i --> %@ \n",i,_member[i]];
            }

        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [ms appendFormat:@" %i --> %@ \n",i,_member[i]];
            }
            
            for(int i=0;i<_tail;i++)
            {
                [ms appendFormat:@" %i --> %@ \n",i,_member[i]];
            }

        }
    }
    
    [ms appendString:@"}"];
    
    return ms;

}


//队列复制（数组成员指向的对象地址还是同一个）
- (id)copyWithZone:(NSZone *)zone
{
    KATQueue *queue=[[[self class] allocWithZone: zone]init];
    
    [queue initData:_capacity];
    
    queue.length=_length;
    [queue setHead:_head];
    [queue setTail:_tail];
    
    id *p=[queue member];//获取成员指针
    
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                p[i]=[_member[i] copy];
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                p[i]=[_member[i] copy];
            }
            
            for(int i=0;i<_tail;i++)
            {
                p[i]=[_member[i] copy];
            }
            
        }
    }

    
    return queue;
}


//内存释放
- (void)dealloc
{
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
            for(int i=0;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
    }

    
    free(_member);
    _member=nil;
    
    NSLog(@"KATQueue is dealloc");
    
    [super dealloc];
    
}


@end
