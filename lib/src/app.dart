// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/provider/app_locale.dart';
import 'package:provider/provider.dart';
import 'theme/color_theme.dart';
import 'theme/theme_text.dart';
import 'splash.dart';

class P2PApp extends StatelessWidget {
  const P2PApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLocale>(
          create: (_) => AppLocale(),
        )
      ],
      child: Consumer<AppLocale>(builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            unselectedWidgetColor: Colors.black54,
            primaryColor: AppColor.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: ThemeText.getTextTheme(),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: AppColor.primaryColor),
          ),
          locale: locale.locale,
          home: const AppSplash(),
        );
      }),
    );
  }
}
