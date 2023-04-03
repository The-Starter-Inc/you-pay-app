// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/provider/app_locale.dart';
import 'package:p2p_pay/src/provider/theme_provider.dart';
import 'package:p2p_pay/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
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
        ),
        ChangeNotifierProvider<ThemeChanger>(
          create: (_) => ThemeChanger("light"),
        )
      ],
      child: Consumer<AppLocale>(builder: (context, locale, child) {
        final theme = Provider.of<ThemeChanger>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.currentTheme == "dark"? ThemeMode.dark : ThemeMode.light,
          locale: locale.locale,
          home: const AppSplash(),
        );
      }),
    );
  }
}
