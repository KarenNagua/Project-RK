import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Acceso {

  String _id;
  String _external_id;
  db.Timestamp _created_at;
  db.Timestamp _updated_at;
  String _cuenta;
  String _pin;
  String _acceso_token;
  String _id_persona;

  Acceso(){
    this._id = db.Firestore.instance.collection('acceso').document().documentID;
    this._external_id = "";
    this._cuenta = "";
    this._pin = "";
    this._id_persona = "";
    this._acceso_token = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = this._id;
    map["external_id"] = this._external_id;
    map["created_at"] = this._created_at;
    map["updated_at"] = this._updated_at;
    map["cuenta"] = this._cuenta;
    map["pin"] = this._pin;
    map["id_persona"] = this._id_persona;
    map["acceso_token"] = this._acceso_token;

    return map;
  }

  Acceso.fromMap(Map<String, dynamic> map) {

    this._id = map["id"];
    this._external_id = map["external_id"];
    this._created_at = map["created_at"];
    this._updated_at = map["updated_at"];
    this._cuenta = map["cuenta"];
    this._pin = map["pin"];
    this._id_persona = map["id_persona"];
    this._acceso_token = map["acceso_token"];
  }

  String get id_persona => _id_persona;

  set id_persona(String value) {
    _id_persona = value;
  }

  String get acceso_token => _acceso_token;

  set acceso_token(String value) {
    _acceso_token = value;
  }

  String get pin => _pin;

  set pin(String value) {
    _pin = value;
  }

  String get cuenta => _cuenta;

  set cuenta(String value) {
    _cuenta = value;
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