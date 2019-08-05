//
//  BuAds.h
//  Runner
//
//  Created by sunxy on 2019/8/4.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^completionHandler)(NSInteger* coins);
@interface BuAds : NSObject <BURewardedVideoAdDelegate>
- (void)init:(NSString*)appId;
- (void)loadAd:(NSString *)slotID :(NSString *)uid;
- (void)showRewardedVideoAd:(UIViewController *)viewController;
- (bool)isAdValid;
-(void) addRewardVerifyedHandler:(completionHandler)handler;
@property BURewardedVideoAd *rewardedVideoAd;
@property (nonatomic, strong) completionHandler completionHandlers;
@end

NS_ASSUME_NONNULL_END
