import 'package:cloud_firestore/cloud_firestore.dart' as db;
import 'package:projectrk/modelos/coordinates.dart';
import 'address.dart';

class Site {

  Address _address;
  Coordinates _coordinates;
  String _description;
  int _estado;
  String _id_category;
  String _id_person;
  String _label;
  db.Timestamp _register_date;

  Site();

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["address"] = this._address.toMap();
    map["coordinates"] = this._coordinates.toMap();
    map["description"] = this._description;
    map["estado"] = this._estado;
    map["id_category"] = this._id_category;
    map["id_person"] = this._id_person;
    map["label"] = this._label;
    map["register_date"] = this._register_date;

    return map;
  }

  Site.fromMap(Map<String, dynamic> map) {

    this._address = Address.fromMap(map["address"]);
    this._coordinates = Coordinates.fromMap(map["coordinates"]);
    this._description = map["description"];
    this._estado = map["estado"];
    this._id_category = map["id_category"];
    this._id_person = map["id_person"];
    this._label = map["label"];
    this._register_date = map["register_date"];

  }

  db.Timestamp get register_date => _register_date;

  set register_date(db.Timestamp value) {
    _register_date = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  String get id_person => _id_person;

  set id_person(String value) {
    _id_person = value;
  }

  String get id_category => _id_category;

  set id_category(String value) {
    _id_category = value;
  }

  int get estado => _estado;

  set estado(int value) {
    _estado = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  Coordinates get coordinates => _coordinates;

  set coordinates(Coordinates value) {
    _coordinates = value;
  }

  Address get address => _address;

  set address(Address value) {
    _address = value;
  }


}