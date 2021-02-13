import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app/src/bloc/provider_bloc.dart';
import 'package:test_app/src/pages/home_page.dart';
import 'package:test_app/src/pages/login_page.dart';
import 'package:test_app/src/pages/product_page.dart';
import 'package:test_app/src/pages/register_page.dart';
import 'package:test_app/src/preferences/user_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreference();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreference();
    print(prefs.token);

    return Provider(
        child: MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Arabic, no country code
      ],
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: prefs.token.length > 0 ? 'home' : 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'home': (BuildContext context) => HomePage(),
        'product': (BuildContext context) => ProductPage(),
      },
      theme: ThemeData(primaryColor: Colors.greenAccent),
    ));
  }
}
