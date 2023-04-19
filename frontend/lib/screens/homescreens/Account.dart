import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Account',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(EvaIcons.shoppingCartOutline),
              onPressed: () {
                print('Basket window');
              },
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 300.0,
                        width: 400.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Yehor Zhvarnytskyi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0)),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(EvaIcons.google, color: Colors.white),
                                    Text(
                                      'smisha3000@gmail.com',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 20.0),
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: const Text('Become an instructor',
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        )),
                    const Text(
                      'Video preferences',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'Download options',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'Video Playback Options',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'About Udemy for business',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'FAQs',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'Share the udemy app',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    const Text(
                      'Diagnostics',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    const ListTile(
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      title: Text(
                        'Status',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    Center(
                        child: MaterialButton(
                      onPressed: () {},
                      child: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    )),
                    const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Text(
                            'Udemy clone v1.0.0',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          ),
                        )),
                  ],
                ))));
  }
}
