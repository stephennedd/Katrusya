import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';

class ProfileImageBox extends StatelessWidget {
  ProfileImageBox({Key? key, required this.onTap}) : super(key: key);
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children :
        [ const CircleAvatar(
          backgroundColor: lightGrey,
          radius: 65,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("images/ape.jpg"),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          height: 35,
          width: 35,
          child: IconButton(
            highlightColor: Colors.white,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey)
            ),
            onPressed: onTap,
            icon: const Icon(
              Icons.edit,
              color: lightGrey,
              size: 20,
            )
          ),
        ),
      ]
    );
  }
}
