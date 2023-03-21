import 'dart:async';

import 'package:flutter/material.dart';

class MyProgressIndicator extends StatefulWidget {
  @override
  _MyProgressIndicatorState createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator> {
  double _progressValue = 0.0;

  void _updateProgress() {
    setState(() {
      _progressValue += 0.1;
      if (_progressValue >= 1.0) {
        _progressValue = 0.0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Call _updateProgress() every 100 milliseconds
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      _updateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Indicator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading...'),
            SizedBox(height: 16.0),
            LinearProgressIndicator(value: _progressValue),
          ],
        ),
      ),
    );
  }
}
