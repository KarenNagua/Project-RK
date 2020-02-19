import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bancaonline/modelos/persona.dart';
import 'package:bancaonline/modelos/cuenta.dart';
import 'package:bancaonline/modelos/movimiento.dart';
import 'package:bancaonline/modelos/transaccion.dart';
import 'package:bancaonline/vistas/home.dart';
import 'package:bancaonline/controladores/listener_movimientos.dart';

class ControlHome {
  ListenerMovimientos _listener;
  Persona _persona;
  List<Cuenta> _cuentas;
  List<Transaccion> _transacciones;
  List<Movimiento> _movimientos;

  FirebaseUser _user;
  FirebaseUser get user => _user;
  set user(FirebaseUser value) => _user = value;

  final db = Firestore.instance;

  ControlHome() {}

  getMovimientos() async {
    /*Movimiento m = new Movimiento();
    m.nombre = "Deposito en cuenta de ahorro";
    m.siglas = "DCP";
    m.tipo = "DEPOSITO";
    m.created_at = Timestamp.now();
    m.updated_at = Timestamp.now();

    Transaccion t = new Transaccion();
    t.created_at = Timestamp.now();
    t.updated_at = Timestamp.now();
    t.valor = 40.0;
    t.id_device = "movil";
    t.nro_celular = this._persona.celular;
    t.nro_cuenta = this._cuentas.elementAt(0).nro_cuenta;
    t.id_movimiento = m.id;
    t.id_cuenta = this._cuentas.elementAt(0).id;
    t.saldo_actual = this._cuentas.elementAt(0).saldo + 40.0;
    t.nro_transaccion = "0000000003";

    await db.collection("movimiento").add(m.toMap());
    await db.collection("transaccion").add(t.toMap());
    print("Ejcutado");*/
    QuerySnapshot data_transaccion = await db
        .collection("transaccion")
        .where("id_cuenta", isEqualTo: this._cuentas.elementAt(0).id)
        .orderBy("nro_transaccion")
        .getDocuments();
    QuerySnapshot data_movimientos =
        await db.collection("movimiento").getDocuments();

    this._transacciones = data_transaccion.documents
        .map((doc) => Transaccion.fromMap(doc.data))
        .toList();
    this._movimientos = data_movimientos.documents
        .map((doc) => Movimiento.fromMap(doc.data))
        .toList();
    this._listener.setSectionMovimientos(true);
    print(this._transacciones.length);
    print(this._movimientos.length);
  }

  Widget getSectionUsuario(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xFF3ACCE1),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [BoxShadow(blurRadius: 0.01)]),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )),
            Container(
              decoration: BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nombre:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        this._persona.nombres,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Apellidos:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        this._persona.apellidos,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nro. de cuenta:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        this._cuentas.elementAt(0).nro_cuenta,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Saldo:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        this._cuentas.elementAt(0).saldo.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Movimiento _getMovimientoData(id_transaccion) {
    Movimiento aux = null;
    this._movimientos.forEach((m) {
      if (m.id == id_transaccion) {
        aux = m;
      }
    });
    return aux;
  }

  TableRow _getRow(Movimiento m, Transaccion t) {
    return TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(

              ),
              width: 230,
              child: Text(
                t.created_at.toDate().toUtc().toString().split(".")[0],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 270,
              child: Text(
                m.nombre,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 100,
              child: Text(
                m.siglas,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 170,
              child: Text(
                m.tipo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 200,
              child: Text(
                t.nro_transaccion,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 100,
              child: Text(
                t.valor.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 100,
              child: Text(
                t.saldo_actual.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              )
            ),
          ],
        ),
      )
    ]);
  }

  List<TableRow> _getTableContent() {
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(

              ),
              width: 230,
              child: Text(
                "Fecha",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 270,
              child: Text(
                "Descripción",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 100,
              child: Text(
                "Siglas",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 170,
              child: Text(
                "Tipo",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 200,
              child: Text(
                "Nro. Trans",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              decoration: BoxDecoration(

              ),
              width: 100,
              child: Text(
                "Valor",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
                decoration: BoxDecoration(

                ),
                width: 100,
                child: Text(
                  "Saldo",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700),
                )),
          ],
        ),
      )
    ]));
    this._transacciones.forEach((t) {
      Movimiento m = this._getMovimientoData(t.id_movimiento);
      if (m != null) {
        print(m.nombre);
        rows.add(this._getRow(m, t));
      }
    });
    return rows;
  }

  Widget getSectionMovimientos() {
    return Expanded(
        flex: 8,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1200,
            child: ListView(
              padding: EdgeInsets.only(top: 20),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 40),
                  child: Text(
                    "Detalle de movimientos",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3ACCE1),
                    ),
                  ),
                ),
                Table(
                  children: this._getTableContent(),
                  // other stuff
                )
              ],
            ),
          ),
        ));
  }

  Persona get persona => _persona;

  set persona(Persona value) {
    _persona = value;
  }

  List<Cuenta> get cuentas => _cuentas;

  set cuentas(List<Cuenta> value) {
    _cuentas = value;
  }

  List<Movimiento> get movimientos => _movimientos;

  set movimientos(List<Movimiento> value) {
    _movimientos = value;
  }

  List<Transaccion> get transacciones => _transacciones;

  set transacciones(List<Transaccion> value) {
    _transacciones = value;
  }

  ListenerMovimientos get listener => _listener;

  set listener(ListenerMovimientos value) {
    _listener = value;
  }
}
