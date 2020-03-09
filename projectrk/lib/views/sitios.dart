import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as dir;
import 'package:google_map_polyline/google_map_polyline.dart' as pol;
import 'package:projectrk/modelos/account.dart';
import 'package:projectrk/modelos/category.dart';
import 'package:projectrk/modelos/mysites.dart';
import 'package:projectrk/modelos/person.dart';
import 'package:projectrk/modelos/site.dart';
import 'package:projectrk/views/about.dart';
import 'package:projectrk/views/cuenta.dart';
import 'package:projectrk/views/splash.dart';

class Sitios extends StatefulWidget {
  @override
  _SitiosState createState() => _SitiosState();
}

class _SitiosState extends State<Sitios> with TickerProviderStateMixin {
  FirebaseUser _user;
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  Account _cuenta;
  Person _persona;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-4.001387, -79.207213), zoom: 13.0);

  dir.GoogleMapsDirections _directions = dir.GoogleMapsDirections(
    apiKey: "AIzaSyCotEFBZ2kPSkGcgB65fQ-ZtBDVtrXtoDI"
  );
  pol.GoogleMapPolyline _googleePolylines = pol.GoogleMapPolyline(
      apiKey: "AIzaSyAIPnETEqnVLpCPD3kXwIJ9wepfmsW4Ss4"
  );
  Set<Polyline> _route = Set();
  List<LatLng> _coordenadas = [];



  //Set<Marker> _markers = Set();
  List<Marker> _markers = [];
  Map<String, Category> _categorias = {};
  Map<String, Site> _sitios = {};
  Map<String, Site> _sitios_search = {};
  Map<String, MySites> _mysites = {};
  bool _showInfo = true;
  bool _showSearch = false;
  bool _isSearch = false;
  Position _userPosition;
  String _id_categoria = "*";
  Site _currentSite;

  @override
  void initState() {
    super.initState();
    this.getLocation();
    auth.currentUser().then((user) {
      this._user = user;
      this.getDataUser();
      this.getSitesFromDb();
      this.getMySitesFromDb();
      this.getDataCategorias();
    }).catchError((error) {
      this._user = null;
    });
  }

  void getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      this._userPosition = currentLocation;
      this._cameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.0);
    });
  }

  void getDataUser() async {
    DocumentSnapshot a =
        await db.collection("account").document(this._user.uid).get();

    Account aux = Account.fromMap(a.data);
    DocumentSnapshot b =
        await db.collection("person").document(aux.id_person).get();

    setState(() {
      this._cuenta = aux;
      this._persona = Person.fromMap(b.data);
    });
  }

  void getDataCategorias() async {
    QuerySnapshot a = await db.collection("category").getDocuments();

    setState(() {
      this._categorias["*"] = null;
      a.documents.forEach((s) {
        this._categorias[s.documentID] = Category.fromMap(s.data);
      });
    });
  }

  void getSitesFromDb() async {
    QuerySnapshot data = await db
        .collection("site")
        .where("estado", isEqualTo: 0)
        .getDocuments();
    setState(() {
      data.documents.forEach((s) {
        this._sitios[s.documentID] = Site.fromMap(s.data);
      });
      this._sitios_search = this._sitios;
      this._markers.clear();
      this._sitios.forEach((id, sitio) {
        final _marker = Marker(
            markerId: MarkerId(sitio.label),
            position: LatLng(sitio.coordinates.lat, sitio.coordinates.lng),
            infoWindow: InfoWindow(
                title: sitio.label,
                onTap: () {
                  //Show site taped in list at botton
                }));
        this._markers.add(_marker);
      });
    });
  }

  void getMySitesFromDb() async {
    QuerySnapshot data = await db
        .collection("mysites")
        .where("id_account", isEqualTo: this._user.uid)
        .getDocuments();
    setState(() {
      data.documents.forEach((s) {
        this._mysites[s.documentID] = MySites.fromMap(s.data);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    this._controller.complete(controller);
  }

  bool _getStatusSite(String id) {
    bool res = false;
    this._mysites.forEach((id_mysite, s) {
      if (s.id_site == id) {
        print("entre");
        res = true;
      }
    });
    return res;
  }

  void _ubicarSitio(String id, Site site) async {
    GoogleMapController c = await this._controller.future;
    setState(() {
      c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(site.coordinates.lat, site.coordinates.lng),
          zoom: 17.0)));
    });
  }

  void _showInfoSite(String id, Site sitio) {
    setState(() {
      this._currentSite = sitio;
      this._showInfo = true;
    });
  }

  void _addSiteToFavorite(String id, Site sitio) async {
    if (this._user != null) {
      DocumentSnapshot data =
          await db.collection("account").document(this._user.uid).get();

      Account cuenta = Account.fromMap(data.data);
      MySites aux = new MySites();
      aux.id_site = id;
      aux.id_account = data.documentID;
      aux.id_person = cuenta.id_person;

      String id_ms = db.collection("mysites").document().documentID;
      await db.collection("mysites").document(id_ms).setData(aux.toMap());

      setState(() {
        this._mysites[id_ms] = aux;
      });
    }
  }

  void _removeSiteToFavorite(String id, Site sitio) {
    this._mysites.forEach((id_ms, mysite) async {
      if (mysite.id_site == id) {
        await db.collection("mysites").document(id_ms).delete();

        setState(() {
          this._mysites.remove(id_ms);
        });
      }
    });
  }

  Map<String, Site> _filterSitesByCategory() {
    Map<String, Site> aux = {};
    this._sitios.forEach((id, sitio) {
      if (this._id_categoria == "*" ||
          sitio.id_category == this._id_categoria) {
        aux[id] = sitio;
      }
    });
    return aux;
  }

  Map<String, Site> _filterSitesByQuery(String name, Map<String, Site> aux) {
    Map<String, Site> aux_b = {};
    aux.forEach((id, sitio) {
      if (sitio.label.toLowerCase().contains(name.toLowerCase())) {
        aux_b[id] = sitio;
      }
    });
    return aux_b;
  }

  String _getMenorSiteConMenorDistancia(Map<String, double> distancias){
    String id_site = distancias.keys.toList().elementAt(0);
    double distancia = distancias.values.toList().elementAt(0);
    distancias.forEach((id, dis) {
      if (dis < distancia) {
        id_site = id;
        distancia = dis;
      }
    });
    return id_site;
  }

  void _findDirections(LatLng from, LatLng to) async {
    this._coordenadas = await this._googleePolylines.getCoordinatesWithLocation(origin: from, destination: to);

    print(this._coordenadas);
    var line = Polyline(
        points: this._coordenadas,
        polylineId: PolylineId("Sitio más cercano"),
        color: Colors.red,
        width: 4
    );

    setState(() {
      print("me ejecute");
      this._route.add(line);
    });
  }

  void _searchSites(String name) {
    print(name);
    Map<String, Site> data = this._filterSitesByCategory();
    if (name.length > 0) {
      data = this._filterSitesByQuery(name, data);
    }

    setState(() {
      this._isSearch = true;
      this._sitios_search = data;
      this._markers.clear();
      this._sitios_search.forEach((id, sitio) {
        final _marker = Marker(
            markerId: MarkerId(sitio.label),
            position: LatLng(sitio.coordinates.lat, sitio.coordinates.lng),
            infoWindow: InfoWindow(
                title: sitio.label,
                onTap: () {
                  //Show site taped in list at botton
                }));
        this._markers.add(_marker);
      });
    });

    //Get todas las distancias
    print("data es aqui");
    print(data);
    if (this._userPosition != null) {
      print("1");
      Map<String, double> _distancias = {};
      print("2");
      data.forEach((id, site) {
        _distancias[id] = this._calculateDistance(this._userPosition.latitude, this._userPosition.longitude, site.coordinates.lat, site.coordinates.lng);
      });
      print("3");
      print("distancias");
      print(_distancias.values.toList());

      //Calcular la menor distancia
      String id_site = this._getMenorSiteConMenorDistancia(_distancias);
      //Trazar la ruta
      LatLng from = LatLng(this._userPosition.latitude, this._userPosition.longitude);
      LatLng to = LatLng(data[id_site].coordinates.lat, data[id_site].coordinates.lng);
      print("3");
      print(from);
      print(to);
      this._findDirections(from, to);
    }
  }

  double _calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    Widget _normalAppBar() {
      return AppBar(
        backgroundColor: Color(0xFF2A2E43),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
          "Sitios",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Color(0xFFffffff)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: FractionalOffset.topRight,
              end: FractionalOffset.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.0, 0.4, 1.0],
              colors: [
                new Color(0xFF2A2E43),
                new Color(0xFF2A2E43),
                new Color(0xFF2A2E43)
              ],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.only(left: 25),
                  child: this._cuenta != null && this._persona != null
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  image: this._persona.picture.length > 0
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            this._persona.picture,
                                          ),
                                          fit: BoxFit.cover)
                                      : null),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                this._persona.names.split(" ")[0] +
                                    " " +
                                    this._persona.surnames.split(" ")[0],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Text(
                                this._cuenta.email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            )
                          ],
                        )
                      : Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Color(0xFF2E3649), BlendMode.hue),
                      image: AssetImage("assets/fondo_barra.png"),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.black,
                  ),
                  title: Text('Sitios'),
                  onTap: () {
                    //Is the same window, not change
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  title: Text('Mi cuenta'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cuenta()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  title: Text('Acerca de'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => About()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                  title: Text('Cerrar Sesión'),
                  onTap: () async {
                    await auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Splash()),
                    );
                  },
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
          appBar: _normalAppBar(),
          body: Stack(
            children: <Widget>[
              this._cameraPosition != null
                  ? GoogleMap(
                      markers: this._markers.toSet(),
                      compassEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: _cameraPosition,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      polylines: this._route,
                      onTap: (position) {},
                    )
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              Positioned(
                top: 5,
                left: (MediaQuery.of(context).size.width * 0.06) / 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.94,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Color(0xFFf5f5f5),
                      borderRadius: BorderRadius.circular(18)),
                  child: this._categorias.length > 0
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              onChanged: (text) {
                                //Se ejecuta la busqueda
                                print("First text field: $text");
                                this._searchSites(text);
                              },
                              onTap: () {
                                setState(() {
                                  this._showSearch = true;
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Color(0xFFFFFFFF),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFFFFF)),
                                    borderRadius: BorderRadius.circular(15.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF454F63)),
                                    borderRadius: BorderRadius.circular(15.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF454F63)),
                                    borderRadius: BorderRadius.circular(15.0)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.6)),
                                    borderRadius: BorderRadius.circular(15.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.6)),
                                    borderRadius: BorderRadius.circular(15.0)),
                                hintText:
                                    "Ingresa el nombre del sitio a buscar",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 15, right: 15, top: 16, bottom: 16),
                              ),
                            ),
                            this._showSearch
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 5, right: 5),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      items: this
                                          ._categorias
                                          .map((id, sitio) {
                                            print(id);
                                            return MapEntry(
                                                id,
                                                DropdownMenuItem<String>(
                                                  value: id,
                                                  child: Text(
                                                    id != "*"
                                                        ? sitio.label
                                                        : "Todas",
                                                    style: TextStyle(),
                                                  ),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                      value: this._id_categoria,
                                      onChanged: (value) {
                                        setState(() {
                                          this._id_categoria = value;
                                          this._searchSites("");
                                        });
                                      },
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              this._sitios.length > 0
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.28,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white70),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: this._sitios_search.length,
                            itemBuilder: (context, index) {
                              String id = this._sitios_search.keys.toList().elementAt(index);
                              Site aux = this._sitios_search.values.toList().elementAt(index);
                              print(aux);
                              return Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.70),
                                  height: MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(28),
                                      image: DecorationImage(
                                        image: AssetImage("assets/site.png"),
                                        fit: BoxFit.cover,
                                      )),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 12),
                                              child: Text(
                                                aux.label,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 22,
                                                    color: Colors.white),
                                              )),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () =>
                                                    this._ubicarSitio(id, aux),
                                                child: Container(
                                                  width: 90,
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  padding: EdgeInsets.only(
                                                      left: 7,
                                                      right: 7,
                                                      top: 8,
                                                      bottom: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Icon(
                                                          Icons.my_location,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Ubicar",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    this._showInfoSite(id, aux),
                                                child: Container(
                                                  width: 90,
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Icon(
                                                          Icons.info,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Info",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: -12,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 10, right: 0),
                                          child: this._getStatusSite(id)
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                  onPressed: () => this
                                                      ._removeSiteToFavorite(
                                                          id, aux),
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                  onPressed: () => this
                                                      ._addSiteToFavorite(
                                                          id, aux),
                                                ),
                                        ),
                                      )
                                    ],
                                  ));
                            }),
                      ),
                    )
                  : Container(),
              this._showInfo && this._currentSite != null
                  ? Positioned(
                      left: (MediaQuery.of(context).size.width * 0.06) / 2,
                      bottom: MediaQuery.of(context).size.height * 0.30,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                            color: Color(0xFFf5f5f5),
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.30) *
                                      0.30,
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(this._currentSite.label,
                                      style: TextStyle(
                                          color: Color(0xFF454F63),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.timesCircle,
                                      color: Color(0xFF454F63),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        this._currentSite = null;
                                        this._showInfo = false;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.30) *
                                      0.70,
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                        this._currentSite.description,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Column(children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text("Principal:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13)),
                                              ),
                                              Text(
                                                  this
                                                      ._currentSite
                                                      .address
                                                      .main,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13)),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text("Secundaria:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13)),
                                              ),
                                              Text(
                                                  this
                                                      ._currentSite
                                                      .address
                                                      .secondary,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13)),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text("Referencia:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13)),
                                              ),
                                              Text(
                                                  this
                                                      ._currentSite
                                                      .address
                                                      .reference,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13)),
                                            ],
                                          )
                                        ]))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }
}
