import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  MyAppBar({Key? key,
    required this.title,
    this.backgroundColor = appBarColor,
    this.hasAction = false,
    this.icon,
    this.onTap
  }) : super(key: key);
  final String title;
  Color backgroundColor;
  bool hasAction;
  final icon;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: const BackButton(
        color: textColor,
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 26,
            color: textColor,
            fontWeight: FontWeight.w700
        ),),
      actions: hasAction ? <Widget> [
        IconButton(
          icon: icon,
          tooltip: 'Go to leaderboard',
          onPressed: onTap
        )
      ] : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
