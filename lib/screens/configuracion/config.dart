import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'corte_caja.dart';

class config extends StatelessWidget {
  const config({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          espacio,
          Text(
            'Configuraciones',
            style: TextStyle(fontFamily: 'Arial', fontSize: 14),
          ),
          corteDeCaja(),
          estadisticasVentas(),
        ],
      ),
    );
  }
}

class corteDeCaja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      Expanded(
        child: TextButton(
          style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ElegirFechaCorteCaja()));
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Row(
                children: [
                  Icon(CupertinoIcons.money_dollar_circle),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  const Text(
                    'Corte de caja',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

Widget espacio = SizedBox(
  height: 10,
  width: 10,
);

class estadisticasVentas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Expanded(
          child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Contrata la version Premium para todas las características"),
                  duration: const Duration(seconds: 4),
                ));
              },
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.square_list),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Text(
                          'Estadisticas de ventas',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ))),
        ),
      ],
    );
  }
}
