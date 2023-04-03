import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class SliverAppBarBox extends StatelessWidget implements PreferredSizeWidget {
  SliverAppBarBox({Key? key, required this.title, this.backgroundColor = appBarColor, this.elevation = 0.5, this.centerTitle = true}) : super(key: key);
  final String title;
  Color backgroundColor;
  double elevation;
  bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.w700
        ),),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      floating: true,
      snap: false,
      elevation: elevation,
      automaticallyImplyLeading: false,
      pinned: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
