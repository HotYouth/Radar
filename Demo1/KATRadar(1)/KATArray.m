//
//  KATArray.m
//  KATUtil
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATArray.h"

@implementation KATArray


#pragma mark - 类方法

//构造方法
+ (KATArray *)array
{
    KATArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    [array initData:KAT_ARRAY_CAPACITY];
    
    return array;
}

+ (KATArray *)arrayWithCapacity:(int)capacity
{
    KATArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [array initData:capacity];
    }
    else
    {
        [array initData:KAT_ARRAY_CAPACITY];
    }
    
    return array;
}


#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _length=0;
    _isJsonDescription=NO;
    
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


#pragma mark - 对象方法

//添加数组成员，成功则返回YES
- (BOOL)put:(id)value
{
    if(value==nil)
    {
        return NO;
    }
    
    //判断数组是否已经满员
    if(_length<_capacity)
    {
        //添加成员
        _member[_length]=[value retain];
        _length++;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//根据索引获取数组成员，失败则返回nil
- (id)get:(int)index
{
    //判断index的范围
    if(index>=0&&index<_length)
    {
        return _member[index];
    }
    else
    {
        return nil;
    }
}


//设置成员数据
- (BOOL)set:(int)index withValue:(id)value
{
    //判断index的范围
    if(index>=0&&index<_length)
    {
        [_member[index] release];
        _member[index]=[value retain];
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//从指定的位置插入数据，成功则返回YES
- (BOOL)put:(id)value withIndex:(int)index
{
    if(!value || _length >= _capacity || index<0 || index>_length)//容量已满或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else
    {
        for(int i=_length;i>index;i--)
        {
            _member[i]=_member[i-1];
        }
        
        _member[index]=[value retain];
        
        _length++;
        
        return YES;
    }
}


//从指定的位置添加数组，成功则返回YES
- (BOOL)putArray:(KATArray *)array withIndex:(int)index
{
    if(array==nil || _length+array.length>_capacity || array.length<=0 || index<0 || index>_length)//容量不够，空数组或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else
    {
        for(int i=_length+array.length-1;i>=index+array.length;i--)
        {
            _member[i]=_member[i-array.length];
        }
        
        for(int i=index;i<index+array.length;i++)
        {
            _member[i]=[[array get:i-index] retain];
        }
        
        _length+=array.length;
        
        return YES;
    }
}



//从指定的位置添加NSArray，成功则返回YES
- (BOOL)putNSArray:(NSArray *)array withIndex:(int)index
{
    if(array==nil || _length+array.count>_capacity || array.count<=0 || index<0 || index>_length)//容量不够，空数组或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else
    {
        for(int i=_length+(int)array.count-1;i>=index+array.count;i--)
        {
            _member[i]=_member[i-array.count];
        }
        
        for(int i=index;i<index+array.count;i++)
        {
            _member[i]=[[array objectAtIndex:i-index] retain];
        }
        
        _length+=array.count;
        
        return YES;
    }
}



//从一个带分隔符的字符串中添加NSString成员，从第一个分隔符开始查找，到最后一个分隔符结束，如果blank值是YES则把空白也当作成员，否则则忽略空白，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andBlank:(BOOL)blank
{
    int count=0;//添加的成员个数
    
    NSRange range={0,0};
    NSString *str;//临时存放成员
    
    //先截去第一个分隔符
    range=[src rangeOfString:sep];//查找分隔符
    
    if(range.length==0)//没有找到任何分隔符则返回0
    {
        return 0;
    }
    
    src=[src substringFromIndex:(range.location+range.length)];//截去第一个分隔符
    
    while(YES)//找到第一个分隔符后遍历查找余下的内容，直到找不到分隔符后跳出循环
    {
        range=[src rangeOfString:sep];//查找下一个分隔符
        
        if(range.length==0)//没有找到分隔符
        {
            break;
        }
        else//找到分隔符
        {
            str=[src substringToIndex:range.location];//截取需要的内容
            
            if([str isEqualToString:@""])//判断是否为空字符串
            {
                if(blank)
                {
                    [self put:str];//添加到数组
                    count++;//计数器
                }
            }
            else
            {
                [self put:str];//添加到数组
                count++;//计数器
            }
        
            src=[src substringFromIndex:(range.location+range.length)];//截去分隔符
        }

    }
    
    
    return count;
}



//根据range获取成员数组，失败则返回nil
- (KATArray *)getFormRange:(NSRange)range;
{
    //判断range的范围
    if((range.location+range.length)<=_length)
    {
        KATArray *array=[KATArray arrayWithCapacity:(int)range.length];
        
        for(int i=(int)range.location,j=0;j<range.length;i++,j++)
        {
            [array put:_member[i]];
        }
        
        return array;
    }
    else
    {
        return nil;
    }
    
}


//删除数组成员，成功则返回YES
- (BOOL)deleteFromIndex:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        //释放内存
        [_member[index] release];
        
        //删除元素并前移数组
        for(int i=index;i<_length-1;i++)
        {
            _member[i]=_member[i+1];
        }
        
        _member[_length-1]=nil;//最后的成员赋空值
        
        _length--;
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//交换两个成员的位置
- (BOOL)changePositionWithIndexA:(int)a andIndexB:(int)b
{
    if(a>=0 && a<_length && b>=0 && b<_length && a!=b)//判断a，b下标范围
    {
        id tmp;
        
        tmp=_member[a];
        _member[a]=_member[b];
        _member[b]=tmp;
        
        return YES;
    }
    else
    {
        return NO;
    }
}



//删除数组成员，成功则返回YES
- (BOOL)deleteMember:(id)member
{
    int index=0;
    
    for(;index<_length;index++)
    {
        if(_member[index]==member)//找到
        {
            [_member[index] release];
            _member[index]=nil;
            
            //删除元素并前移数组
            for(int i=index;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _member[_length-1]=nil;//最后的成员赋空值
            
            _length--;
            
            break;
        }
    }
    
    if(index<_length+1)//找到
    {
 
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//是否包含数组成员
- (BOOL)hasMember:(id)member
{
    for(int index=0;index<_length;index++)
    {
        if(_member[index]==member)//找到
        {
            return YES;
        }
    }
    
    return NO;
}



//所有成员向前移动
- (void)forwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            id *tmp=(id *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=0;i<step;i++)//前step个成员移动到临时数组
            {
                tmp[i]=_member[i];
            }
            
            for(int i=0;i<_length-step;i++)//从0～length-step移动
            {
                _member[i]=_member[i+step];
            }
            
            for(int i=_length-step;i<_length;i++)//把临时数组的内容移动到成员数组末尾
            {
                _member[i]=tmp[i-_length+step];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}


//所有成员向后移动
- (void)backwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            id *tmp=(id *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=_length-1;i>=_length-step;i--)//后step个成员移动到临时数组
            {
                tmp[step+i-_length]=_member[i];
            }
            
            for(int i=_length-1;i>=step;i--)//从length~step移动
            {
                _member[i]=_member[i-step];
            }
            
            for(int i=0;i<step;i++)//把临时数组的内容移动到成员数组开头
            {
                _member[i]=tmp[i];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}



//获取index
- (int)getIndexWithMember:(id)member
{
    int index=-1;
    
    for(int i=0;i<_length;i++)
    {
        if(_member[i]==member)//找到
        {
            index=i;
            
            break;
        }
    }
    
    return index;
}


//根据range删除数组成员，成功则返回YES
- (BOOL)deleteFromRange:(NSRange)range
{
    //判断range的范围
    if((range.location-1+range.length)<_length)
    {
        //释放内存
        for(int i=(int)range.location;i<range.location+range.length;i++)
        {
            [_member[i] release];
        }
        
        //删除元素并前移数组
        for(int i=(int)range.location;i<_length-range.length;i++)
        {
            _member[i]=_member[i+range.length];
        }
        
        for(int i=_length-(int)range.length;i<_length;i++)
        {
            _member[i]=nil;//最后的成员赋空值
        }
        
        _length-=range.length;
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//数组反序
- (void)reverse
{
    id tmp=nil;
    
    for(int i=0;i<_length/2;i++)
    {
        tmp=_member[_length-1-i];
        _member[_length-1-i]=_member[i];
        _member[i]=tmp;
    }
    
    tmp=nil;
}


//数组排序，如果类型不一样则会发生错误
- (void)sort
{
    idQuickSort(_member,0,_length-1);
//    idBubbleSort(_member,_length);
}


#pragma mark - 排序算法

//快速排序
void idQuickSort(id arr[],int s,int e)
{
    if(s<e)
    {
        int m=idPartion(arr,s,e);//交换，得到中间位置
        
        idQuickSort(arr,s,m-1);//左边部分排序
        
        idQuickSort(arr,m+1,e);//右边部分排序
    }
}


int idPartion(id arr[],int s,int e)
{
    //rand
//    srand((unsigned)time( NULL));//随机数种子
//    int k=rand()%(e-s+1)+s;//随机产生数组下标，得到需要比较的数字
    int k=(e-s)/2+s;//中间数为需要比较的数字
    
    id key=arr[k];//存放需要比较的数字
    
    //将要比较的数存放在第一个位置
    arr[k]=arr[s];
    arr[s]=key;
    
    
    //    int tmp;//交换用的临时变量
    
    while(s<e)
    {
        while(s<e)
        {
            //寻找右边比tmp小的数
            if([arr[e] compare:key]==NSOrderedAscending)//<key)
            {
                arr[s]=arr[e];
                
                break;
            }
            else
            {
                e--;
            }
        }
        
        while(s<e)
        {
            //寻找左边比tmp大的数
            if([arr[s] compare:key]==NSOrderedDescending)//>key)
            {
                arr[e]=arr[s];
                
                break;
            }
            else
            {
                s++;
            }
            
        }
        
    }
    
    arr[e]=key;
    
    return e;
}


//冒泡排序
void idBubbleSort(id arr[],int length)
{
    BOOL flag=NO;
    
    id tmp;
    int j;
    
    for (int i=0;i<length;i++)
    {
        flag=YES;
        
        for (j=length-1;j>i;j--)
        {
            if([arr[j] compare:arr[j-1]]==NSOrderedAscending)  //<arr[j-1])
            {
                tmp=arr[j-1];
                arr[j-1]=arr[j];
                arr[j]=tmp;
                
                flag=NO;
            }
        }
        
        if(flag)
        {
            break;
        }
    }
}


//清空数组
- (void)clear
{
    for(int i=0;i<_length;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    _length=0;
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


//转化成NSArray
- (NSArray *)getNSArray
{
    NSMutableArray *array=[[[NSMutableArray alloc] init] autorelease];
    
    for(int i=0;i<_length;i++)
    {
        [array addObject:_member[i]];
    }
    
    return array;
}



#pragma mark - 重载方法

//描述
- (NSString *)description
{
    if(_isJsonDescription)//Json格式的描述
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"\n[\n"];
        
        for(int i=0;i<_length;i++)
        {
            if([_member[i] isKindOfClass:[NSString class]])//string类型的带引号
            {
                [ms appendFormat:@"  \"%@\"",_member[i]];
            }
            else
            {
                [ms appendFormat:@"  %@",_member[i]];
            }
            
            if(i<_length-1)
            {
                [ms appendFormat:@",\n"];
            }
            else
            {
                [ms appendFormat:@"\n"];
            }
        }
        
        [ms appendString:@"]"];
        
        return ms;
    }
    else
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"KATArray: cap=%i, len=%i \n{\n",_capacity,_length];
        
        for(int i=0;i<_length;i++)
        {
            [ms appendFormat:@" %i --> %@\n",i,_member[i]];
        }
        
        [ms appendString:@"}"];
        
        return ms;
    }
}


//数组复制（数组成员指向的对象地址还是同一个）
- (id)copyWithZone:(NSZone *)zone
{
    KATArray *array=[[[self class] allocWithZone: zone]init];
    
    [array initData:_capacity];
    
    array.length=_length;
    
    id *p=[array member];//获取成员指针
    
    for(int i=0;i<_length;i++)
    {
        p[i]=[_member[i] copy];
    }
    
    return array;
}


//内存释放
- (void)dealloc
{
    for(int i=0;i<_length;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    free(_member);
    _member=nil;
    
//    NSLog(@"KATArray(%i/%i) is dealloc",_length,_capacity);
    
    [super dealloc];
}



@end
