import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Themes/app_colors.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({Key? key, required this.icon, this.activeColor = primary, this.color = primaryDark, this.isActive = false, this.onTap}) : super(key: key);
  final String icon;
  final Color activeColor;
  final Color color;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child:
        Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isActive ? primary : bottomBarColor,
            boxShadow: [
              if(isActive)
                BoxShadow(
                    color: shadowColor.withOpacity(.1),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0,0),
                )]
        ),
        child: SvgPicture.asset(icon, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
        ),
    );
  }
}
