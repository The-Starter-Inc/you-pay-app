// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/ui/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:p2p_pay/src/models/user.dart' as types;
import '../firebase_options.dart';
import 'blocs/auth_bloc.dart';
import 'constants/app_constant.dart';
import 'models/token.dart';
import 'theme/color_theme.dart';
import 'utils/alert_util.dart';

class AppSplash extends StatefulWidget {
  const AppSplash({Key? key}) : super(key: key);

  @override
  _AppSplashState createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash> {
  var _appLocale;
  bool isLoading = true;
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();

    initializeFlutterFire();
    getStarted();
  }

  void getStarted() async {
    Token token = await authBloc.fetchToken({
      "grant_type": "client_credentials",
      "client_id": AppConstant.clientId,
      "client_secret": AppConstant.clientSecret
    });
    AppConstant.accessToken = token.access_token;
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    Timer(const Duration(seconds: 3), () async {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      await firebaseUserLogin("$deviceId@fk.com");
      var user = await Localstore.instance
          .collection('users')
          .doc(AppConstant.firebaseUser!.uid)
          .get();
      if (user != null) {
        AppConstant.currentUser = types.User.fromMap(user);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SearchPage(isPop: false)));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  void initializeFlutterFire() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      AlertUtil.showErrorAlert(
          context, AppLocalizations.of(context)!.no_network);
      return;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        setState(() {
          AppConstant.firebaseUser = user;
        });
      });
    } catch (e) {
      AlertUtil.showErrorAlert(context, e);
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.secondaryColor,
      child: Stack(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(0.0),
          //   child: Center(
          //     child: Image.asset('assets/images/you-pay.png', width: 150),
          //   ),
          // ),
          Positioned(
              bottom: 24.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Opacity(
                  opacity: 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("The Community Exchange\nSupported by",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white54)),
                      Image.asset('assets/images/sponsor.png', width: 100),
                    ],
                  ),
                ),
              )),
          if (isLoading)
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Image.asset('assets/images/loading.gif', width: 150)),
            )
          else
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Image.asset('assets/images/you-pay.png', width: 150)),
            )
        ],
      ),
    );
  }
}
