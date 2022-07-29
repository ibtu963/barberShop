import 'dart:async';

import 'package:barber_shop/screens/configuracion/datos_gen.dart';
import 'package:barber_shop/screens/configuracion/widgets/birthday_widget.dart';
import 'package:barber_shop/screens/ventas/vender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ElegirFechaCorteCaja extends StatefulWidget {
  const ElegirFechaCorteCaja({Key? key}) : super(key: key);

  @override
  _ElegirFechaCorteCajaState createState() => _ElegirFechaCorteCajaState();
}

class _ElegirFechaCorteCajaState extends State<ElegirFechaCorteCaja>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DateTime inicioCorte;
  late DateTime finCorte;
  double resulSuma = 0;
  List<RowCorteCaja> datosCorte = [];
  ListView datosCorteLV = ListView();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    inicioCorte = DateTime.now();
    finCorte = DateTime.now();
    datosCorteLV = ListView(
      children: datosCorte,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Config..."),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: [
            const Text(
              "Corte de caja",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontFamily: "Consolas"),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            buildFecha("Inicio", inicioCorte, false),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            buildFecha("fin", finCorte, true),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  print("corteGenerado");
                  getVentas();
                  Timer(Duration(seconds: 4), salir);
                },
                child: Text("Generar")),
            const SizedBox(
              height: 10,
              width: 10,
            ),
          ],
        ));
  }

  salir() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => DatosGen(datosCorteLV, resulSuma.toString())),
      ModalRoute.withName('/'));
  // Widget buildBtnGenerar(context) =>
  Widget buildFecha(String data, DateTime controlador, bool esFinal) =>
      buildTitle(
        title: data,
        child: BirthdayWidget(
          birthday: controlador,
          onChangedBirthday: (controlador) => setState(() {
            esFinal ? finCorte = controlador : inicioCorte = controlador;
          }),
        ),
      );

  void getVentas() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("ventas");

    QuerySnapshot ventasQS = await collectionReference.get();
    if (ventasQS.docs.length != 0) {
      for (var doc in ventasQS.docs) {
        String f = "", iC = "", iV = "", tt = "";
        String datos = doc.data().toString(); //Datos del documento
        datos = datos.substring(
            1, datos.length - 1); //quita los {} del dato del documento
        var datosDivi = datos.split(",");
        print(datos);
        bool estaDentro = false;
        for (var da in datosDivi) {
          String fechaAux2 = "";
          print("valor completo del cont $cont " + da);
          //con el puesto 0 del aux observamos el nombre de lakey
          var auxKey = da.split(":");
          String keyAux = auxKey[0].trim();
          String keyValor = auxKey[1].trim();
          print(keyAux);
          print(keyValor);
          //Nada
          if (keyAux == "fecha") {
            var datos2 = da.split("a:"); //Quiamos la key del valor
            var fechaAux = datos2[1].split(" ");
            fechaAux2 = fechaAux[1]; //Obtiene solo la fecha
            DateTime fechaObte =
                DateTime.parse(fechaAux2); //Lo convertimos a fecha
            //if que compara si es el mismo dia el de corte y el de los datos obtenidos
            if (fechaObte.isBefore(inicioCorte)) {
              estaDentro = false;

              print("La fecha de la bd es antes al incio");
              print(inicioCorte);
              print(fechaObte);
            } else {
              if (inicioCorte.compareTo(fechaObte) == 0) {
                print("La fecha de la bd es igual al incio");
                print(inicioCorte);
                print(fechaObte);
                estaDentro = true;
              } else {
                if (fechaObte.isAfter(inicioCorte)) {
                  print("La fecha de la bd es despues de la del incio");
                  if (fechaObte.isBefore(finCorte)) {
                    print("La fecha de l bd es antes del fin de corte");
                    print(inicioCorte);
                    print(fechaObte);
                    print(finCorte);

                    estaDentro = true;
                  } else {
                    if (fechaObte.compareTo(finCorte) == 0) {
                      print("La fecha de la bd es igual al fin de corte");
                      print(fechaObte);
                      print(finCorte);
                      estaDentro == true;
                    } else {
                      print("La fecha de la bd es desoues del fin de corte");
                      print(fechaObte);
                      print(finCorte);
                      estaDentro = false;
                    }
                  }
                }
              }
            }
          }

          if (estaDentro) {
            if (keyAux == "fecha") {
              f = fechaAux2;
              print("fechaa");
              print(keyValor);
            }
            if (keyAux == "idVenta") {
              iV = keyValor;
              print("idVenta");
              print(keyValor);
            }
            if (keyAux == "total") {
              double valor = double.parse(keyValor);
              resulSuma += valor;
              tt = valor.toString();
              print("idtotal");
              print(keyValor);
            }

            if (keyAux == "idCarrito") {
              iC = keyValor;
              print("idcarrito");
              print(keyValor);
            }
          }
        }
        if (estaDentro) {
          if (datosCorte.length < 1) {
            datosCorte.add(RowCorteCaja("Fecha", "IdVenta", "Total", ""));
          }
          datosCorte.add(RowCorteCaja(f, iV, tt, iC));
        }

        //  print(resultado);
        // corteGenerado.add(resultado);
      }
      print("El resultado de la suma es");
      print(resulSuma);
    }
  }
}

Widget buildTitle({
  required String title,
  required Widget child,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );

class RowCorteCaja extends StatelessWidget {
  String fecha = "", idVenta = "", total = "", idCarrito = "";
  RowCorteCaja(this.fecha, this.idVenta, this.total, this.idCarrito, {Key? key})
      : super(key: key);

  Container textStyleEdit(String dato) {
    var textDecorado = Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 2, color: Colors.grey.shade600),
        )),
        child: Text(
          dato,
          style: TextStyle(fontFamily: "Consolas", fontSize: 21),
        ));
    return textDecorado;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: textStyleEdit(fecha)),
        SizedBox(
          height: 8,
          width: 8,
        ),
        Expanded(flex: 2, child: textStyleEdit(idVenta)),
        SizedBox(
          height: 8,
          width: 8,
        ),
        Expanded(flex: 2, child: textStyleEdit("\$" + total)),
      ],
    );
  }
}
