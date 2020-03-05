import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Category {

  String _label;
  db.Timestamp _register_date;


  Category(){
    this._label = "";
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["label"] = this._label;
    map["register_date"] = this._register_date;

    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
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


}