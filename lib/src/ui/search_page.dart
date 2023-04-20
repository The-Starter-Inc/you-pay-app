import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstore/localstore.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';
import 'package:p2p_pay/src/blocs/app_version_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/app_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../main.dart';
import '../theme/text_size.dart';
import './../ui/entry/create_post_page.dart';
import './../ui/my_post_page.dart';
import './../blocs/provider_bloc.dart';
import '../models/post.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'widgets/dropdown_text.dart';

class SearchPage extends StatefulWidget {
  final bool? isPop;
  const SearchPage({super.key, this.isPop});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProviderBloc providerBloc = ProviderBloc();
  AppVersionBloc appVersionBloc = AppVersionBloc();
  TextEditingController providerYouController = TextEditingController(
      text: AppConstant.you != null ? AppConstant.you!.id.toString() : "0");
  TextEditingController providerPayController = TextEditingController(
      text: AppConstant.pay != null ? AppConstant.pay!.id.toString() : "0");
  List<Provider> providers = [];
  Error frmError = Error(null, null);
  late bool checkFormError = false;
  String? initialMessage;
  bool hasNotification = false;
  int notificationCounts = 0;

  @override
  initState() {
    super.initState();
    checkVersionUpdate();
    initializeFirebaseFCM();
    providerBloc.fetchProviders();
    providerYouController.addListener(() {
      validationError();
      providerPayController.text = "";
      providerBloc.fetchProviders();
      setState(() {});
    });
  }

