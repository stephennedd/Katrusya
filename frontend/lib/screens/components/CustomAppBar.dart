import 'package:flutter/material.dart';
import 'package:frontend/Themes/custom_text_styles.dart';

import '../../widgets/leaderboard.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool showActionIcon;
  final VoidCallback? onMenuActionTap;
  const CustomAppBar(
      {super.key,
      this.title = '',
      this.showActionIcon = false,
      this.leading,
      this.titleWidget,
      this.onMenuActionTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Stack(
        children: [
          Positioned.fill(
              child: titleWidget == null
                  ? Center(
                      child: Text(
                        title,
                        style: appBarTS,
                      ),
                    )
                  : Center(
                      child: titleWidget,
                    )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading ??
                  Transform.translate(
                    offset: const Offset(-14, 0),
                    child: const BackButton(
                      color: Colors.white,
                    ),
                  ),
              if (showActionIcon)
                Transform.translate(
                  offset: const Offset(10, 0),
                  child: IconButton(
                    icon: const Icon(Icons.leaderboard_rounded,
                        color:
                            Colors.white), // Set the color of the back button
                    onPressed: onMenuActionTap ??
                        () {
                          showDialog(context: context, builder: (BuildContext context) {
                            return const LeaderboardPopup();
                          });
                        },
                    //Get.toNamed(TestOverviewScreen.routeName),
                  ),
                )
            ],
          )
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 80);
}
