import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/ui/home_page.dart';
import '../theme/color_theme.dart';

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
                      margin: const EdgeInsets.only(top: 250),
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
                const SizedBox(height: 50),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 300,
                        child: Text(
                          AppLocalizations.of(context)!.success_post,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ))),
                const SizedBox(height: 50),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 150,
                        child: Expanded(
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
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  },
                                  child: Text(AppLocalizations.of(context)!.ok,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ))))),
              ],
            )
          ],
        ));
  }
}
