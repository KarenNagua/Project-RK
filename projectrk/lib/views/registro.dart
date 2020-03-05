import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectrk/views/sitios.dart';
import 'package:projectrk/views/splash.dart';
import 'package:projectrk/modelos/account.dart';
import 'package:projectrk/modelos/person.dart';

class RegistroPage extends StatefulWidget {
  RegistroPage();

  @override
  _RegistroPageState createState() {
    return _RegistroPageState();
  }
}

class _RegistroPageState extends State<RegistroPage> {
  Account _cuenta = new Account();
  Person _person = new Person();
  bool _load = false;
  bool _colorLabel = false;

  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _RegistroPageState();

  @override
  Widget build(BuildContext context) {
    Widget _showLogo() {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: Text(
          'Regístrate',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF3ACCE1),
              fontWeight: FontWeight.w800,
              fontSize: 28.0),
        ),
      );
    }

    Widget _inputText(int type, TextInputType typeInput, String hint,
        String label, String error) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8, top: 0),
        child: TextFormField(
          enabled: _load == false ? true : false,
          maxLines: 1,
          keyboardType: typeInput,
          obscureText: type == 6,
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
          onSaved: (value) {
            if (type == 0) {
              this._person.names = value;
            } else if (type == 1) {
              this._person.surnames = value;
            } else if (type == 2) {
              this._person.birthday = value;
            } else if (type == 3) {
              this._person.cellphone = value;
            } else if (type == 4) {
              this._cuenta.email = value;
            } else if (type == 5) {
              this._cuenta.recovery_email = value;
            } else if (type == 6) {
              this._cuenta.password = value;
            }
          },
        ),
      );
    }

    Widget _showButtonForm(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: 0, top: 8),
        child: new InkWell(
          onTap: () {
            if (_load == false) {
              _registerUserIntoFirebase(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 56,
            height: 50.0,
            decoration: BoxDecoration(
              color: _load == false ? Color(0xFF3ACCE1) : Color(0xFF78849E),
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
            padding: EdgeInsets.only(bottom: 25, top: 0),
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
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _showLogo(),
              _showLoadingIndicator,
              _inputText(0, TextInputType.text, "Nombres", "Nombres",
                  "Debes ingresar tu nombre"),
              _inputText(1, TextInputType.text, "Apellidos", "Apellidos",
                  "Debes ingresar tu apellido"),
              _inputText(
                  2,
                  TextInputType.text,
                  "Fecha de nacimiento dd/mm/aaaa",
                  "Fecha de nacimiento",
                  "Debes ingresar tu fecha de nacimiento"),
              _inputText(3, TextInputType.number, "Teléfono", "Teléfono",
                  "Debes ingresar tu teléfono"),
              _inputText(4, TextInputType.text, "Email", "Email",
                  "Debes ingresar tu email"),
              _inputText(
                  5,
                  TextInputType.text,
                  "Email de recuperación",
                  "Email de recuperación",
                  "Debes ingresar tu email de recuperación"),
              _inputText(6, TextInputType.text, "Password", "Password",
                  "Debes ingresar tu contraseña, mínimo 8 caracteres"),
              _showButtonForm(context),
            ],
          ));
    }

    return SafeArea(
      child: WillPopScope(
          onWillPop: () {
            if (this._load) {
              return null;
            } else {
              return Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Splash()),
              );
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: Builder(
              builder: (bcontext) => Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 28, right: 28, bottom: 40),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                  ),
                  child: _jointPartsForm(bcontext),
                ),
              ),
            ),
          )),
    );
  }

  void _showSnackBar(String mensaje) {
    var snackBar = SnackBar(content: Text(mensaje));
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _changeStateLoader(bool valor) {
    setState(() {
      _load = valor;
    });
  }

  void _registerUserIntoFirebase(BuildContext context) {
    _changeStateLoader(true);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      String id_person = db.collection("account").document().documentID;
      this._person.picture = "";
      this._person.register_date = Timestamp.now();
      this._cuenta.state = 0;
      this._cuenta.type = 1;
      print(this._cuenta.toMap());
      Future<AuthResult> a = auth.createUserWithEmailAndPassword(email: this._cuenta.email, password: this._cuenta.password);
      a.then((data) async {
        this._cuenta.id_person = id_person;
        await db.collection("account").document(data.user.uid).setData(this._cuenta.toMap());
        await db.collection("person").document(id_person).setData(this._person.toMap());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Sitios()),
        );
      }).catchError((error) {
        _changeStateLoader(false);
        _showSnackBar(error.toString());
      });
    } else {
      _changeStateLoader(false);
    }
  }
}
