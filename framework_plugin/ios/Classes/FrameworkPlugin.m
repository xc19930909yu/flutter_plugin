#import "FrameworkPlugin.h"
#import <TencentLBS/TencentLBS.h>


@interface FrameworkPlugin() <TencentLBSLocationManagerDelegate>

// 定位管理器
@property (nonatomic, strong)TencentLBSLocationManager *locationManager;
@end


@implementation FrameworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"framework_plugin"
            binaryMessenger:[registrar messenger]];
  FrameworkPlugin* instance = [[FrameworkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)configLocationManager
{
    self.locationManager = [[TencentLBSLocationManager alloc]  init];
    [self.locationManager setDelegate:self];
    [self.locationManager setApiKey:@"E3TBZ-KU6LJ-UWKFI-KJO36-O3U5Z-DEFKD"];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // 需要后台定位的话，可以设置此属性为YES。
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    // 如果需要POI信息的话，根据所需要的级别来设定，定位结果将会根据设定的POI级别来返回，如：
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    // 申请的定位权限,得和在info.list申请的权限对应才有效
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}


// 单次定位
- (void)startSingleLocation{
    
}

// 连续定位
- (void)startSerialLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}


// 停止
- (void)stopSerialLocation {
    //停止定位
    [self.locationManager stopUpdatingLocation];
}



#pragma mark - FlutterPlugin
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  [self configLocationManager];
  
  // 单次定位
  [self.locationManager requestLocationWithCompletionBlock:^(TencentLBSLocation * _Nullable location, NSError * _Nullable error) {
      NSLog(@"%@,%@,%@", location.location, location.name, location.address);
       if ([@"getPlatformVersion" isEqualToString:call.method]) {
           result([@"iOS获取位置" stringByAppendingString:location.name]);  // [[UIDevice currentDevice] systemVersion]
       } else {
         result(FlutterMethodNotImplemented);
       }
  }];
    
}


#pragma mark - TencentLBSLocationManagerDelegate
- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
didFailWithError:(NSError *)error{
    
}


- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                didUpdateLocation:(TencentLBSLocation *)location{
    
    
}

@end
