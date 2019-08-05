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

@interface BuAds : NSObject <BURewardedVideoAdDelegate>
- (void)init:(NSString*)appId;
- (void)showRewardedVideoAd:(NSString *)slotID :(NSString *)uid;
@property BURewardedVideoAd *rewardedVideoAd;
@end

NS_ASSUME_NONNULL_END
