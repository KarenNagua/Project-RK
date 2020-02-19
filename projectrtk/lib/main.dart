import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bancaonline/vistas/login.dart';
import 'package:bancaonline/vistas/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
}


class MyApp extends StatelessWidget {
  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget _getMainPage() {
      return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.providerData.length == 1) { // logged in using email and password
              return snapshot.data.isAnonymous
                  ? LoginPage()
                  : Home();
            } else { // logged in using other providers
              return Home();
            }
          } else {
            return LoginPage();
          }
        },
      );
    }

    return MaterialApp(
      title: 'Banca en Línea',
      theme: new ThemeData(
        primaryColor: Color(0xFF2A2E43),
        accentColor: Color(0xFF2A2E43),
        primaryColorBrightness: Brightness.dark,
      ),
      home: _getMainPage(),
    );
  }
}