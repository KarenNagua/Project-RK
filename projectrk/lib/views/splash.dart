import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectrk/views/login.dart';
import 'package:projectrk/views/registro.dart';

class Splash extends StatefulWidget {
  Splash();

  @override
  _SplashState createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> {
  _SplashState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {},
        child: Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.35), BlendMode.dstOut),
                    image: AssetImage("assets/a.jpg"),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Project RK",
                      style: TextStyle(
                          color: Color(0xFF172b4d),
                          fontWeight: FontWeight.w800,
                          fontSize: 45),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 55, right: 55, top: 15, bottom: 25),
                      child: Text(
                        "The best way to know, find and discover new places around you. Let's start!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF172b4d),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF3ACCE1),
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF3ACCE1),
                                  blurRadius: 1
                                )
                              ]
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.signInAlt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  "Iniciar sesión",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegistroPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.redAccent,
                                      blurRadius: 1
                                  )
                                ]
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.userPlus,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  "Registrate",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
