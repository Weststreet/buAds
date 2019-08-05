#import "BuadsPlugin.h"


@implementation BuadsPlugin
BuAds *buAds;
UIViewController *mViewController;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"buads"
                                     binaryMessenger:[registrar messenger]];
    NSLog(@"registerWithRegistrar");
    RewardVerifyedStreamHandler* rewardVerifyedStreamHandler = [[RewardVerifyedStreamHandler alloc] init];
    FlutterEventChannel* eventChannel =
    [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/buads"
                              binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:rewardVerifyedStreamHandler];
    
    BuadsPlugin* instance = [[BuadsPlugin alloc] init];
    buAds=[[BuAds alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    mViewController = [[[[UIApplication sharedApplication]delegate] window]rootViewController];
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        NSLog(@"init");
        [buAds init:call.arguments[@"appId"]];
    }else if ([@"loadAd" isEqualToString:call.method]) {
         NSLog(@"loadAd");
        [buAds loadAd:call.arguments[@"slotID"] :call.arguments[@"uid"] ];
    } else if ([@"showRewardedVideoAd" isEqualToString:call.method]) {
        NSLog(@"showRewardedVideoAd");
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
    NSLog(@"注册金币回调");
    [buAds addRewardVerifyedHandler:^(NSString * _Nonnull result) {
        NSLog(@"%@",result);
        eventSink(result);
    }];
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    return nil;
}

@end
