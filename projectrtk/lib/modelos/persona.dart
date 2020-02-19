import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Persona {

  String _id;
  String _external_id;
  db.Timestamp _created_at;
  db.Timestamp _updated_at;
  String _dni;
  String _apellidos;
  String _nombres;
  String _correo;
  String _pais;
  String _ciudad;
  String _celular;
  String _token;

  Persona(){
    this._id = db.Firestore.instance.collection('persona').document().documentID;
    this._external_id = "";
    this._dni = "";
    this._apellidos = "";
    this._nombres = "";
    this._correo = "";
    this._pais = "";
    this._ciudad = "";
    this._celular = "";
    this._token = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = this._id;
    map["external_id"] = this._external_id;
    map["created_at"] = this._created_at;
    map["updated_at"] = this._updated_at;
    map["dni"] = this._dni;
    map["apellidos"] = this._apellidos;
    map["nombres"] = this._nombres;
    map["correo"] = this._correo;
    map["pais"] = this._pais;
    map["ciudad"] = this._ciudad;
    map["celular"] = this._celular;
    map["token"] = this._token;

    return map;
  }

  Persona.fromMap(Map<String, dynamic> map) {

    this._id = map["id"];
    this._external_id = map["external_id"];
    this._created_at = map["created_at"];
    this._updated_at = map["updated_at"];
    this._dni = map["dni"];
    this._apellidos = map["apellidos"];
    this._nombres = map["nombres"];
    this._correo = map["correo"];
    this._pais = map["pais"];
    this._ciudad = map["ciudad"];
    this._celular = map["celular"];
    this._token = map["token"];
  }

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get celular => _celular;

  set celular(String value) {
    _celular = value;
  }

  String get ciudad => _ciudad;

  set ciudad(String value) {
    _ciudad = value;
  }

  String get pais => _pais;

  set pais(String value) {
    _pais = value;
  }

  String get correo => _correo;

  set correo(String value) {
    _correo = value;
  }

  String get nombres => _nombres;

  set nombres(String value) {
    _nombres = value;
  }

  String get apellidos => _apellidos;

  set apellidos(String value) {
    _apellidos = value;
  }

  String get dni => _dni;

  set dni(String value) {
    _dni = value;
  }

  db.Timestamp get updated_at => _updated_at;

  set updated_at(db.Timestamp value) {
    _updated_at = value;
  }

  db.Timestamp get created_at => _created_at;

  set created_at(db.Timestamp value) {
    _created_at = value;
  }

  String get external_id => _external_id;

  set external_id(String value) {
    _external_id = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}