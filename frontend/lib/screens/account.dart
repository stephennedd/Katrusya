import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/utils/hexagon_clip.dart';
import 'package:frontend/widgets/app_bar_box.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  static const String routeName = "/account";

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: MyAppBar(
        backgroundColor: primaryDark,
        title: "Account",
        centerTitle: false,
        hasBackButton: false,
        hasAction: true,
        icon: SvgPicture.asset("assets/icons/wallet.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
        onTap: () {
          print("click");
        },
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: labelColor,
            radius: 130,
            child: CircleAvatar(
              radius: 110,
              backgroundImage: AssetImage("images/profile.jpg"),
            ),
          ),
          Positioned(
              left: 15,
              top: 100,
              child: Container(
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.5),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(1,1)
                  )
                ]
              ),
            )
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child:
          ) // profile picture
        ],
      ),
    );
  }
}
