import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('buads');
const EventChannel _buAdEventChannel =
    EventChannel('plugins.flutter.io/buads');
Stream<String> _buAdEvents;

/// A broadcast stream of events from the device gyroscope.
Stream<String> get buAdEvents {
  if (_buAdEvents == null) {
    _buAdEvents = _buAdEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => event.toString());
  }
  return _buAdEvents;
}

init(String appId) async {
  final Map<String, dynamic> params = {};
  params['appId'] = appId;
  return await _channel.invokeMethod('init', params);
}

loadAd(String slotID, String uid) async {
  final Map<String, dynamic> params = {};
  params['slotID'] = slotID;
  params['uid'] = uid;
  return await _channel.invokeMethod('loadAd', params);
}

showRewardedVideoAd() async {
  await _channel.invokeMethod('showRewardedVideoAd');
}

isBuAdReady() async {
  return await _channel.invokeMethod('isReady');
}