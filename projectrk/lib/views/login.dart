import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectrk/views/sitios.dart';
import 'package:projectrk/views/splash.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String _email, _password;
  bool _load = false;

  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _LoginPageState();


  @override
  Widget build(BuildContext context) {



    Widget _showLogo() {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: Text(
          'Inicia Sesión',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF3ACCE1),
              fontWeight: FontWeight.w800,
              fontSize: 20.0),
        ),
      );
    }

    Widget _showInputForm(int type, String hint, String label, String error) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8, top: 0),
        child: TextFormField(
          enabled: _load == false ? true : false,
          maxLines: 1,
          obscureText: type == 0 ? false : true,
          keyboardType:
          type == 0 ? TextInputType.emailAddress : TextInputType.text,
          style: TextStyle(color: Colors.black, fontSize: 13.0),
          decoration: InputDecoration(
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFFFFFF)),
                borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3ACCE1)),
                borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3ACCE1)),
                borderRadius: BorderRadius.circular(15.0)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(15.0)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(15.0)),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ),
            labelText: label,
            labelStyle: TextStyle(
                color: Color(0xFF3ACCE1), fontWeight: FontWeight.w600),
            contentPadding:
            EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
          ),
          validator: (value) {
            if (value.trim().isEmpty) {
              return error;
            }
            return null;
          },
          onSaved: (value) => type == 0 ? _email = value : _password = value,
        ),
      );
    }

    ;

    Widget _showButtonForm(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: 0, top: 8),
        child: new InkWell(
          onTap: () {
            if (_load == false) {
              _loginUserIntoFirebase(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 56,
            height: 50.0,
            decoration: BoxDecoration(
              color: _load == false
                  ? Color(0xFF3ACCE1)
                  : Color(0xFF78849E),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'CONTINUAR',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    Widget _showLoadingIndicator = _load
        ? new Padding(
      padding: EdgeInsets.only(bottom: 0, top: 15),
      child: new Container(
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3ACCE1)),
        ),
      ),
    )
        : new Container();

    Widget _jointPartsForm(BuildContext context) {
      return Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _showLogo(),
              _showInputForm(0, 'example@troya.com', 'Correo electrónico',
                  'Debes ingresa tu dirección de correo'),
              _showInputForm(
                  1, '********', 'Contraseña', 'Debes ingresar tu contraseña'),
              _showButtonForm(context),
              _showLoadingIndicator,
            ],
          ));
    }

    return SafeArea(
      child: WillPopScope(
          onWillPop: () {
            return Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Splash()),
            );
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: Builder(
              builder: (bcontext) => Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[_jointPartsForm(bcontext)],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void _showSnackBar(String mensaje) {
    var snackBar = SnackBar(content: Text(mensaje));
    if(_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _changeStateLoader(bool valor) {
    setState(() {
      _load = valor;
    });
  }

  void _loginUserIntoFirebase(BuildContext context) {
    _changeStateLoader(true);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      auth.signInWithEmailAndPassword(email: this._email, password: this._password)
          .then((AuthResult result) {
        //Registrar acceso en la BD
        if (result.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sitios()),
          );
        } else {
          auth.signOut();
        }
      }).catchError((error) {
        print(error);
        _changeStateLoader(false);
        _showSnackBar('Tenemos problemas, intenta más tarde');
      });
    } else {
      _changeStateLoader(false);
    }
  }
}
