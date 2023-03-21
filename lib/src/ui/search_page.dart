import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';
import '../theme/color_theme.dart';
import './../blocs/provider_bloc.dart';
import '../models/post.dart';
import 'home_page.dart';
import 'widgets/dropdown_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProviderBloc providerBloc = ProviderBloc();
  TextEditingController providerYouController = TextEditingController(text: "");
  TextEditingController providerPayController = TextEditingController();
  List<Provider> providers = [];
  Error frmError = Error(null, null);
  late bool checkFormError = false;
  @override
  void initState() {
    super.initState();
    providerBloc.fetchProviders();
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
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset("assets/images/you-pay-left-top.png")),
            Positioned(
                right: 0,
                bottom: 70,
                child: Image.asset("assets/images/you-pay-bottom-right.png")),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 120),
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.asset("assets/images/you-pay.png",
                              width: 50))),
                ),
                const SizedBox(height: 100),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 300,
                        child: MultiStreamBuilder(
                            streams: [providerBloc.providers],
                            builder: (context, dataList) {
                              if (dataList[0] != null) {
                                providers = dataList[0];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: DropDownText(
                                      label: AppLocalizations.of(context)!.you,
                                      placeholder: AppLocalizations.of(context)!
                                          .choose_you,
                                      controller: providerYouController,
                                      errorText: frmError.you,
                                      items: dataList[0],
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
                                            items: dataList[0]))
                                  ],
                                );
                              }
                              return Container();
                            }))),
                const SizedBox(height: 50),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColor.primaryColor),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColor.primaryColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
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
                                                  providerYouController.text)
                                              .toList();
                                          List<Provider> pay = providers
                                              .where((x) =>
                                                  x.id.toString() ==
                                                  providerPayController.text)
                                              .toList();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                          you: you[0],
                                                          pay: pay[0])));
                                        }
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.search,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )))
                          ],
                        ))),
              ],
            )
          ],
        ));
  }
}

class Error {
  late String? you;
  late String? pay;

  Error(this.you, this.pay);
}
