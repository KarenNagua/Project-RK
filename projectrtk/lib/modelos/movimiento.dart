import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Movimiento {

  String _id;
  String _nombre;
  String _siglas;
  String _tipo;
  db.Timestamp _created_at;
  db.Timestamp _updated_at;

  Movimiento(){
    this._id = db.Firestore.instance.collection('movimiento').document().documentID;
    this._nombre = "";
    this._siglas = "";
    this._tipo = "DEBITO";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = this._id;
    map["nombre"] = this._nombre;
    map["siglas"] = this._siglas;
    map["tipo"] = this._tipo;
    map["created_at"] = this._created_at;
    map["updated_at"] = this._updated_at;

    return map;
  }

  Movimiento.fromMap(Map<String, dynamic> map) {

    this._id = map["id"];
    this._nombre = map["nombre"];
    this._siglas = map["siglas"];
    this._tipo = map["tipo"];
    this._created_at = map["created_at"];
    this._updated_at = map["updated_at"];
  }

  db.Timestamp get updated_at => _updated_at;

  set updated_at(db.Timestamp value) {
    _updated_at = value;
  }

  db.Timestamp get created_at => _created_at;

  set created_at(db.Timestamp value) {
    _created_at = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get siglas => _siglas;

  set siglas(String value) {
    _siglas = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}