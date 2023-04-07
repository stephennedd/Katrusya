/*
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedCompleteTaskButton extends StatefulWidget {
  final VoidCallback onPressed;

  AnimatedCompleteTaskButton({required this.onPressed});

  @override
  _AnimatedCompleteTaskButtonState createState() =>
      _AnimatedCompleteTaskButtonState();
}

class _AnimatedCompleteTaskButtonState
    extends State<AnimatedCompleteTaskButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _audioPlayer = AudioPlayer();

  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPressed() async {
    String sound = "sounds/succes_bell.mp3";
    await _audioPlayer.setSource(AssetSource(sound));
    await _audioPlayer.play(AssetSource(sound));
    _controller.forward().then((value) => widget.onPressed());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                    width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedCompleteTaskButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isCompleted;

  AnimatedCompleteTaskButton({required this.onPressed, required this.isCompleted});

  @override
  _AnimatedCompleteTaskButtonState createState() =>
      _AnimatedCompleteTaskButtonState();
}

class _AnimatedCompleteTaskButtonState
    extends State<AnimatedCompleteTaskButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color _buttonColor = Colors.white;
  late AudioPlayer _audioPlayer;
  Color _textColor = Colors.green;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
    _buttonColor = _isCompleted ? Colors.green : Colors.white;
    _textColor = _isCompleted ? Colors.white : Colors.green;
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
    _audioPlayer = AudioPlayer();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() async {
    String sound = "sounds/done.mp3";
    if(!_isCompleted) {
      await _audioPlayer.play(AssetSource(sound));
    }
    _controller.forward().then((value) => _controller.reverse());
    setState(() {
      if(_isCompleted) {
        _buttonColor = Colors.white;
        _textColor = Colors.green;
        _isCompleted = false;
      } else {
        _buttonColor = Colors.green;
        _textColor = Colors.white;
        _isCompleted = true;
      }
    });
    widget.onPressed();
  }

  void _revertButton() {
    _controller.reset();
    setState(() {
      _buttonColor = Colors.white;
      _textColor = Colors.green;
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                color: _buttonColor,
                border: Border.all(
                  color: Colors.green,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isCompleted ? Icons.close : Icons.check_rounded,
                    color: _textColor,
                    size: 20,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}