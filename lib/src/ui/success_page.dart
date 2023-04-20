import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/ui/home_page.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import '../theme/color_theme.dart';
import '../theme/text_size.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});
  static const String routeName = '/success';

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
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
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 250),
                      width: 120,
                      height: 120,
                      // decoration: const BoxDecoration(
                      //   color: AppColor.secondaryColor,
                      //   borderRadius: BorderRadius.all(Radius.circular(8)),
                      // ),
                      child:
                          Image.asset("assets/images/you-pay.png", width: 120)),
                ),
                const SizedBox(height: 50),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 300,
                        child: Text(
                          AppLocalizations.of(context)!.success_post,
                          textAlign: TextAlign.center,
                          style: TextSize.size20,
                        ))),
                const SizedBox(height: 50),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ))),
                                      onPressed: () {
                                        if (AppConstant.you != null &&
                                            AppConstant.pay != null) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        you: AppConstant.you,
                                                        pay: AppConstant.pay,
                                                      )));
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SearchPage(
                                                          isPop: false)));
                                        }
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.ok,
                                          style: TextSize.size16),
                                    )))
                          ],
                        ))),
              ],
            )
          ],
        ));
  }
}
