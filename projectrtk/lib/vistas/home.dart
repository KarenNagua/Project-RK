import 'package:bancaonline/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bancaonline/controladores/home.dart';
import 'package:bancaonline/controladores/listener_movimientos.dart';

import 'package:bancaonline/modelos/persona.dart';
import 'package:bancaonline/modelos/cuenta.dart';
import 'package:bancaonline/modelos/movimiento.dart';
import 'package:bancaonline/modelos/transaccion.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, ListenerMovimientos {

  ControlHome _controlHome;
  FirebaseUser _user;
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  bool _dataReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._controlHome = new ControlHome();
    auth.currentUser().then((user) async {
      print(user.uid);
      DocumentSnapshot data_persona = await db.collection("persona").document(user.uid).get();
      QuerySnapshot data_cuentas = await db.collection("cuenta").where("id_persona", isEqualTo:  user.uid).getDocuments();
      print(data_persona.data);
      setState(() {
        this._user = user;
        this._controlHome.listener = this;
        this._controlHome.user = user;
        this._controlHome.persona = Persona.fromMap(data_persona.data);
        this._controlHome.cuentas = data_cuentas.documents.map((doc) => Cuenta.fromMap(doc.data)).toList();
        this._controlHome.getMovimientos();
      });
    }).catchError((error){
      print(error);
      _user = null;
    });

  }


  @override
  setSectionMovimientos(status) {
    setState(() {
      this._dataReady = status;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _normalAppBar(){
      return AppBar(
        backgroundColor: Color(0xFF3ACCE1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () async {
              await auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
        title: Text(
          "Posición Consolidada",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFFffffff)
          ),
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
                new Color(0xFF3ACCE1),
                new Color(0xFF3ACCE1),
                new Color(0xFF3ACCE1)
              ],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: (){

      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _normalAppBar(),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: this._dataReady ? Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              this._controlHome.getSectionUsuario(context),
              this._dataReady ?
                this._controlHome.getSectionMovimientos()
                  :
                Expanded(
                  flex: 8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ) : Center(
            child: CircularProgressIndicator(),
          )
        ),
      ),
    );
  }
}