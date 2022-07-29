// ignore: file_names
import 'package:barber_shop/screens/home.dart';
import 'package:flutter/material.dart';

class DatosGen extends StatelessWidget {
  ListView datos = ListView();
  String total_gen = "";

  DatosGen(this.datos, this.total_gen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    salir() => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName('/'));
    return Scaffold(
      appBar: AppBar(
        title: Text("Total \$ = $total_gen"),
        automaticallyImplyLeading: false,
      ),
      body: datos,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salir();
        },
        child: Text("OK"),
      ),
    );
  }
}
