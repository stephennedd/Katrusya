import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Themes/app_colors.dart';

class BookmarkBox extends StatelessWidget {
  BookmarkBox({Key? key, this.isFavorited = false, this.onTap})
      : super(key: key);
  final bool isFavorited;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isFavorited ? primary : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.1),
                  spreadRadius: .5,
                  blurRadius: .5,
                  offset: const Offset(.5, .5))
            ]),
        child: SvgPicture.asset(
          "assets/icons/bookmark.svg",
          colorFilter: ColorFilter.mode(primaryDark, BlendMode.srcIn),
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}
