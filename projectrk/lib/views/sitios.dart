import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectrk/modelos/account.dart';
import 'package:projectrk/modelos/mysites.dart';
import 'package:projectrk/modelos/person.dart';
import 'package:projectrk/modelos/site.dart';
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
  CameraPosition _cameraPosition;

  //Set<Marker> _markers = Set();
  List<Marker> _markers = [];
  Map<String, Site> _sitios = {};
  Map<String, MySites> _mysites = {};
  bool _showInfo = true;
  Site _currentSite;

  @override
  void initState() {
    super.initState();
    this.getLocation();
    auth.currentUser().then((user){
      this._user = user;
      this.getDataUser();
      this.getSitesFromDb();
      this.getMySitesFromDb();
    }).catchError((error){
      this._user = null;
    });
  }

  void getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      this._cameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0
      );
    });
  }

  void getDataUser() async {
    DocumentSnapshot a = await db.collection("account")
      .document(this._user.uid)
      .get();

    Account aux = Account.fromMap(a.data);
    DocumentSnapshot b = await db.collection("person")
        .document(aux.id_person)
        .get();

    setState(() {
      this._cuenta = aux;
      this._persona = Person.fromMap(b.data);
    });
  }
  
  void getSitesFromDb() async {
    QuerySnapshot data = await db.collection("site")
        .where("estado", isEqualTo: 0)
        .getDocuments();
    setState(() {
      data.documents.forEach((s) {
        this._sitios[s.documentID] = Site.fromMap(s.data);
      });
      this._markers.clear();
      this._sitios.forEach((id, sitio) {
        final _marker = Marker(
            markerId: MarkerId(sitio.label),
            position: LatLng(sitio.coordinates.lat, sitio.coordinates.lng),
            infoWindow: InfoWindow(
              title: sitio.label,
              onTap: () {
                //Show site taped in list at botton
              }
            )
        );
        this._markers.add(_marker);
      });
    });
  }

  void getMySitesFromDb() async {
    QuerySnapshot data = await db.collection("mysites")
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
      if(s.id_site == id) {
        print("entre");
        res = true;
      }
    });
    return res;
  }

  void _ubicarSitio(String id, Site site) async {
    GoogleMapController c =  await this._controller.future;
    setState(() {
      c.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(site.coordinates.lat, site.coordinates.lng),
          zoom: 17.0
        )
      ));
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
      DocumentSnapshot data = await db.collection("account")
          .document(this._user.uid)
          .get();

      Account cuenta = Account.fromMap(data.data);
      MySites aux = new MySites();
      aux.id_site = id;
      aux.id_account = data.documentID;
      aux.id_person = cuenta.id_person;
      
      String id_ms = db.collection("mysites").document().documentID;
      await db.collection("mysites")
        .document(id_ms)
        .setData(aux.toMap());

      setState(() {
        this._mysites[id_ms] = aux;
      });
    }
  }

  void _removeSiteToFavorite(String id, Site sitio) {
    this._mysites.forEach((id_ms, mysite) async {
      if (mysite.id_site == id) {
        await db.collection("mysites")
          .document(id_ms)
          .delete();

        setState(() {
          this._mysites.remove(id_ms);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _normalAppBar(){
      return AppBar(
        backgroundColor: Color(0xFF3ACCE1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () { _scaffoldKey.currentState.openDrawer(); },
        ),
        title: Text(
          "Sitios",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFFffffff)
          ),
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
                new Color(0xFF3ACCE1),
                new Color(0xFF3ACCE1),
                new Color(0xFF3ACCE1)
              ],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: (){

      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: this._cuenta != null && this._persona != null ?
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: this._persona.picture.length > 0 ? DecorationImage(
                              image: NetworkImage(
                                this._persona.picture,
                              ),
                              fit: BoxFit.cover
                          ) : null
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          this._persona.names.split(" ")[0] + " " + this._persona.surnames.split(" ")[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ) : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF3ACCE1),
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
        resizeToAvoidBottomInset: false,
        appBar: _normalAppBar(),
        body: Stack(
          children: <Widget>[
            this._cameraPosition != null ?
            GoogleMap(
              markers: this._markers.toSet(),
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _cameraPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onTap: (position){

              },
            ) : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            this._sitios.length > 0 ?
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.24,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white70
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: this._sitios.length,
                  itemBuilder: (context, index) {
                    String id = this._sitios.keys.toList().elementAt(index);
                    Site aux = this._sitios.values.toList().elementAt(index);
                    print(aux);
                    return Container(
                      width: (MediaQuery.of(context).size.width * 0.55) - 18,
                      height: MediaQuery.of(context).size.height,
                      margin: EdgeInsets.only(left: 4, right: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFf2f2f2),
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 80,
                                  child: Center(
                                    child: Text(
                                      aux.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.blueGrey
                                      ),
                                    ),
                                  )
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => this._ubicarSitio(id, aux),
                                    child: Container(
                                      width: 90,
                                      padding: EdgeInsets.only(left: 7, right: 7, top: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
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
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => this._showInfoSite(id, aux),
                                    child: Container(
                                      width: 90,
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
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
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: this._getStatusSite(id) ?
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () => this._removeSiteToFavorite(id, aux),
                              ) : IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () => this._addSiteToFavorite(id, aux),
                              ),
                            ),
                          )
                        ],
                      )
                    );
                  }
                ),
              ),
            ) : Container(),
            this._showInfo && this._currentSite != null ?
              Positioned(
                left: (MediaQuery.of(context).size.width * 0.07) / 2,
                bottom: MediaQuery.of(context).size.height * 0.24,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: MediaQuery.of(context).size.height * 0.20,
                  padding: EdgeInsets.only(left: 25, right: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFFf2f2f2),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width - 50,
                                padding: EdgeInsets.only(top: 22, bottom: 15),
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        this._currentSite.label,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        this._currentSite.description,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 13
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width - 50,
                                padding: EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Principal:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13
                                              )
                                          ),
                                        ),
                                        Text(
                                            this._currentSite.address.main,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13
                                            )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Secundaria:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13
                                              )
                                          ),
                                        ),
                                        Text(
                                            this._currentSite.address.secondary,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13
                                            )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Referencia:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13
                                              )
                                          ),
                                        ),
                                        Text(
                                            this._currentSite.address.reference,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13
                                            )
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.timesCircle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                this._currentSite = null;
                                this._showInfo = false;
                              });
                            } ,
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ) : Container()
          ],
        )
      ),
    );
  }
}