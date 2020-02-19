import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Cuenta {

  String _id;
  String _external_id;
  String _nro_cuenta;
  db.Timestamp _created_at;
  db.Timestamp _updated_at;
  double _saldo;
  String _id_persona;

  Cuenta(){
    this._id = db.Firestore.instance.collection('cuenta').document().documentID;
    this._external_id = this._id;
    this._nro_cuenta = "";
    this._saldo = 0.0;
    this._id_persona = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = this._id;
    map["external_id"] = this._external_id;
    map["nro_cuenta"] = this._nro_cuenta;
    map["created_at"] = this._created_at;
    map["updated_at"] = this._updated_at;
    map["saldo"] = this._saldo;
    map["id_persona"] = this._id_persona;

    return map;
  }

  Cuenta.fromMap(Map<String, dynamic> map) {

    this._id = map["id"];
    this._external_id = map["external_id"];
    this._nro_cuenta = map["nro_cuenta"];
    this._created_at = map["created_at"];
    this._updated_at = map["updated_at"];
    this._saldo = double.parse(map["saldo"].toString());
    this._id_persona = map["id_persona"];
  }

  String get id_persona => _id_persona;

  set id_persona(String value) {
    _id_persona = value;
  }

  double get saldo => _saldo;

  set saldo(double value) {
    _saldo = value;
  }

  db.Timestamp get updated_at => _updated_at;

  set updated_at(db.Timestamp value) {
    _updated_at = value;
  }

  db.Timestamp get created_at => _created_at;

  set created_at(db.Timestamp value) {
    _created_at = value;
  }

  String get nro_cuenta => _nro_cuenta;

  set nro_cuenta(String value) {
    _nro_cuenta = value;
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