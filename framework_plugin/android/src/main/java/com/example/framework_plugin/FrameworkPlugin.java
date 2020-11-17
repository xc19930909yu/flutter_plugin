package com.example.framework_plugin;

import android.nfc.Tag;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.map.geolocation.TencentLocation;
import com.tencent.map.geolocation.TencentLocationListener;
import com.tencent.map.geolocation.TencentLocationManager;
import com.tencent.map.geolocation.TencentLocationRequest;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FrameworkPlugin */
public class FrameworkPlugin implements FlutterPlugin, MethodCallHandler , TencentLocationListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // 记录flutter的调用
  private  MethodCall methodCall;

  private  Result callResult;

  private TencentLocationManager mLocationManager;



  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    // 获取定位实例
    mLocationManager = TencentLocationManager.getInstance(flutterPluginBinding.getApplicationContext());
    // 定位请求
    TencentLocationRequest request = TencentLocationRequest.create();
    // 用户可以自定义定位间隔，时间单位为毫秒，不得小于1000毫秒:
    request.setInterval(1000);

    //设置请求级别
    request. setRequestLevel(TencentLocationRequest. REQUEST_LEVEL_ADMIN_AREA);
    //是否允许使用GPS
    request.setAllowGPS(true);
    //是否需要获取传感器方向
    request. setAllowDirection(true);
    //是否需要开启室内定位
    request.setIndoorLocationMode(true);
    // 单次定位
    mLocationManager.requestSingleFreshLocation(null,this, Looper.getMainLooper());
    Log.i("FrameworkPlugin", "开始请求定位信息");

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "framework_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
    methodCall = call;
    callResult = result;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  /**
   *  停止定位
   */
  private  void  stopLocate(){
    mLocationManager.removeUpdates(this);
  }

  /**
   *   定位接口的返回
   */
  @Override
  public void onLocationChanged(TencentLocation tencentLocation, int i, String s) {

    if (tencentLocation != null){
      String locationStr =  tencentLocation.getName();
      if (!locationStr.isEmpty()){
        if (methodCall.method.equals("getPlatformVersion")){
          Log.i("FrameworkPlugin","请求到的位置信息" + locationStr);
          callResult.success("Android手机在的位置" + locationStr);
        }else {
          callResult.notImplemented();
        }
      }
    }
  }

  @Override
  public void onStatusUpdate(String s, int i, String s1) {

  }
}
