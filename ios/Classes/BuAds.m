//
//  BuAds.m
//  Runner
//
//  Created by sunxy on 2019/8/4.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "BuAds.h"


@implementation BuAds 
- (void)init:(NSString *)appId{
    [BUAdSDKManager setAppID:appId];
}

- (void)loadAd:(NSString *)slotID :(NSString *)uid{
    NSLog(@"slotId=%@",slotID);
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = uid;
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:slotID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
}
- (void)showRewardedVideoAd:(UIViewController*)viewController{
    
    [self.rewardedVideoAd showAdFromRootViewController:viewController];

}
- (bool)isAdValid {
    return [self.rewardedVideoAd isAdValid];
}
#pragma mark BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd data load success");
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.offset = CGPointMake(0, -100);
//    hud.label.text = @"reawrded data load success";
//    [hud hideAnimated:YES afterDelay:0.1];
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd video load success");
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.offset = CGPointMake(0, -100);
//    hud.label.text = @"reawrded video load success";
//    [hud hideAnimated:YES afterDelay:1];
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd video will visible");
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd video did close");
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd video did click");
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"rewardedVideoAd data load fail%ld",(long)error.code);
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.offset = CGPointMake(0, -100);
//    hud.label.text = @"rewarded video material load fail";
//    [hud hideAnimated:YES afterDelay:1];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"rewardedVideoAd play error");
    } else {
        NSLog(@"rewardedVideoAd play finish");
    }
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAd verify failedddddddddd");
    
    NSLog(@"Demo RewardNamertt == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
    NSLog(@"Demo RewardAmountdsfds == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"rewardedVideoAd verify succeed");
    NSLog(@"verify result: %@", verify ? @"success" : @"fail");
    
    NSLog(@"Demo RewardNameeeee == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
    NSLog(@"Demo RewardAmountttttt == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
    
    if(self.completionHandlers!=nil){
        NSLog(@"开始回调");
        self.completionHandlers((long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
    }else{
        NSLog(@"注册回调失败");
    }
}


-(void) addRewardVerifyedHandler:(completionHandler)handler {
    self.completionHandlers=handler;
}
@end
