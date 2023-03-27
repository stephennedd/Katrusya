import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  MyAppBar({Key? key, required this.title, this.backgroundColor = appBarColor}) : super(key: key);
  final String title;
  Color backgroundColor;

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
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
