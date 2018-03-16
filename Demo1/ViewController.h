//
//  ViewController.h
//  Demo1
//
//  Created by 象萌cc002 on 15/10/20.
//  Copyright (c) 2015年 象萌cc002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KATRadar.h"
@interface ViewController : UIViewController<KATRadarDataDelegate>

@property (nonatomic,retain)KATRadar *radar;
@property (nonatomic,retain)KATRadarDot *dot;

@property (nonatomic,retain)KATRadarPhoto *photo;
@end

