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
import 'package:projectrk/views/sitios.dart';
import 'package:projectrk/views/splash.dart';


class Cuenta extends StatefulWidget {
  @override
  _CuentaState createState() => _CuentaState();
}

class _CuentaState extends State<Cuenta> with TickerProviderStateMixin {

  FirebaseUser _user;
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final StorageReference storage = FirebaseStorage().ref();
  File _image;

  Account _cuenta;
  Person _persona;
  bool _canEdit = false;
  bool _load = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    auth.currentUser().then((user){
      this._user = user;
      this.getDataUser();
    }).catchError((error){
      this._user = null;
    });
  }

  void getDataUser() async {
    DocumentSnapshot a = await db.collection("account")
      .document(this._user.uid)
      .get();

    Account aux = Account.fromMap(a.data);
    DocumentSnapshot b = await db.collection("person")
        .document(aux.id_person)
        .get();

    setState(() {
      this._cuenta = aux;
      this._persona = Person.fromMap(b.data);
    });
  }

  String _getInitialValue(int type) {
    if (type == 0) {
      return this._persona.names;
    } else if (type == 1) {
      return this._persona.surnames;
    } else if (type == 2) {
      return this._persona.birthday;
    } else if (type == 3) {
      return this._persona.cellphone;
    } else if (type == 4) {
      return this._cuenta.recovery_email;
    }
  }

  void _updateDataUser() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() {
        this._load = true;
        this._canEdit = false;
      });
      String url;
      if (this._image != null) {
        StorageUploadTask uploadTask = storage
            .child("pictures/" + p.basename(this._image.path)).putFile(_image);
        await uploadTask.onComplete;
        url = await storage
            .child("pictures/" + p.basename(this._image.path)).getDownloadURL();
        setState(() {
          this._persona.picture = url;
        });
      }

      await db.collection("account")
        .document(this._user.uid)
        .setData(this._cuenta.toMap());

      await db.collection("person")
          .document(this._cuenta.id_person)
          .setData(this._persona.toMap());

      setState(() {
        this._load = false;
      });
    }
  }

  void _getNewPicture() async {
    if (this._canEdit) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        print("Aqui");
        print(image);
        this._image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget _normalAppBar(){
      return AppBar(
        backgroundColor: Color(0xFF454F63),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () { _scaffoldKey.currentState.openDrawer(); },
        ),
        title: Text(
          "Cuenta",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFFffffff)
          ),
        ),
        actions: <Widget>[
          this._load ?
          Container(
            width: 55,
            padding: EdgeInsets.all(15),
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              backgroundColor: Colors.white,
            ),
          )
          : this._canEdit ?
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => this._updateDataUser(),
          ) : IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                this._canEdit = true;
              });
            },
          )
        ],
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

    Widget _inputText(int type, TextInputType typeInput, String hint, String label, String error) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        child: TextFormField(
          enabled: this._canEdit,
          maxLines: 1,
          keyboardType: typeInput,
          obscureText: type == 6,
          initialValue: this._getInitialValue(type),
          style: TextStyle(color: Colors.black, fontSize: 13.0),
          decoration: InputDecoration(
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFFFFFF)),
                borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF454F63)),
                borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF454F63)),
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
                color: Color(0xFF454F63), fontWeight: FontWeight.w600),
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
              this._persona.names = value;
            } else if (type == 1) {
              this._persona.surnames = value;
            } else if (type == 2) {
              this._persona.birthday = value;
            } else if (type == 3) {
              this._persona.cellphone = value;
            } else if (type == 4) {
              this._cuenta.recovery_email = value;
            }
          },
        ),
      );
    }

    return WillPopScope(
      onWillPop: (){

      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.only(left: 25),
                child: this._cuenta != null && this._persona != null ?
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: this._persona.picture.length > 0 ? DecorationImage(
                              image: NetworkImage(
                                this._persona.picture,
                              ),
                              fit: BoxFit.cover
                          ) : null
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        this._persona.names.split(" ")[0] + " " + this._persona.surnames.split(" ")[0],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        this._cuenta.email,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11
                        ),
                      ),
                    )
                  ],
                ) : Container(
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
                  //Is the same window, not change
                },
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
        body: Form(
          key: this._formKey,
          child: Stack(
            children: <Widget>[
              this._cuenta != null && this._persona != null ?
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => this._getNewPicture(),
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(60),
                              image: this._image != null ?
                              DecorationImage(
                                  image: FileImage(
                                      this._image
                                  ),
                                  fit: BoxFit.cover
                              )
                                  : this._persona.picture.length > 0 ? DecorationImage(
                                  image: NetworkImage(
                                    this._persona.picture,
                                  ),
                                  fit: BoxFit.cover
                              ) : null
                          ),
                        ),
                      ),
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
                      _inputText(
                          4,
                          TextInputType.text,
                          "Email de recuperación",
                          "Email de recuperación",
                          "Debes ingresar tu email de recuperación"),
                    ],
                  ),
                ),
              ) : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}