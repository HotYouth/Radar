//
//  ViewController.m
//  Demo1
//
//  Created by 象萌cc002 on 15/10/20.
//  Copyright (c) 2015年 象萌cc002. All rights reserved.
//
#define PI 3.1415926
#import "ViewController.h"
#import "UIImageView+WebCache.h"


@interface ViewController (){
    NSArray *_dataSource;
    NSMutableArray *_distanceArray;
    CGFloat _lastValue;
    NSArray *_lastArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _distanceArray  = [NSMutableArray array];
//    _lastArray = [NSMutableArray array];
    _dataSource = @[@{@"lat":@"30.305457",@"lon":@"120.122889",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/15080176015_1440064076872.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:n6yKwVt_oNLjHdaBn6gUqyMWZKs="},@{@"lat":@"30.303087",@"lon":@"120.10636",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/13779851895_1444912868908.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:RjZ74AjQmMnbKS1NTdhSoeDIpcw="},@{@"lat":@"30.306018",@"lon":@"120.114984",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/13989476616_1442751707583.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:hwu9QlANM52HABanE5r3jUe26ZI="},@{@"lat":@"30.285188",@"lon":@"120.121451",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/18668099911_1442798433667.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:FDgyGpLSbnDIrEUaxkxJ9DMawGI="},@{@"lat":@"30.275146",@"lon":@"120.112253",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/15286826984_1443597418652.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:LeCH6Jl5-RjtrLsx_ldKSU7e2wI="},@{@"lat":@"30.28525",@"lon":@"120.141214",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/13569421009_1444442613046.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:H8IG-mx0erMPlBssHJwxpzs-sEI="},@{@"lat":@"30.277454",@"lon":@"120.137621",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/15038137597_1442569916763.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:_7i9FWk1c0zmH7C0fPZ0iK3NfH8="},@{@"lat":@"30.305769",@"lon":@"120.142076",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/13646718784_1442976153491.png?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:GmRubqLy4ssa58nbGMgS1DvFPiU="},@{@"lat":@"30.263355",@"lon":@"120.064247",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/13067227106_1440060309373.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:UajpI9ocjHlroLHfDxXK1Lgaxx8="},@{@"lat":@"30.263355",@"lon":@"120.064247",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/12480387739_1440060309404.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:0OOzL79yIvGu9kXIjZ2iTCF-jsE="},@{@"lat":@"30.314249",@"lon":@"120.069709",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/14088891734_1440060309461.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:UZ0Gy2GtsDmn-AVtkVp-WZVLkEE="},@{@"lat":@"30.32011",@"lon":@"120.092849",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/12768157831_1440060309589.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:ZJ9mtLXTIXQSAYo7GglRamqA4qA="},@{@"lat":@"30.246884",@"lon":@"120.106935",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/17759783771_1440060309709.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:pDj7mZ7OsHYiqrXLWiDktHRoUAE="},@{@"lat":@"30.250628",@"lon":@"120.152928",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/15298021270_1440060309805.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:CaEHNxTLUea4y643V6_bzk-iQFs="},@{@"lat":@"30.282194",@"lon":@"120.100754",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/14395380745_1440060309958.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:rf2AzMbsNKW2PwGkAELkHFCzGyY="},@{@"lat":@"30.228163",@"lon":@"120.177649",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/17674006256_1440060309995.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:cuoBlsp45vEeCkYObDLcPbILEjY="},@{@"lat":@"30.206692",@"lon":@"120.102335",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/11278811805_1440060310134.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:JkdgVE3UXOeqlZo7OAWuZM0ZdAI="},@{@"lat":@"30.247383",@"lon":@"120.151778",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/10816805658_1440060310192.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:HXTmjtXYEK72mhQFg_mlcpXfVbM="},@{@"lat":@"30.221673",@"lon":@"120.154078",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/17884320863_1440060310222.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:pcVhwxK20MdYK0thtzKdpufd-CU="},@{@"lat":@"30.237399",@"lon":@"120.080201",@"url":@"http://7xl7ez.com2.z0.glb.qiniucdn.com/12925310770_1440060310303.jpg?imageView2/0/w/250/h/250&e=2050120766&token=VqHfzw0lbVDwQmS43z8S5r0A7RzKmCzSZVqD7ycJ:b0xnLvCL4hHB_Pn0Ntg_B3P0hd0="}];
    
    for (int i = 0; i < _dataSource.count; i++) {
        [_distanceArray addObject:@{[NSString stringWithFormat:@"%d",i]:[NSString stringWithFormat:@"%f",[self LantitudeLongitudeDist:[[_dataSource[i] objectForKey:@"lon"] floatValue] other_Lat:[[_dataSource[i] objectForKey:@"lat"] floatValue] self_Lon:120.122194 self_Lat:30.298182]]}];
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(0, scrollView.bounds.size.height + 0.5);
    [self.view addSubview:scrollView];
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UITapGestureRecognizer *tap = nil;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, size.height - 100, size.width*0.2, 50)];
    lab.text = @"开始";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:24.0f];
    lab.userInteractionEnabled = YES;
    [scrollView addSubview:lab];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTap1)];
    [lab addGestureRecognizer:tap];
    
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(size.width *0.2, size.height - 100, size.width*0.2, 50)];
    lab2.text = @"暂停";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:24.0f];
    lab2.userInteractionEnabled = YES;
    [scrollView addSubview:lab2];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTap2)];
    [lab2 addGestureRecognizer:tap];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(size.width *0.4, size.height - 100, size.width*0.2, 50)];
    lab3.text = @"滑出";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont systemFontOfSize:24.0f];
    lab3.userInteractionEnabled = YES;
    [scrollView addSubview:lab3];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTap3)];
    [lab3 addGestureRecognizer:tap];

    
