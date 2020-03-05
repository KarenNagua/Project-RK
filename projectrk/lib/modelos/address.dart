
class Address {

  String _main;
  String _reference;
  String _secondary;

  Address();


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["main"] = this._main;
    map["reference"] = this._reference;
    map["secondary"] = this._secondary;

    return map;
  }

  Address.fromMap(Map<String, dynamic> map) {

    this._main = map["main"];
    this._reference = map["reference"];
    this._secondary = map["secondary"];

  }

  String get secondary => _secondary;

  set secondary(String value) {
    _secondary = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  String get main => _main;

  set main(String value) {
    _main = value;
  }


}