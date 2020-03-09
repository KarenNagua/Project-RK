import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectrk/modelos/account.dart';
import 'package:projectrk/modelos/person.dart';
import 'package:projectrk/views/cuenta.dart';
import 'package:projectrk/views/sitios.dart';
import 'package:projectrk/views/splash.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with TickerProviderStateMixin {
  FirebaseUser _user;
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  Account _cuenta;
  Person _persona;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    auth.currentUser().then((user) {
      this._user = user;
      this.getDataUser();
    }).catchError((error) {
      this._user = null;
    });
  }

  void getDataUser() async {
    DocumentSnapshot a =
        await db.collection("account").document(this._user.uid).get();

    Account aux = Account.fromMap(a.data);
    DocumentSnapshot b =
        await db.collection("person").document(aux.id_person).get();

    setState(() {
      this._cuenta = aux;
      this._persona = Person.fromMap(b.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _normalAppBar() {
      return AppBar(
        backgroundColor: Color(0xFF454F63),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
          "Acerca de",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Color(0xFFffffff)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: FractionalOffset.topRight,
              end: FractionalOffset.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.0, 0.4, 1.0],
              colors: [
                new Color(0xFF454F63),
                new Color(0xFF454F63),
                new Color(0xFF454F63)
              ],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.only(left: 25),
                  child: this._cuenta != null && this._persona != null
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  image: this._persona.picture.length > 0
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            this._persona.picture,
                                          ),
                                          fit: BoxFit.cover)
                                      : null),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                this._persona.names.split(" ")[0] +
                                    " " +
                                    this._persona.surnames.split(" ")[0],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Text(
                                this._cuenta.email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            )
                          ],
                        )
                      : Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Color(0xFF2E3649), BlendMode.hue),
                      image: AssetImage("assets/fondo_barra.png"),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.black,
                  ),
                  title: Text('Sitios'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Sitios()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  title: Text('Mi cuenta'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cuenta()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  title: Text('Acerca de'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                  title: Text('Cerrar Sesión'),
                  onTap: () async {
                    await auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Splash()),
                    );
                  },
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset: false,
          appBar: _normalAppBar(),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Hola! Somos Project RK  la mejor manera de navegar por la ciudad y descubrir nuevos lugares. En la hermosa ciudad Loja, Ecuador.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "¿Por qué? Project RK ",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "¿Tienes hambre, buscas inspiración?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "¿Conocer amigos en un bar cercano?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "¿O simplemente necesita encontrar el banco más cercano?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "¡TE GUSTARÍA TENER CUALQUIER SITIO CERCANO! Por eso creamos PROJECT RK.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "PROJECT RK le permite buscar los restaurantes, Hoteles, Farmacias, Bancos más cercanos.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