//    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(40, size.height - 44, size.width - 80, 44)];
//    slider.minimumValue = 0;
//    slider.maximumValue = 15000;
//    slider.value = 0;
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [scrollView addSubview:slider];

    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.radar = [KATRadar radarWithFrame:CGRectMake(27.5, 80, 320, 320)];
    self.radar.eventDelegate = self;
    _radar.numberOfSector=8;
    _radar.scanDirection = 1;
    _radar.radiusScanner= 1;
    _radar.radiusOffsetScanner = 0;
    _radar.dotSetExecuteFrequency=10;
//    _radar.photoAlbumsBorderWidth = 2.0;
    _radar.dotRadius = 0.3;
    _radar.dotBorderWidth = 1.0;
    _radar.dotHeartbeatScale = 2.0;
//    _radar.photoMoveOutTime = 0.2;
    _radar.photoMoveInTime = 1.0;
    _radar.dotMoveOutTime = 0.5;
    [self.radar initRadar];
    [scrollView addSubview:self.radar];
    
}

-(void)labTap1{
    [self.radar scanStart];
}

-(void)labTap2{
    if(_radar.scanState==RADAR_SCAN_STATE_PAUSE){
        [self.radar scanResume];
    }else if(_radar.scanState == RADAR_SCAN_STATE_RUN){
        [self.radar scanPause];
    }
    
    for (int i = 0; i < 30; i ++) {
        KATRadarDot *dot = [KATRadarDot dotWithSize:CGSizeMake(25, 25) andColor:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0] andRadar:self.radar];
        dot.num = i;
        dot.value = i*10.0;
        [dot initDot];
        [self.radar addData:dot];
    }
    KATRadarPhoto *photo1 = [[self.radar.arrayPhoto getNSArray] firstObject];
    NSLog(@"%f",photo1.value);
