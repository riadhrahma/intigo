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
        setState(() {
          scaleButton = 1.0;
          containerOpacity = 0.7;
          crossFadeState = CrossFadeState.showFirst;
          containerAlign = Alignment.bottomCenter;
          crossFadeState2 = CrossFadeState.showFirst;
          textOpacity = 1.0;
          aspectRatio = 100;
        });

        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            text1 = '51 Sharon St';
            text2 = 'Thue, 24 sep at PM-4:00 PM';
          });
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Transform.scale(
                  scale: 1 / (scaleValue > 0.6 ? scaleValue : 0.6),
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
                      AnimatedContainer(
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: Colors.white.withOpacity(containerOpacity),
                        duration: Duration(milliseconds: 200),
                      )
                    ],
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment: containerAlign,
              curve: Curves.decelerate,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedCrossFade(
                          firstChild: AnimatedOpacity(
                            opacity: textOpacity,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 200),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50, left: 24),
                              child: Text(
                                'Good afternoon jacob',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          secondChild: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50, right: 24, left: 34),
                                  child: AspectRatio(
                                    aspectRatio: aspectRatio,
                                    child: TextField(
                                      controller: controller1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color: Colors.grey, fontSize: 16),
                                      decoration: InputDecoration(
                                        hintText: "Thue, 24 sep at PM-4:00 PM",
                                        prefixIcon: Icon(
                                          Icons.animation,
                                          color: Colors.transparent,
                                        ),
                                        fillColor: Colors.grey.shade50,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24, right: 24, left: 0, bottom: 18),
                                  child: AspectRatio(
                                    aspectRatio: aspectRatio,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black),
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        Flexible(
                                          child: TextField(
                                            controller: controller2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.animation,
                                                color: Colors.transparent,
                                              ),
                                              fillColor: Colors.grey.shade50,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              filled: true,
                                              hintText: '51 Sharon St',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.6,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          crossFadeState: crossFadeState2,
                          duration: Duration(milliseconds: 200),
                        ),
                        //todo main button
                        InkWell(
                          onTap: () {
                            startScaleButton();
                            setState(() {
                              containerOpacity = 1.0;

                              textOpacity = 0.0;
                            });

                            Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                crossFadeState = CrossFadeState.showSecond;

                                containerAlign = Alignment.topCenter;
                              });
                            });

                            Future.delayed(Duration(milliseconds: 550), () {
                              setState(() {
                                crossFadeState2 = CrossFadeState.showSecond;
                              });
                            });

                            Future.delayed(Duration(milliseconds: 550), () {
                              setState(() {
                                startAspectRatio();
                              });
                            });
                          },
                          child: AnimatedCrossFade(
                            firstChild: Transform.scale(
                              scale: scaleButton,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 24, right: 24, bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 6,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 24,
                                        left: 24,
                                        right: 24,
                                        top: 24),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Where to?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fillColor: Colors.black,
                                          onPressed: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Text(
                                              'Schedule',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(left:14,right: 18,bottom: 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                    0.05 -
                                                12),
                                    child: Transform.scale(
                                      scale: scaleValue,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black),
                                        width: 12,
                                        height: 12,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: TextField(
                                        autofocus: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(
                                                color: Colors.grey, fontSize: 16),
                                        decoration: InputDecoration(
                                          hintText: "Where to?",
                                          prefixIcon: Icon(
                                            Icons.animation,
                                            color: Colors.transparent,
                                          ),
                                          fillColor: Colors.grey.shade50,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: crossFadeState,
                            duration: Duration(milliseconds: 600),
                          ),
                        ),
                        AnimatedCrossFade(
                          crossFadeState: crossFadeState2,
                          duration: Duration(milliseconds: 500),
                          secondChild: Column(
                              children: data.values.map((e) {
                            double height = 150;
                            Future.delayed(Duration(milliseconds: 1000), () {
                              //print('a');
                              setState(() {
                                height = 200;
                              });
                            });
                            Future.delayed(Duration(milliseconds: 500));
                            return AnimatedContainer(
                              height: 70,
                              duration: Duration(milliseconds: 300),
                              child: ListTile(
                                title: Text(
                                  e,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.9),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                            );
                          }).toList()),
                          firstChild: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: textOpacity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 24),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text('Saved Places',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text('Set location on map',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 24, left: 24, top: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(200),
                                          ),
                                          fillColor: Colors.green,
                                          onPressed: () {},
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.11),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: Icon(
                                                    Icons.directions_car,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Trips',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RawMaterialButton(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(200),
                                          ),
                                          fillColor: Colors.white,
                                          onPressed: () {},
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.11),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: Icon(
                                                    Icons.restaurant_menu,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  'Eats',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
