#import "BuadsPlugin.h"


@implementation BuadsPlugin
BuAds *buAds;
UIViewController *mBuViewController;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"buads"
                                     binaryMessenger:[registrar messenger]];
    NSLog(@"registerWithRegistrar");
    BuRewardVerifyedStreamHandler* buRewardVerifyedStreamHandler = [[BuRewardVerifyedStreamHandler alloc] init];
    FlutterEventChannel* eventChannel =
    [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/buads"
                              binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:buRewardVerifyedStreamHandler];
    
    BuadsPlugin* instance = [[BuadsPlugin alloc] init];
    buAds=[[BuAds alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    mBuViewController = [[[[UIApplication sharedApplication]delegate] window]rootViewController];
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        NSLog(@"init");
        [buAds init:call.arguments[@"appId"]];
        result(@"success");
    }else if ([@"loadAd" isEqualToString:call.method]) {
         NSLog(@"loadAd");
        [buAds loadAd:call.arguments[@"slotID"] :call.arguments[@"uid"] ];
    } else if ([@"showRewardedVideoAd" isEqualToString:call.method]) {
        NSLog(@"showRewardedVideoAd");
        [buAds showRewardedVideoAd:mBuViewController];
        result(@"begin load");
    } else if ([@"isReady" isEqualToString:call.method]) {
    bool isReady=[buAds isAdValid];
        result(@(isReady));
    } else {
        result(FlutterMethodNotImplemented);
    }
    

}

@end



@implementation BuRewardVerifyedStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    NSLog(@"注册金币回调");
    [buAds addRewardVerifyedHandler:^(NSString* result) {
    
        eventSink(result);
    }];
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    return nil;
}

@end
