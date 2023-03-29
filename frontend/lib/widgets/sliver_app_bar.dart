import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class SliverAppBarBox extends StatelessWidget implements PreferredSizeWidget {
  SliverAppBarBox({Key? key, required this.title, this.backgroundColor = appBarColor, this.elevation = 1}) : super(key: key);
  final String title;
  Color backgroundColor;
  double elevation;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 26,
            color: textColor,
            fontWeight: FontWeight.w700
        ),),
      centerTitle: true,
      backgroundColor: backgroundColor,
      floating: true,
      snap: true,
      elevation: elevation
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
