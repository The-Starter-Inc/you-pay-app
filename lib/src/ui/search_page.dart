import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';
import 'package:p2p_pay/src/blocs/app_version_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/app_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import './../ui/entry/create_post_page.dart';
import './../ui/my_post_page.dart';
import '../theme/color_theme.dart';
import './../blocs/provider_bloc.dart';
import '../models/post.dart';
import 'home_page.dart';
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
      text: AppConstant.you != null ? AppConstant.you!.id.toString() : "");
  TextEditingController providerPayController = TextEditingController(
      text: AppConstant.pay != null ? AppConstant.pay!.id.toString() : "");
  List<Provider> providers = [];
  Error frmError = Error(null, null);
  late bool checkFormError = false;

  @override
  initState() {
    super.initState();
    checkVersionUpdate();
    providerBloc.fetchProviders();
    providerYouController.addListener(() {
      validationError();
      providerPayController.text = "";
      providerBloc.fetchProviders();
      setState(() {});
    });
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
                      child: Text("Not Now",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ))),
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
                  child: const Text("Update Now"),
                ),
              ],
              title: Text(
                "Version Update",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: Text("Pelase update for $versionName version.",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      )),
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
        backgroundColor: Colors.yellow.shade200,
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
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 120),
                      width: 120,
                      height: 120,
                      child:
                          Image.asset("assets/images/you-pay.png", width: 120)),
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
                                providers = [Provider(id: 0, name: "All")] +
                                    dataList[0];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: DropDownText(
                                          label:
                                              AppLocalizations.of(context)!.you,
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .choose_you,
                                          controller: providerYouController,
                                          errorText: frmError.you,
                                          items: dataList[0],
                                        )),
                                        const SizedBox(width: 16),
                                        Flexible(
                                            child: DropDownText(
                                                label: AppLocalizations.of(
                                                        context)!
                                                    .pay,
                                                placeholder:
                                                    AppLocalizations.of(
                                                            context)!
                                                        .choose_pay,
                                                controller:
                                                    providerPayController,
                                                errorText: frmError.pay,
                                                items: providers
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
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(AppColor
                                                                  .primaryColor),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(AppColor
                                                                  .primaryColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
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
                                                        AppConstant.you =
                                                            you[0];
                                                        AppConstant.pay =
                                                            pay[0];
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    HomePage(
                                                                        you: you[
                                                                            0],
                                                                        pay: pay[
                                                                            0])));
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .search,
                                                      style: const TextStyle(
                                                          color: Colors.black)),
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
                                        .where((x) => x.name == 'All')
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ))),
                                  child: Text(
                                      AppLocalizations.of(context)!.human_atm,
                                      style: const TextStyle(
                                          color: AppColor.secondaryColor)),
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
                                                    color:
                                                        Colors.yellow.shade200,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                48)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Center(
                                                        child: Icon(Icons.add)),
                                                  ),
                                                ),
                                                title: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .new_post,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Pyidaungsu')),
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
                                                    color:
                                                        Colors.yellow.shade200,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                48)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Center(
                                                        child: Icon(Icons
                                                            .post_add_outlined)),
                                                  ),
                                                ),
                                                title: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .my_posts,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Pyidaungsu')),
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
                                child: Text(
                                    AppLocalizations.of(context)!.new_post,
                                    style: const TextStyle(
                                        color: AppColor.secondaryColor)),
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
