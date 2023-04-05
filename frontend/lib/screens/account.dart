import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/Screens/search.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/services/bottom_bar_provider.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/utils/hexagon_clip.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/hexagon_image.dart';
import 'package:frontend/widgets/settings_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../controllers/users/user_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  static const String routeName = "/account";

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _teacherMode = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  final GetStorage _getStorage = GetStorage();
  UsersController usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: primaryDark,
        appBar: MyAppBar(
          backgroundColor: primaryDark,
          title: "Account",
          centerTitle: false,
          hasBackButton: false,
          hasAction: true,
          icon: SvgPicture.asset(
            "assets/icons/wallet.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onTap: () {
            print("click");
          },
        ),
        body: Obx(() => buildBody()),
      ),
    );
  }

  Widget buildBody() {
    // TODO get the user's balance of tokens
    var balance = usersController.balanceOfTokens.value;
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryDark, Colors.white],
            stops: [0.26, 0.26],
          )),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //HexagonProfileImage(),

          const CircleAvatar(
            backgroundColor: labelColor,
            radius: 65,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("images/ape.jpg"),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
            padding: const EdgeInsets.only(left: 15),
            height: 50,
            decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: shadowColor.withOpacity(0.3),
                      blurRadius: .5,
                      spreadRadius: .5,
                      offset: const Offset(0, 0))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Teacher mode",
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 33,
                    width: 45,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch.adaptive(
                          activeColor: primary,
                          thumbIcon: thumbIcon,
                          thumbColor: MaterialStateProperty.all(Colors.white),
                          value: bottomBarProvider.isTeacherMode,
                          onChanged: (bool value) {
                            setState(() {
                              bottomBarProvider.isTeacherMode = value;
                              if (bottomBarProvider.isTeacherMode) {
                                bottomBarProvider.activePageIndex = 2;
                              } else {
                                bottomBarProvider.activePageIndex = 4;
                              }
                            });
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          // Done: get the logged in username
          Text(
            _getStorage.read("username"),
            style: TextStyle(
                fontFamily: 'Nexa-Trial',
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "personal balance: $balance",
                style: const TextStyle(
                    fontFamily: 'Nexa-Trial',
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              const SizedBox(
                width: 4,
              ),
              SvgPicture.asset("assets/icons/crypto.svg")
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 400,
            width: double.infinity,
            child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) {
                return SettingsItem(
                  itemText: settings[index]["text"],
                  textColor: settings[index]["color"],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
