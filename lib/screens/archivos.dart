import 'package:barber_shop/screens/archivos/productos/add_productos.dart';
import 'package:barber_shop/screens/archivos/estilos/edit_estilos.dart';
import 'package:barber_shop/screens/archivos/estilos/add_estilos.dart';
import 'package:barber_shop/screens/archivos/productos/edit_productos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class archivos extends StatelessWidget {
  const archivos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          espacio,
          Text(
            'Productos',
            style: TextStyle(fontFamily: 'Arial', fontSize: 14),
          ),
          espacio,
          addItems(),
          btnEditarItems(),
          espacio,
          Text(
            'Estilos de corte',
            style: TextStyle(fontFamily: 'Arial', fontSize: 14),
          ),
          espacio,
          btnAddEstilos(),
          btnEditarEstilos(),
        ],
      ),
    );
  }
}

class addItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      Expanded(
        child: TextButton(
          style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => addProductos()));
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Row(
                children: [
                  Icon(CupertinoIcons.folder_fill_badge_plus),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  const Text(
                    'Añadir productos',
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

class btnEditarItems extends StatelessWidget {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => editProductos()));
              },
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.folder_badge_minus),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Text(
                          'Editar productos',
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

class btnAddEstilos extends StatelessWidget {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddEstilos()));
              },
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.scissors),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Text(
                          'Añadir estilos de corte',
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

class btnEditarEstilos extends StatelessWidget {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => editEstilos()));
              },
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.scissors),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Text(
                          'Editar estilos de corte',
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
