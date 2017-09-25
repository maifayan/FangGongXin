//
//  FGXHomeController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXHomeController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "FGXMeController.h"



@interface FGXHomeController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
//高德地图
@property (nonatomic, strong) MAMapView          *mapView;
//坐标红点
@property (nonatomic, strong) UIImageView        *redWaterView;
//定位
@property (nonatomic, strong) UIButton           *locationBtn;
@property (nonatomic, strong) UIImage            *imageLocated;
@property (nonatomic, strong) UIImage            *imageNotLocate;

@property (nonatomic, assign) NSInteger          searchPage;
//缩放地图
@property (nonatomic, strong) UIView             *zoomPannelView;

//头像按钮
@property (nonatomic, strong) UIButton           *headBtn;

@end

@implementation FGXHomeController


+ (instancetype)FGXWithHomeController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [super viewDidAppear:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开启 HTTPS 功能
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //设置高德地图appKey
    [AMapServices sharedServices].apiKey = XM_GDMap_Appkey;
    
    //添加控件
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.redWaterView];
    [self.view addSubview:self.locationBtn];
    [self.view addSubview:self.zoomPannelView];
    [self.view addSubview:self.headBtn];
}

//按钮缩放地图
- (UIView *)makeZoomPannelView
{
    
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = NO;
}


//移动到当前用户位置
- (void)MoveCurrentUserPosition{
    
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
    [_mapView setZoomLevel:17 animated:YES];
}

//headBtnClick
- (void)headBtnClick{
    FGXMeController *meC = [FGXMeController FGXWithMeController];
    
    [self.navigationController pushViewController:meC animated:YES];
    
    
}


#pragma mark - 懒加载
- (MAMapView *)mapView{
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor whiteColor];
        [_mapView setDelegate:self];
        //设置地图类型
        //        _mapView.mapType = MAMapTypeStandard;
        //设置定位精度
        //    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        //    _mapView.distanceFilter = 5.0f;
        _mapView.zoomEnabled = YES;
        [_mapView setZoomLevel:16.5 animated:YES];
        //        _mapView.maxZoomLevel = 19;
        //        _mapView.minZoomLevel = 6;
        //开始定位
        _mapView.showsUserLocation = YES;
        //移动到当前用户位置
        _mapView.userTrackingMode  = MAUserTrackingModeFollow;
        //地图logo位置
        _mapView.logoCenter = CGPointMake(35, CGRectGetHeight(self.view.bounds)-60);
        // 设置成NO表示关闭指南针；YES表示显示指南针
        _mapView.showsCompass= YES;
        //设置指南针位置
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 48);
        //设置成NO表示不显示比例尺；YES表示显示比例尺
        _mapView.showsScale= YES;
        //设置比例尺位置
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x,48);

    }
    return _mapView;
}
//中心红点
- (UIImageView *)redWaterView{
    if (!_redWaterView) {
        UIImage *image = [UIImage imageNamed:@"wateRedBlank"];
        self.redWaterView = [[UIImageView alloc] initWithImage:image];
        
        self.redWaterView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, self.mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
        
        self.redWaterView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.mapView.bounds) / 2 - CGRectGetHeight(self.redWaterView.bounds) / 2);
        

    }
    return _redWaterView;
}
//定位
- (UIButton *)locationBtn{
    if (!_locationBtn) {
        self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
        self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
        
        self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kScreenH - 108, 40, 40)];
        self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.locationBtn.backgroundColor = [UIColor whiteColor];
        
        self.locationBtn.layer.cornerRadius = 3;
        [self.locationBtn addTarget:self action:@selector(MoveCurrentUserPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];

    }
    return _locationBtn;
}
//缩放地图
- (UIView *)zoomPannelView{
    if (!_zoomPannelView) {
       _zoomPannelView = [self makeZoomPannelView];
        _zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(_zoomPannelView.bounds) - 10,
                                            self.view.bounds.size.height -  CGRectGetMidY(_zoomPannelView.bounds) - 59);
        _zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _zoomPannelView;
}
//头像
- (UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setFrame:CGRectMake(10, 78, 60, 60)];
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"setup-head-default.png"] forState:UIControlStateNormal];
        //圆角
        _headBtn.layer.masksToBounds = YES;
        _headBtn.layer.cornerRadius  = 30;
        _headBtn.layer.borderWidth   = 5;
        _headBtn.layer.borderColor   = [[UIColor whiteColor] CGColor];
        [_headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

@end