//    NSLog(@"%@",[[self.radar.arrayPhoto getNSArray] firstObject]);
    NSArray *array = [self.radar.arrayPhoto getNSArray];
   
    for (int i = 0; i < _dataSource.count; i ++) {
        KATRadarPhoto* photo = [KATRadarPhoto photoWithSize:CGSizeMake(50, 50) andImage:nil andRadar:self.radar];
        //    _photo
//        NSLog(@"")
        
        NSString *key = [[[_dataSource[i] objectForKey:@"url"] componentsSeparatedByString:@"?"] firstObject];
        BOOL isCache = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
        if (isCache) {
            photo.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            photo.num = i;
            photo.value = [[_distanceArray[i] objectForKey:[NSString stringWithFormat:@"%d",i]] floatValue];
            [photo initPhoto];
            
            for (KATRadarPhoto *temp in array) {
                if (temp.num == photo.num) {
                    NSLog(@"存在");
//                    break;
                    NSLog(@"%d",photo.num);
                }else{
                    NSLog(@"不存在");
                }
                break;
            }
            
            [_radar addData:photo];
        }else{
            dispatch_async(dispatch_queue_create("loadImage", DISPATCH_QUEUE_SERIAL), ^{
                NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[_dataSource[i] objectForKey:@"url"]]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                }else{
                    photo.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                    //                }
                    photo.num = i;
                    photo.value = [[_distanceArray[i] objectForKey:[NSString stringWithFormat:@"%d",i]] floatValue];
                    //        photo.cornerRadius = 0.5;
                    [photo initPhoto];
                    
                    [_radar addData:photo];
                });
            });

        }
    }

   
//    [_radar addData:_photo];
    
}

/*
-(void)sliderValueChanged:(UISlider *)slider{
    if (_lastValue < slider.value) {
        [_distanceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat distance = [[obj objectForKey:[NSString stringWithFormat:@"%ld",idx]] floatValue];
//            NSLog(@"%f  \n %@",distance,obj);
            if (distance > _lastValue && distance < slider.value) {
                NSLog(@"%ld",idx);
                KATRadarPhoto* photo = [KATRadarPhoto photoWithSize:CGSizeMake(50, 50) andImage:nil andRadar:self.radar];
                NSString *key = [[[_dataSource[idx] objectForKey:@"url"] componentsSeparatedByString:@"?"] firstObject];
                BOOL isCache = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
                if (isCache) {
                    photo.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
                    photo.num = idx;
                    photo.value = [[_distanceArray[idx] objectForKey:[NSString stringWithFormat:@"%ld",idx]] floatValue];
                    [photo initPhoto];
                    [_radar addData:photo];
                }else{
                    dispatch_async(dispatch_queue_create("loadImage", DISPATCH_QUEUE_SERIAL), ^{
                        NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[_dataSource[idx] objectForKey:@"url"]]];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            //                }else{
                            photo.image = image;
                            [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                            //                }
                            photo.num = idx;
                            photo.value = [_distanceArray[idx] floatValue];
                            //        photo.cornerRadius = 0.5;
                            [photo initPhoto];
                            
                            [_radar addData:photo];
                        });
                    });
                    
                }
                
            }
//            [_distanceArray removeObjectAtIndex:idx];
                 
        }];
    }else if(_lastValue > slider.value){
        NSLog(@"减少");
        [_radar removeDataFromValue:slider.value toValue:15000];
    }
    _lastValue = slider.value;
}
*/

-(void)labTap3{
//    [_radar removeDataFromValue:30 toValue:100];
    [_radar clearData];
    
}

-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378700.0f; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    //    NSLog(@"x1: %f  y1:%f  z1:%f",x1,y1,z1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    //    NSLog(@"x2:%f  y2:%f  z3:%f",x2,y2,z2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //    NSLog(@"d:%f",d);
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    //    NSLog(@"new %f",dist);
    if (dist < 1000) {
        dist = dist+ arc4random()%2000 + 1000;
    }
    return dist;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dataSelectInRadar:(KATRadar *)radar{
    NSArray *array = [radar getSelectedData];
    for (KATRadarData *data in array) {
        NSLog(@"%@",data);
    }
}
@end
