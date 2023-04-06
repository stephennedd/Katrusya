import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final double value;

  MyCircularProgressIndicator({this.strokeWidth = 4.0, this.value = 0.0});

  @override
  _MyCircularProgressIndicatorState createState() =>
      _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState
    extends State<MyCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation =
        Tween(begin: 0.0, end: widget.value).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.forward();
  }

  @override
  void didUpdateWidget(MyCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animationController.reset();
      _animation =
          Tween(begin: 0.0, end: widget.value).animate(_animationController);
      _animationController.forward();
    }
  }

  // @override
  // void didUpdateWidget(MyCircularProgressIndicator oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.value != oldWidget.value) {
  //     _animationController.reset();
  //     _animation = Tween(begin: 0.0, end: widget.value).animate(_animationController);
  //     _animationController.forward();
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Color barColor = widget.value >= 0.5? Colors.green : Colors.red;
    Color barColor;
    if (widget.value >= 0 && widget.value <= 0.5) {
      barColor = Colors.red;
    } else if (widget.value > 0.5 && widget.value <= 0.7) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.green;
    }
    // _animationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    // _animation =
    //     Tween(begin: 0.0, end: widget.value).animate(_animationController);
    // _animationController.forward();

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              value: _animation.value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              "${(_animation.value * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
