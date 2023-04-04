// ignore_for_file: unnecessary_import, use_build_context_synchronously

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/models/user.dart' as types;
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/ui/home_page.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import 'package:p2p_pay/src/utils/firebase_util.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../firebase_options.dart';
import '../constants/app_constant.dart';
import '../theme/text_size.dart';
import '../utils/alert_util.dart';
import 'widgets/input_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = '/login';

  //final LoginBloc bloc;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  Error frmError = Error(null, null);
  late bool checkFormError = false;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
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

  Future<void> register() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    if (deviceId != null) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "$deviceId@fk.com",
          password: "123!@#",
        );

        await FirebaseUtil.createUserInFirestore(types.User(
          id: credential.user!.uid,
          name: nameController.text,
          phone: phoneController.text,
          imageUrl: 'https://i.pravatar.cc/300?u=$deviceId',
        ));
        firebaseUserLogin("$deviceId@fk.com");
        if (!mounted) return;
      } catch (e) {
        if (e.toString().contains("email-already-in-use")) {
          firebaseUserLogin("$deviceId@fk.com");
        } else {
          setState(() {
            isLoading = false;
          });
          AlertUtil.showErrorAlert(context, e.toString());
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      AlertUtil.showErrorAlert(
          context, AppLocalizations.of(context)!.no_device_id);
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
      AlertUtil.showErrorAlert(context, e.toString());
    }
  }

  clear() {
    setState(() {
      frmError.name = null;
      frmError.phone = null;
    });
  }

  bool validationError() {
    bool hasError = false;
    if (checkFormError) {
      clear();
      if (nameController.text.isEmpty) {
        hasError = true;
        frmError.name = AppLocalizations.of(context)!.pls_enter_name;
      }

      if (phoneController.text.isEmpty) {
        hasError = true;
        frmError.phone = AppLocalizations.of(context)!.pls_enter_phone;
      }
      setState(() {});
    }
    return hasError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // Positioned(
            //     top: 0,
            //     left: 0,
            //     child: Image.asset("assets/images/you-pay-left-top.png")),
            // Positioned(
            //     right: 0,
            //     bottom: 70,
            //     child: Image.asset("assets/images/you-pay-bottom-right.png")),
            ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 120),
                      width: 120,
                      height: 120,
                      // decoration: const BoxDecoration(
                      //   color: AppColor.secondaryColor,
                      //   borderRadius: BorderRadius.all(Radius.circular(8)),
                      // ),
                      child:
                          Image.asset("assets/images/you-pay.png", width: 120)),
                ),
                const SizedBox(height: 24),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.get_started,
                      style: TextSize.size20,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        InputText(
                            label: AppLocalizations.of(context)!.name,
                            placeholder:
                                AppLocalizations.of(context)!.enter_name,
                            errorText: frmError.name,
                            controller: nameController,
                            keyboardType: TextInputType.text),
                        InputText(
                            label: AppLocalizations.of(context)!.phone,
                            placeholder:
                                AppLocalizations.of(context)!.enter_phone,
                            errorText: frmError.phone,
                            controller: phoneController,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        checkFormError = true;
                                        if (!validationError()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await register();
                                          FirebaseUtil.createUserInFirestore(
                                              types.User(
                                            id: AppConstant.firebaseUser!.uid,
                                            name: nameController.text,
                                            phone: phoneController.text,
                                          ));
                                          types.User user = types.User(
                                            id: AppConstant.firebaseUser!.uid,
                                            name: nameController.text,
                                            phone: phoneController.text,
                                          );
                                          Localstore.instance
                                              .collection('users')
                                              .doc(
                                                  AppConstant.firebaseUser!.uid)
                                              .set(user.toMap());
                                          AppConstant.currentUser = user;
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SearchPage(
                                                          isPop: false)));
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  isLoading
                                                      ? AppColor.primaryLight
                                                      : AppColor.primaryColor),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  isLoading
                                                      ? AppColor.primaryLight
                                                      : AppColor.primaryColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ))),
                                      child: Text(
                                          AppLocalizations.of(context)!.start,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    )))
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (isLoading)
              Center(
                child: Image.asset("assets/images/loading.gif", width: 100),
              )
          ],
        ));
  }
}

class Error {
  late String? name;
  late String? phone;

  Error(this.name, this.phone);
}
