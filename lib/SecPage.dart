import 'package:flutter/material.dart';

class SecPage extends StatefulWidget {
  @override
  _SecPageState createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Stack(children: [
        Hero(child: Image.asset('Assets/logo.png'),
        tag: 'anim',),
        Text('ok')
      ],),),
    );
  }
}
