import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('buads');
const EventChannel _gyroscopeEventChannel =
    EventChannel('plugins.flutter.io/sensors/gyroscope');
Stream<String> _gyroscopeEvents;

/// A broadcast stream of events from the device gyroscope.
Stream<String> get gyroscopeEvents {
  if (_gyroscopeEvents == null) {
    _gyroscopeEvents = _gyroscopeEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => event.toString());
  }
  return _gyroscopeEvents;
}

init(String appId) async {
  final Map<String, dynamic> params = {};
  params['appId'] = appId;
  await _channel.invokeMethod('init', params);
}

loadAd(String slotID, String uid) async {
  final Map<String, dynamic> params = {};
  params['slotID'] = slotID;
  params['uid'] = uid;
  await _channel.invokeMethod('loadAd', params);
}

showRewardedVideoAd() async {
  await _channel.invokeMethod('showRewardedVideoAd');
}
