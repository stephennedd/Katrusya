import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/start.dart';
import 'package:frontend/services/bottom_bar_provider.dart';
import 'package:frontend/themes/app_colors.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/information_item.dart';
import 'package:frontend/widgets/profile_image_box.dart';
import 'package:frontend/widgets/settings_item.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../controllers/users/user_controller.dart';
import '../storage/secure_storage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  static const String routeName = "/account";

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  UsersController usersController = Get.put(UsersController());
  final GetStorage _getStorage = GetStorage();
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

  String _profileImage = 'images/ape.jpg';

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
            "assets/icons/logout.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onTap: () async {
            await SecureStorage.deleteAccessToken();
            _getStorage.erase();
            usersController.isUserLoggedIn.value = false;
            Navigator.pushNamed(context, StartPage.routeName);
          },
        ),
        body: Obx(() => buildBody()),
      ),
    );
  }

  List settings = [
    {
      "text": "Edit Profile",
      "page": Container(
        child: const Center(
          child: Text("Edit Profile"),
        ),
      )
    },
  ];

  Widget buildBody() {
    var bottomBarProvider =
    Provider.of<BottomBarProvider>(context, listen: false);

    // TODO get the user's balance of tokens
    var balance = usersController.balanceOfTokens.value;
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProfileImageBox(
                image: _profileImage,
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: false
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;
                    setState(() {
                      _profileImage = file.path.toString();
                    });
                    // TODO upload the file to the firestore then update the user's image url to the saved image url
                  } else {
                    // User canceled the picker
                  }
                },
              )
            ],
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
                      child: Obx(() => Switch.adaptive(
                          activeColor: primary,
                          thumbIcon: thumbIcon,
                          thumbColor: MaterialStateProperty.all(Colors.white),
                          value: usersController.isUserTeacher(),
                          onChanged: (bool value) async {
                            await usersController
                                .flipTeacherMode(_getStorage.read("userId"));
                             setState(() {
                            //bottomBarProvider.isTeacherMode = value;
                              if (usersController.isUserTeacher()) {
                                bottomBarProvider.activePageIndex = 2;
                              } else {
                                bottomBarProvider.activePageIndex = 4;
                              }
                            });
                          })),
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
            style: const TextStyle(
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
              const SizedBox(
                width: 4,
              ),
              SvgPicture.asset("assets/icons/crypto.svg")
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Information",
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => InformationItem(
                      icon: const Icon(
                        Icons.alternate_email_outlined,
                        weight: 100,
                        size: 20,
                      ),
                      text: usersController.email.value,
                      type: "Email",
                    )),
                const SizedBox(
                  height: 15,
                ),
                Obx(() => InformationItem(
                      icon: const Icon(
                        Icons.call_outlined,
                        weight: 100,
                        size: 20,
                      ),
                      text: usersController.phone.value,
                      type: "Phone",
                    )),
                const SizedBox(
                  height: 15,
                ),
                InformationItem(
                  icon: const Icon(
                    Icons.today_outlined,
                    weight: 100,
                    size: 20,
                  ),
                  text: _getStorage.read("createdAt"),
                  type: "Joined",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 50,
              width: double.infinity,
              child: SettingsItem(
                itemText: settings[0]["text"],
                onTap: () {
                  showPopup();
                },
              ))
        ],
      ),
    );
  }

  void showPopup() async {
    String item = settings[0]["text"];
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              content: Text("You tapped on $item"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ));
  }
}
