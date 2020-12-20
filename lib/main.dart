import 'dart:convert';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//test

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  Animation<double> animation;
  AnimationController _controller;

  Animation<double> animation1;
  AnimationController _controller1;
  double scaleValue = 0.0;
  double containerOpacity = 0.7;
  double textOpacity = 1.0;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;
  CrossFadeState crossFadeState2 = CrossFadeState.showFirst;

  var containerAlign = Alignment.bottomCenter;
  String text1 = '';
  String text2 = '';
  double aspectRatio = 100;
  double scaleButton = 1;
  Map<String, String> data = {
    '1': "riadh",
    '2': 'mohamed',
    '3': 'sami',
    '4': 'amal',
    '5': "riadh",
    '6': 'mohamed',
    '7': 'sami',
    '8': 'amal'
  };

  void startScaleButton() {
    for (int i = 100; i >= 85; i--) {
      Future.delayed(Duration(milliseconds: 150));
      setState(() {
        scaleButton = double.parse(i.toString()) * 0.01;
      });
    }
  }

  void startAspectRatio() {
    for (int i = 100; i >= 5; i--) {
      Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        aspectRatio = double.parse(i.toString());
      });
    }
  }

  //todo bottomContainerHeight
  double bottomContainerHeight = 300;

  //todo topContainerHeight
  double topContainerHeight = 0;

  //todo CrossFadeState

  CrossFadeState fadeState=CrossFadeState.showFirst;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, // navigation bar color
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark // status bar color
        ));
    _controller = new AnimationController(
        vsync: this,
        duration: Duration(seconds: 25),
        reverseDuration: Duration(milliseconds: 25));
    animation = new CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _controller.forward(from: 0.6);

    animation.addListener(() {
      setState(() {
        scaleValue = animation.value;
      });
    });

    _controller1 = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        value: 1,
        reverseDuration: Duration(milliseconds: 200));
    animation1 = new CurvedAnimation(
      parent: _controller1,
      curve: Curves.linear,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          FlutterMap(
            options: new MapOptions(
              zoom: 13.0,
            ),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    builder: (ctx) => new Container(
                      child: new FlutterLogo(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: bottomContainerHeight - 300,
              child: Center(
                child: Text(
                  'Text example',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(0.0),
                    topRight: const Radius.circular(0.0),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  bottomContainerHeight = (MediaQuery.of(context).size.height -
                              (details.globalPosition.dy > 300
                                  ? details.globalPosition.dy
                                  : 300)) >
                          300
                      ? (MediaQuery.of(context).size.height -
                          (details.globalPosition.dy > 300
                              ? details.globalPosition.dy
                              : 300))
                      : 300;
                });
                print(bottomContainerHeight);
                print(MediaQuery.of(context).size.height-300);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                child: Center(
                  child: AnimatedCrossFade(
                    firstChild: Text(
                      'Text example',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    duration: Duration(milliseconds: 20),
                    secondChild: Text(
                      'Intigo Test',
                      style: Theme.of(context).textTheme.headline6,
                    ), crossFadeState:bottomContainerHeight>(MediaQuery.of(context).size.height-300)/2?CrossFadeState.showSecond:CrossFadeState.showFirst ,
                  ),
                ),
                height: bottomContainerHeight,
                decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffA22447).withOpacity(.05),
                          offset: Offset(0, 0),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ],
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
