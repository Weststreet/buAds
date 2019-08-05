#import "BuadsPlugin.h"


@implementation BuadsPlugin
BuAds *buAds;
UIViewController *mViewController;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"buads"
            binaryMessenger:[registrar messenger]];
  BuadsPlugin* instance = [[BuadsPlugin alloc] init];
  buAds=[[BuAds alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  mViewController = [[[[UIApplication sharedApplication]delegate] window]rootViewController];
    
    RewardVerifyedStreamHandler* rewardVerifyedStreamHandler = [[RewardVerifyedStreamHandler alloc] init];
    FlutterEventChannel* eventChannel =
    [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/gyroscope"
                              binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:rewardVerifyedStreamHandler];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [buAds init:call.arguments[@"appId"]];
    }else if ([@"loadAd" isEqualToString:call.method]) {
        [buAds loadAd:call.arguments[@"slotID"] :call.arguments[@"uid"] ];
    } else if ([@"showRewardedVideoAd" isEqualToString:call.method]) {
        [buAds showRewardedVideoAd:mViewController];
    } else if ([@"isAdValid" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[buAds isAdValid]]);
    } else {
        result(FlutterMethodNotImplemented);
    }
    
    
}

@end



@implementation RewardVerifyedStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    [buAds addRewardVerifyedHandler:^(NSString * _Nonnull result) {
        eventSink(result);
    }];
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    return nil;
}

@end
