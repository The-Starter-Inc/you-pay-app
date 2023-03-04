// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './../blocs/auth_bloc.dart';
import './../models/token.dart';
import '../../src/constants/app_constant.dart';
import '../../src/ui/entry/create_post_page.dart';
import '../../firebase_options.dart';
import '../theme/color_theme.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  String? initialMessage;
  bool _resolved = false;

  final List<Widget> screens = [const DashboardPage(), const ProfilePage()];
  final AuthBloc authBloc = AuthBloc();

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics
        .setCurrentScreen(screenName: "Home Page")
        .whenComplete(() => print("Google Analytic Success"))
        .onError((error, stackTrace) => print(error));
    authBloc.fetchToken({
      "grant_type": "client_credentials",
      "client_id": AppConstant.clientId,
      "client_secret": AppConstant.clientSecret
    });
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

    await FirebaseMessaging.instance.subscribeToTopic('general');
    await FirebaseMessaging.instance
        .subscribeToTopic(AppConstant.firebaseUser!.uid);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        AppConstant.hasNotification = true;
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NotificationPage()));
    });
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
      String? deviceId = await PlatformDeviceId.getDeviceId;
      if (deviceId != null) {
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "$deviceId@fk.com",
            password: "123!@#",
          );
          final faker = Faker();
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: faker.person.firstName(),
              lastName: faker.person.lastName(),
              id: credential.user!.uid,
              imageUrl: 'https://i.pravatar.cc/300?u=$deviceId',
            ),
          );
          firebaseUserLogin("$deviceId@fk.com");
          if (!mounted) return;
        } catch (e) {
          if (e.toString().contains("email-already-in-use")) {
            firebaseUserLogin("$deviceId@fk.com");
          } else {
            showErrorAlert(e);
          }
        }
      } else {
        showErrorAlert(AppLocalizations.of(context)!.no_device_id);
      }
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
                          width: 64,
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
                          width: 64,
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
    return StreamBuilder<Token>(
        stream: authBloc.token,
        builder: (context, AsyncSnapshot<Token> snapshot) {
          if (snapshot.hasData) {
            AppConstant.accessToken = snapshot.data!.access_token;
            return screens.elementAt(currentTab);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
