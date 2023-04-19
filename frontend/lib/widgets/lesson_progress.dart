import 'package:flutter/material.dart';

class MyLinearProgressIndicator extends StatefulWidget {
  final double value;

  const MyLinearProgressIndicator({super.key, this.value = 0.0});

  @override
  _MyCircularProgressIndicatorState createState() =>
      _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState extends State<MyLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        Tween(begin: 0.0, end: widget.value).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.forward();
  }

  @override
  void didUpdateWidget(MyLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animationController.reset();
      _animation =
          Tween(begin: 0.0, end: widget.value).animate(_animationController);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
