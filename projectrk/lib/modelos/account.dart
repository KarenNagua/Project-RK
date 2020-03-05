import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Account {

  String _id_person;
  String _email;
  String _recovery_email;
  String _password;
  int _state;
  int _type;


  Account(){
    this._id_person = "";
    this._email = "";
    this._recovery_email = "";
    this._password = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id_person"] = this._id_person;
    map["email"] = this._email;
    map["recovery_email"] = this._recovery_email;
    map["password"] = this._password;
    map["state"] = this._state;
    map["type"] = this._type;

    return map;
  }

  Account.fromMap(Map<String, dynamic> map) {

    this._id_person = map["id_person"];
    this._email = map["email"];
    this._recovery_email = map["recovery_email"];
    this._password = map["password"];
    this._state = map["state"];
    this._type = map["type"];
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  int get state => _state;

  set state(int value) {
    _state = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get recovery_email => _recovery_email;

  set recovery_email(String value) {
    _recovery_email = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get id_person => _id_person;

  set id_person(String value) {
    _id_person = value;
  }


}