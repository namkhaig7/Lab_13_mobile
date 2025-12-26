import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => Global_provider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
       return Consumer<Global_provider>(
         builder: (context, provider, _) {
           return MaterialApp(
                locale: provider.locale,
                supportedLocales: provider.supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                useMaterial3: false,
                ),
                home: HomePage(),
              );
         }
       );
  }
}