  void initializeFirebaseFCM() async {
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              initialMessage = value?.data.toString();
            },
          ),
        );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

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
            .where((key) => notifications[key]['data']['type'] == 'message')
            .length;
      });
    }
  }

  void checkVersionUpdate() async {
    List<AppVersion> appVersion = await appVersionBloc.fetchAppVersion();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    if (appVersion.isNotEmpty) {
      if (Platform.isAndroid) {
        if (int.parse(buildNumber) < appVersion.first.androidVersionCode) {
          bool isForeUpdate = appVersion.first.androidForceUpdate ||
              int.parse(buildNumber) < appVersion.first.androidForceUpdateCode;
          showUpdateAlert(appVersion.first.androidVersionName, isForeUpdate);
        }
      } else if (Platform.isIOS) {
        if (int.parse(buildNumber) < appVersion.first.iosVersionCode) {
          bool isForeUpdate = appVersion.first.androidForceUpdate ||
              int.parse(buildNumber) < appVersion.first.iosForceUpdateCode;
          showUpdateAlert(appVersion.first.androidVersionName, isForeUpdate);
        }
      }
    }
  }

  void showUpdateAlert(String versionName, bool isForceUpdate) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              actions: [
                if (!isForceUpdate)
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Not Now", style: TextSize.size16)),
                TextButton(
                  onPressed: () async {
                    Uri redirectUrl = Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.thestarter.youpay");
                    if (await canLaunchUrl(redirectUrl)) {
                      await launchUrl(redirectUrl);
                    } else {
                      throw 'Could not open the link.';
                    }
                  },
                  child: Text(
                    "Update Now",
                    style: TextSize.size16,
                  ),
                ),
              ],
              title: Text(
                "Version Update",
                style: TextSize.size16,
              ),
              content: Text("Pelase update for $versionName version.",
                  style: TextSize.size14),
            ),
          );
        });
  }

  bool validationError() {
    bool hasError = false;
    if (checkFormError) {
      clear();
      if (providerYouController.text.isEmpty) {
        hasError = true;
        frmError.you = AppLocalizations.of(context)!.pls_choose_you;
      }

      if (providerPayController.text.isEmpty) {
        hasError = true;
        frmError.pay = AppLocalizations.of(context)!.pls_choose_pay;
      }
      setState(() {});
    }
    return hasError;
  }

  void clear() {
    setState(() {
      frmError.you = null;
      frmError.pay = null;
    });
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
        Positioned(
            top: 55,
            right: 22,
            child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              you: AppConstant.you,
                              pay: AppConstant.pay,
                              selectedPage: 3)));
                },
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        height: 40,
                        width: 40,
                        child: const Icon(
                          Icons.chat_bubble,
                          color: Colors.black54,
                          size: 24,
                        )),
                    if (notificationCounts > 0)
                      Container(
                          width: 24,
                          height: 24,
                          transform: Matrix4.translationValues(10.0, -10, 0.0),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          margin: const EdgeInsets.only(right: 0),
                          child: Center(
                            child: Text("$notificationCounts",
                                style: const TextStyle(color: Colors.white)),
                          ))
                  ],
                ))),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(top: 120),
                  width: 120,
                  height: 120,
                  child: Image.asset("assets/images/you-pay.png", width: 120)),
            ),
            const SizedBox(height: 100),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 340,
                    child: MultiStreamBuilder(
                        streams: [providerBloc.providers],
                        builder: (context, dataList) {
                          if (dataList[0] != null) {
                            providers = [
                                  Provider(id: 0, name: "All Provider")
                                ] +
                                dataList[0];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: DropDownText(
                                      label: AppLocalizations.of(context)!.you,
                                      placeholder: AppLocalizations.of(context)!
                                          .choose_you,
                                      controller: providerYouController,
                                      errorText: frmError.you,
                                      items: [
                                            Provider(
                                                id: 0, name: "All Provider")
                                          ] +
                                          dataList[0],
                                    )),
                                    const SizedBox(width: 16),
                                    Flexible(
                                        child: DropDownText(
                                            label: AppLocalizations.of(context)!
                                                .pay,
                                            placeholder:
                                                AppLocalizations.of(context)!
                                                    .choose_pay,
                                            controller: providerPayController,
                                            errorText: frmError.pay,
                                            items: [
                                                  Provider(
                                                      id: 0,
                                                      name: "All Provider")
                                                ] +
                                                dataList[0]
                                                    .where((x) =>
                                                        x.id.toString() !=
                                                        providerYouController
                                                            .text)
                                                    .toList()))
                                  ],
                                ),
                                const SizedBox(height: 72),
                                Row(
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ))),
                                              onPressed: () {
                                                checkFormError = true;
                                                if (!validationError()) {
                                                  List<Provider> you = providers
                                                      .where((x) =>
                                                          x.id.toString() ==
                                                          providerYouController
                                                              .text)
                                                      .toList();
                                                  List<Provider> pay = providers
                                                      .where((x) =>
                                                          x.id.toString() ==
                                                          providerPayController
                                                              .text)
                                                      .toList();
                                                  if (widget.isPop!) {
                                                    Navigator.pop(context,
                                                        [you[0], pay[0]]);
                                                  } else {
                                                    AppConstant.you = you[0];
                                                    AppConstant.pay = pay[0];
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomePage(
                                                                    you: you[0],
                                                                    pay: pay[
                                                                        0])));
                                                  }
                                                }
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .search,
                                                style: TextSize.size18,
                                              ),
                                            )))
                                  ],
                                )
                              ],
                            );
                          }
                          return Container();
                        }))),
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Align(
                child: SizedBox(
                    width: 340,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                AppConstant.you = providers
                                    .where((x) => x.name == 'Cash')
                                    .toList()[0];
                                AppConstant.pay = providers
                                    .where((x) => x.name == 'All Provider')
                                    .toList()[0];
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            you: AppConstant.you,
                                            pay: AppConstant.pay,
                                            selectedPage: 1)));
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ))),
                              child:
                                  Text(AppLocalizations.of(context)!.human_atm),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                            child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 22, horizontal: 0),
                                      child: Wrap(
                                        children: [
                                          const SizedBox(height: 22),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CreatePostPage()),
                                              );
                                            },
                                            leading: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow.shade200,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(48)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Center(
                                                    child: Icon(Icons.add)),
                                              ),
                                            ),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .new_post,
                                                style: TextSize.size16),
                                          ),
                                          const SizedBox(height: 22),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyPostPage()),
                                              );
                                            },
                                            leading: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow.shade200,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(48)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Center(
                                                    child: Icon(Icons
                                                        .post_add_outlined)),
                                              ),
                                            ),
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .my_posts,
                                                style: TextSize.size16),
                                          ),
                                          const SizedBox(height: 22)
                                        ],
                                      ));
                                },
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ))),
                            child: Text(AppLocalizations.of(context)!.new_post),
                          ),
                        )),
                      ],
                    ))))
      ],
    ));
  }
}

class Error {
  late String? you;
  late String? pay;

  Error(this.you, this.pay);
}
