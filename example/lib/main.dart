import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:buads/buads.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];
  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(gyroscopeEvents.listen((String result) {
      print('获得$result金币啊');
    }));

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            FlatButton(onPressed: (){
              init('5026194');
            },child: Text('初始化'),),

            FlatButton(onPressed: (){
              loadAd('926194336', '10026');
            },child: Text('加载视频'),),
            FlatButton(onPressed: (){
              showRewardedVideoAd();
            },child: Text('显示视频'),),

          ],),
        ),
      ),
    );
  }
}
