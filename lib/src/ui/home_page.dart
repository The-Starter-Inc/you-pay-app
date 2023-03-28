// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/ui/maps_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';
import './../models/post.dart';
import '../../src/constants/app_constant.dart';
import '../../src/ui/entry/create_post_page.dart';
import '../../firebase_options.dart';
import '../theme/color_theme.dart';
import 'chat_page.dart';
import 'exchange_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  final Provider? you;
  final Provider? pay;
  final int? selectedPage;
  const HomePage({super.key, this.you, this.pay, this.selectedPage});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  String? initialMessage;
  bool _resolved = false;
  bool hasNotification = false;
  int notificationCounts = 0;

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    currentTab = widget.selectedPage ?? 0;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics
        .setCurrentScreen(screenName: "Home Page")
        .whenComplete(() => print("Google Analytic Success"))
        .onError((error, stackTrace) => print(error));

    initializeFlutterFire();
    initializeFirebaseFCM();
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showErrorAlert(AppLocalizations.of(context)!.no_network);
        return;
      }
    });
  }

  Future<void> initializeFirebaseFCM() async {
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    await FirebaseMessaging.instance.subscribeToTopic('general1');
    await FirebaseMessaging.instance
        .subscribeToTopic(AppConstant.firebaseUser!.uid);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data['type'] == 'message') {
        final userIds = jsonDecode(message.data['userIds']);
        final metadata = jsonDecode(message.data['metadata']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      postId: int.parse(metadata['post_id']),
                      room: types.Room(
                          id: message.data['roomId'],
                          name: metadata['phone'],
                          users: [
                            types.User(id: userIds[0]),
                            types.User(id: userIds[1])
                          ],
                          type: types.RoomType.direct),
                    )));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NotificationPage()));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Localstore.instance
          .collection('notifications')
          .doc(message.messageId)
          .set(message.toMap());
      if (message.data['type'] == 'message') {
        setState(() {
          AppConstant.hasNotification = true;
          hasNotification = true;
          notificationCounts += 1;
        });
      }
    });
    setState(() {
      hasNotification = AppConstant.hasNotification;
    });
    final notifications =
        await Localstore.instance.collection('notifications').get();
    if (notifications != null &&
        notifications.keys
            .where((key) => notifications[key]['data']['type'] == 'message')
            .isNotEmpty) {
      setState(() {
        AppConstant.hasNotification = true;
        hasNotification = AppConstant.hasNotification;
        notificationCounts = notifications.keys
            .where((key) => notifications[key] == 'message')
            .length;
      });
    }
  }

  void initializeFlutterFire() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showErrorAlert(AppLocalizations.of(context)!.no_network);
      return;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          AppConstant.firebaseUser = user;
        });
      });
    } catch (e) {
      showErrorAlert(e);
    }
  }

  Future<void> firebaseUserLogin(String email) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: "123!@#",
      );
      if (!mounted) return;
    } catch (e) {
      showErrorAlert(e);
    }
  }

  Future<void> showErrorAlert(message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
        content: Text(message,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                )),
        title: Text(
          'Error',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) return;
    setState(() {
      currentTab = index;
    });
  }

  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildLayout(),
        floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
            },
            backgroundColor: AppColor.primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: const Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: currentTab == 0
                      ? Container(
                          width: 50,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.dashboard,
                              color: Colors.black, size: 24),
                        )
                      : const Icon(Icons.dashboard,
                          color: Color.fromARGB(198, 0, 0, 0)),
                  label: AppLocalizations.of(context)!.home),
              BottomNavigationBarItem(
                  icon: currentTab == 1
                      ? Container(
                          width: 50,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.fmd_good,
                              color: Colors.black, size: 24),
                        )
                      : const Icon(Icons.fmd_good,
                          color: Color.fromARGB(198, 0, 0, 0)),
                  label: AppLocalizations.of(context)!.maps),
              BottomNavigationBarItem(icon: Container(), label: ""),
              BottomNavigationBarItem(
                  icon: currentTab == 3
                      ? Container(
                          width: 50,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.chat_bubble,
                              color: Colors.black, size: 24),
                        )
                      : Stack(
                          children: [
                            const Icon(
                              Icons.chat_bubble,
                              color: Color.fromARGB(198, 0, 0, 0),
                              size: 26,
                            ),
                            if (notificationCounts > 0)
                              Container(
                                  width: 24,
                                  height: 24,
                                  transform:
                                      Matrix4.translationValues(10.0, -10, 0.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                  margin: const EdgeInsets.only(right: 0),
                                  child: const Center(
                                    child: Text("1",
                                        style: TextStyle(color: Colors.white)),
                                  ))
                          ],
                        ),
                  label: AppLocalizations.of(context)!.exchange_money),
              BottomNavigationBarItem(
                  icon: currentTab == 4
                      ? Container(
                          width: 50,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.black, size: 24),
                        )
                      : const Icon(Icons.person,
                          color: Color.fromARGB(198, 0, 0, 0)),
                  label: AppLocalizations.of(context)!.profile)
            ],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            selectedItemColor: Colors.black,
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5));
  }

  Widget buildLayout() {
    if (currentTab == 1) {
      return MapsPage(you: widget.you, pay: widget.pay);
    } else if (currentTab == 2) {
      return Container();
    } else if (currentTab == 3) {
      return const ExchangePage();
    } else if (currentTab == 4) {
      return const ProfilePage();
    }
    return DashboardPage(you: widget.you, pay: widget.pay);
  }
}
