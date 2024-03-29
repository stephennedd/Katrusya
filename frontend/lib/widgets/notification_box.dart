import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Themes/app_colors.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({Key? key, this.notifiedNumber = 0, this.onTap}) : super(key: key);
  final int notifiedNumber;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: appBarColor,
            ),
        child: notifiedNumber > 0
            ? Badge(
                alignment: AlignmentDirectional.topStart,
                smallSize: 8,
                backgroundColor: Colors.red,
                child: SvgPicture.asset(
                    "assets/icons/wallet.svg",
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(primaryDark, BlendMode.srcIn)
                ),
              )
            : SvgPicture.asset(
                "assets/icons/wallet.svg",
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(primaryDark, BlendMode.srcIn)
              ),
      ),
    );
  }
}
