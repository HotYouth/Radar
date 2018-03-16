//
//  KATQueue.h
//  KATUtil
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  队列类，采用先进先出的形式存放和获取节点，该类是以数组的形式存放节点

#import <Foundation/Foundation.h>


//队列数组默认的最大容量
#define KAT_QUEUE_CAPACITY (1024)


@interface KATQueue : NSObject<NSCopying>
{
    @private
    __unsafe_unretained id   *_member;//节点成员
    int _head;//头节点下标
    int _tail;//尾节点下标
}


#pragma mark - 属性

//所存储的数组长度
@property(nonatomic,assign,readonly) int length;

//数组的最大容量
@property(nonatomic,assign,readonly) int capacity;


#pragma mark - 类方法

//构造方法
+ (KATQueue *)queue;

//设置数组容量的构造方法
+ (KATQueue *)queueWithCapacity:(int)capacity;


#pragma mark - 对象方法

//在队尾添加节点，成功则返回YES
- (BOOL)put:(id)value;

//获取头节点，得到后将从队列中删除该头节点，失败则返回nil
- (id)get;

//获取头节点，但不在队列中删除
- (id)header;

//判断队列是否为空
- (BOOL)isEmpty;

//是否包含成员
- (BOOL)hasMember:(id)member;

//清除队列
- (void)clear;

//是否已经存满
- (BOOL)isFull;

//描述
- (NSString *)description;

//队列复制
- (id)copyWithZone:(NSZone *)zone;

//内存释放
- (void)dealloc;


@end
