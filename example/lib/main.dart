import 'package:flutter/material.dart';
import 'dart:async';

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
    init('5026194');
    loadAd('926194336', '10026');
    _streamSubscriptions.add(buAdEvents.listen((String result) {
      print('获得$result金币啊aa');
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
              isReady();
            },child: Text('isReady'),),
            FlatButton(onPressed: (){
              showRewardedVideoAd();
            },child: Text('显示视频'),),

          ],),
        ),
      ),
    );
  }
  isReady() async{
    bool isReady= await isBuAdReady();
    print("isReady==$isReady");
  }

}
