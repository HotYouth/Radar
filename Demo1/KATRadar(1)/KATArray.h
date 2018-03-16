//
//  KATArray.h
//  KATUtil
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  存储id类型的数组

#import <Foundation/Foundation.h>


//数组最大容量
#define KAT_ARRAY_CAPACITY (1024)


@interface KATArray : NSObject<NSCopying>

{
    @private
    __unsafe_unretained id   *_member;
}

#pragma mark - 属性

//所存储的数组长度
@property(nonatomic,assign,readonly) int length;

//数组的最大容量
@property(nonatomic,assign,readonly) int capacity;

//json描述模式
@property(nonatomic,assign) BOOL isJsonDescription;


#pragma mark - 类方法

//构造方法
+ (KATArray *)array;

//设置数组容量的构造方法
+ (KATArray *)arrayWithCapacity:(int)capacity;


#pragma mark - 对象方法

//添加数组成员，成功则返回YES
- (BOOL)put:(id)value;

//根据索引获取数组成员，失败则返回nil
- (id)get:(int)index;

//设置成员数据
- (BOOL)set:(int)index withValue:(id)value;

//从指定的位置插入数据，成功则返回YES
- (BOOL)put:(id)value withIndex:(int)index;

//从指定的位置添加数组，成功则返回YES
- (BOOL)putArray:(KATArray *)array withIndex:(int)index;

//从指定的位置添加NSArray，成功则返回YES
- (BOOL)putNSArray:(NSArray *)array withIndex:(int)index;

//从一个带分隔符的字符串中添加NSString成员，从第一个分隔符开始查找，到最后一个分隔符结束，如果blank值是YES则把空白也当作成员，否则则忽略空白，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andBlank:(BOOL)blank;

//根据range获取成员数组，失败则返回nil
- (KATArray *)getFormRange:(NSRange)range;

//删除数组成员，成功则返回YES
- (BOOL)deleteFromIndex:(int)index;

//交换成员位置
- (BOOL)changePositionWithIndexA:(int)a andIndexB:(int)b;

//删除数组成员
- (BOOL)deleteMember:(id)member;

//是否包含数组成员
- (BOOL)hasMember:(id)member;

//所有成员向前移动
- (void)forwardByStep:(int)step;

//所有成员向后移动
- (void)backwardByStep:(int)step;

//获取index
- (int)getIndexWithMember:(id)member;

//根据range删除数组成员，成功则返回YES
- (BOOL)deleteFromRange:(NSRange)range;

//数组排序
- (void)sort;

//数组反序
- (void)reverse;

//清空数组
- (void)clear;

//是否已经存满
- (BOOL)isFull;

//转化成NSArray
- (NSArray *)getNSArray;

//描述
- (NSString *)description;

//数组复制
- (id)copyWithZone:(NSZone *)zone;

//内存释放
- (void)dealloc;




@end
