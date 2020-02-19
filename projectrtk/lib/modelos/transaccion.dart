import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Transaccion {

  String _id;
  db.Timestamp _created_at;
  db.Timestamp _updated_at;
  double _valor;
  String _id_device;
  String _nro_celular;
  String _nro_cuenta;
  String _latitud;
  String _longitud;
  String _id_movimiento;
  String _id_cuenta;
  double _saldo_actual;
  String _nro_transaccion;


  Transaccion(){
    this._id = db.Firestore.instance.collection('transaccion').document().documentID;
    this._valor = 0.0;
    this._id_device = "";
    this._nro_celular = "";
    this._nro_cuenta = "";
    this._latitud = "";
    this._longitud = "";
    this._id_movimiento = "";
    this._id_cuenta = "";
    this._saldo_actual = 0.0;
    this._nro_transaccion = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = this._id;
    map["created_at"] = this._created_at;
    map["updated_at"] = this._updated_at;
    map["valor"] = this._valor;
    map["id_device"] = this._id_device;
    map["nro_celular"] = this._nro_celular;
    map["nro_cuenta"] = this._nro_cuenta;
    map["latitud"] = this._latitud;
    map["longitud"] = this._longitud;
    map["id_movimiento"] = this._id_movimiento;
    map["id_cuenta"] = this._id_cuenta;
    map["saldo_actual"] = this._saldo_actual;
    map["nro_transaccion"] = this._nro_transaccion;

    return map;
  }

  Transaccion.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._created_at = map["created_at"];
    this._updated_at = map["updated_at"];
    this._valor = map["valor"];
    this._id_device = map["id_device"];
    this._nro_celular = map["nro_celular"];
    this._nro_cuenta = map["nro_cuenta"];
    this._latitud = map["latitud"];
    this._longitud = map["longitud"];
    this._id_movimiento = map["id_movimiento"];
    this._id_cuenta = map["id_cuenta"];
    this._saldo_actual = double.parse(map["saldo_actual"].toString());
    this._nro_transaccion = map["nro_transaccion"];
  }

  String get nro_transaccion => _nro_transaccion;

  set nro_transaccion(String value) {
    _nro_transaccion = value;
  }

  double get saldo_actual => _saldo_actual;

  set saldo_actual(double value) {
    _saldo_actual = value;
  }

  String get id_cuenta => _id_cuenta;

  set id_cuenta(String value) {
    _id_cuenta = value;
  }

  String get id_movimiento => _id_movimiento;

  set id_movimiento(String value) {
    _id_movimiento = value;
  }

  String get longitud => _longitud;

  set longitud(String value) {
    _longitud = value;
  }

  String get latitud => _latitud;

  set latitud(String value) {
    _latitud = value;
  }

  String get nro_cuenta => _nro_cuenta;

  set nro_cuenta(String value) {
    _nro_cuenta = value;
  }

  String get nro_celular => _nro_celular;

  set nro_celular(String value) {
    _nro_celular = value;
  }

  String get id_device => _id_device;

  set id_device(String value) {
    _id_device = value;
  }

  double get valor => _valor;

  set valor(double value) {
    _valor = value;
  }

  db.Timestamp get updated_at => _updated_at;

  set updated_at(db.Timestamp value) {
    _updated_at = value;
  }

  db.Timestamp get created_at => _created_at;

  set created_at(db.Timestamp value) {
    _created_at = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}