//
//  KATRadarData.m
//  KATRadar
//
//  Created by Kantice on 15/10/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  

#import "KATRadarData.h"



@implementation KATRadarData



- (NSString *)description
{
    return [NSString stringWithFormat:@"KATRadarData(%i):%.2lf",self.num,self.value];
}


- (void)dealloc
{
    [_message release];
    [_object release];
    
    [super dealloc];
}

@end
