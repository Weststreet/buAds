package com.youban.buads;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdManager;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAppDownloadListener;
import com.bytedance.sdk.openadsdk.TTRewardVideoAd;

import io.flutter.Log;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * BuadsPlugin
 */
public class BuadsPlugin implements MethodCallHandler {

    private TTAdNative mTTAdNative;
    private TTRewardVideoAd mttRewardVideoAd;
    private Registrar registrar;
    private static EventChannel.EventSink eventSink;
    private boolean isReady=false;
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "buads");
        channel.setMethodCallHandler(new BuadsPlugin(registrar));

        final EventChannel eventChannel =
                new EventChannel(registrar.messenger(), "plugins.flutter.io/buads");

        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink sink) {
                eventSink=sink;
            }

            @Override
            public void onCancel(Object o) {

            }
        });
        //穿山甲SDK初始化
        //强烈建议在应用对应的Application#onCreate()方法中调用，避免出现content为null的异常
        TTAdManagerHolder.init(registrar.context());
    }

    private BuadsPlugin(Registrar registrar) {
        this.registrar = registrar;
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("init")) {
            initBuads();
            result.success("");
        } else if (call.method.equals("loadAd")) {
            loadAd((String) call.argument("uid"));
        } else if (call.method.equals("showRewardedVideoAd")) {
            showVideo();
            result.success("");
        } else if (call.method.equals("isReady")) {
            result.success(isReady);
        } else {
            result.notImplemented();
        }

    }

    void initBuads() {
        //step1:初始化sdk
        TTAdManager ttAdManager = TTAdManagerHolder.get();
//        //step2:(可选，强烈建议在合适的时机调用):申请部分权限，如read_phone_state,防止获取不了imei时候，下载类广告没有填充的问题。
        TTAdManagerHolder.get().requestPermissionIfNecessary(registrar.context());
        //step3:创建TTAdNative对象,用于调用广告请求接口
        mTTAdNative = ttAdManager.createAdNative(registrar.context());
    }

    void showVideo() {
        Log.d("TAG","showAdVideo");
        if (mttRewardVideoAd != null) {
            //step6:在获取到广告后展示
            //该方法直接展示广告
            mttRewardVideoAd.showRewardVideoAd(registrar.activity());
            mttRewardVideoAd = null;
        }
    }

    private boolean mHasShowDownloadActive = false;

    private void loadAd(String uid) {
        //部分机型需要主动申请权限，如 READ_PHONE_STATE权限
        TTAdManagerHolder.get().requestPermissionIfNecessary(registrar.context());
        //step4:创建广告请求参数AdSlot,具体参数含义参考文档
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId("930241137")
                .setSupportDeepLink(true)
                .setImageAcceptedSize(1080, 1920)
                .setRewardName("金币") //奖励的名称
                .setRewardAmount(2)  //奖励的数量
                .setUserID(uid)//用户id,必传参数
                .setMediaExtra("media_extra") //附加参数，可选
                .setOrientation(TTAdConstant.HORIZONTAL) //必填参数，期望视频的播放方向：TTAdConstant.HORIZONTAL 或 TTAdConstant.VERTICAL
                .build();
        //step5:请求广告
        mTTAdNative.loadRewardVideoAd(adSlot, new TTAdNative.RewardVideoAdListener() {
            @Override
            public void onError(int code, String message) {
            }

            //视频广告加载后，视频资源缓存到本地的回调，在此回调后，播放本地视频，流畅不阻塞。
            @Override
            public void onRewardVideoCached() {
                isReady=true;
                if(eventSink!=null) {
                    eventSink.success("视频加载成功|3");
                }
            }

            //视频广告的素材加载完毕，比如视频url等，在此回调后，可以播放在线视频，网络不好可能出现加载缓冲，影响体验。
            @Override
            public void onRewardVideoAdLoad(TTRewardVideoAd ad) {
                mttRewardVideoAd = ad;
                mttRewardVideoAd.setRewardAdInteractionListener(new TTRewardVideoAd.RewardAdInteractionListener() {

                    @Override
                    public void onAdShow() {
                        if(eventSink!=null) {
                            eventSink.success("视频加载成功|3");
                            Log.d("TAG","onAdShow");
                        }else{
                            Log.d("TAG","onAdShow null");
                        }
                    }

                    @Override
                    public void onAdVideoBarClick() {
                        if(eventSink!=null) eventSink.success("用户点击了视频|1");
                    }

                    @Override
                    public void onAdClose() {
                        if(eventSink!=null) eventSink.success("关闭了视频|2");
                    }

                    //视频播放完成回调
                    @Override
                    public void onVideoComplete() {
                    }

                    @Override
                    public void onVideoError() {
                        if(eventSink!=null) eventSink.success("视频加载失败|5");
                    }

                    //视频播放完成后，奖励验证回调，rewardVerify：是否有效，rewardAmount：奖励梳理，rewardName：奖励名称
                    @Override
                    public void onRewardVerify(boolean rewardVerify, int rewardAmount, String rewardName) {
                        if(rewardVerify) {
                            if(eventSink!=null) eventSink.success("恭喜你获得%ld枚金币！|0");
                        }
                    }

                    @Override
                    public void onSkippedVideo() {
                    }
                });
                mttRewardVideoAd.setDownloadListener(new TTAppDownloadListener() {
                    @Override
                    public void onIdle() {
                        mHasShowDownloadActive = false;
                    }

                    @Override
                    public void onDownloadActive(long totalBytes, long currBytes, String fileName, String appName) {
                        if (!mHasShowDownloadActive) {
                            mHasShowDownloadActive = true;
                        }
                    }

                    @Override
                    public void onDownloadPaused(long totalBytes, long currBytes, String fileName, String appName) {
                    }

                    @Override
                    public void onDownloadFailed(long totalBytes, long currBytes, String fileName, String appName) {
                    }

                    @Override
                    public void onDownloadFinished(long totalBytes, String fileName, String appName) {
                    }

                    @Override
                    public void onInstalled(String fileName, String appName) {
                    }
                });
            }
        });
    }




}
