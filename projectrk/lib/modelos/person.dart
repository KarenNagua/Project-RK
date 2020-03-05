import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Person {

  String _birthday;
  String _cellphone;
  String _names;
  String _picture;
  String _surnames;
  db.Timestamp _register_date;


  Person(){
    this._birthday = this._cellphone = this._names = this._picture = this._surnames = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["birthday"] = this._birthday;
    map["cellphone"] = this._cellphone;
    map["names"] = this._names;
    map["pictures"] = this._picture;
    map["surnames"] = this._surnames;
    map["register_date"] = this._register_date;

    return map;
  }

  Person.fromMap(Map<String, dynamic> map) {

    this._birthday = map["birthday"];
    this._cellphone = map["cellphone"];
    this._names = map["names"];
    this._picture = map["pictures"];
    this._surnames = map["surnames"];
    this._register_date = map["register_date"];

  }

  db.Timestamp get register_date => _register_date;

  set register_date(db.Timestamp value) {
    _register_date = value;
  }

  String get surnames => _surnames;

  set surnames(String value) {
    _surnames = value;
  }

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  String get names => _names;

  set names(String value) {
    _names = value;
  }

  String get cellphone => _cellphone;

  set cellphone(String value) {
    _cellphone = value;
  }

  String get birthday => _birthday;

  set birthday(String value) {
    _birthday = value;
  }


}