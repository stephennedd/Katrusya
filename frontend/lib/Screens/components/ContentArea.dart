import 'package:flutter/material.dart';

class ContentArea extends StatelessWidget {
  final bool addPadding;
  final Widget child;

  const ContentArea({super.key, required this.addPadding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      child: Ink(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 240, 237, 255)),
        padding: addPadding
            ? EdgeInsets.only(top: 25, left: 25, right: 25)
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
