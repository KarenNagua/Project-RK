import 'package:cloud_firestore/cloud_firestore.dart' as db;

class MySites {

  String _id_account;
  String _id_person;
  String _id_site;
  db.Timestamp _register_date;


  MySites(){
    this._id_account = "";
    this._id_person = "";
    this._id_site = "";
    this._register_date = db.Timestamp.now();
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id_account"] = this._id_account;
    map["id_person"] = this._id_person;
    map["id_site"] = this._id_site;
    map["register_date"] = this._register_date;

    return map;
  }

  MySites.fromMap(Map<String, dynamic> map) {
    this._id_account = map["id_account"];
    this._id_person = map["id_person"];
    this._id_site = map["id_site"];
    this._register_date = map["register_date"];
  }

  db.Timestamp get register_date => _register_date;

  set register_date(db.Timestamp value) {
    _register_date = value;
  }

  String get id_site => _id_site;

  set id_site(String value) {
    _id_site = value;
  }

  String get id_person => _id_person;

  set id_person(String value) {
    _id_person = value;
  }

  String get id_account => _id_account;

  set id_account(String value) {
    _id_account = value;
  }


}