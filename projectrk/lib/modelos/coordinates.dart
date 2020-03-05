
class Coordinates {

  double _lat;
  double _lng;

  Coordinates();


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["lat"] = this._lat;
    map["lng"] = this._lng;

    return map;
  }

  Coordinates.fromMap(Map<String, dynamic> map) {

    this._lat = map["lat"];
    this._lng = map["lng"];

  }

  double get lng => _lng;

  set lng(double value) {
    _lng = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }


}