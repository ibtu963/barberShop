import 'dart:async';
import 'package:barber_shop/screens/archivos/models/ventas.dart';
import 'package:barber_shop/screens/archivos/models/ventas_carrito.dart';
import 'package:barber_shop/screens/archivos/servicios/ventas_carrito_service.dart';
import 'package:barber_shop/screens/archivos/servicios/producto_service.dart';
import 'package:barber_shop/screens/archivos/servicios/ventas_service.dart';
import 'package:barber_shop/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Vender());
}

//Control de texto para guardar
var myControllerPrecio = TextEditingController();
var myControllerCantidad = TextEditingController();
var myControllerEstiloNone = TextEditingController();
String valorSelec = "";
double totalCompra = 0.0;
int sizeListaVentas = 0;

bool estilo = false;
bool valorLista = false;

class Vender extends StatelessWidget {
  const Vender({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHome();
  }
}

void getLengthVentas() async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("ventas");
  int contLengtVentas = 0;
  QuerySnapshot productoQS = await collectionReference.get();
  if (productoQS != 0) {
    for (var doc in productoQS.docs) {
      contLengtVentas++;
    }
  }
  sizeListaVentas = contLengtVentas;
}

int cont = 0;
List<RowCarrito> productList = [];

ListView listaBotones = ListView(
  children: productList,
  controller: ScrollController(),
);

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  //Sirve para agregar datos nuevos, se guarda aqui
  _MyHomePageState() {
    getLengthVentas();
  }
  RowCarrito datosNuevos = RowCarrito("", "", "", "");

  Widget addProducto() => ElevatedButton(
      onPressed: () {
        setState(() {
          estilo = false;
        });
        opcionAddProEst(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
      child: Text(
        "Productos",
        style: TextStyle(color: Colors.grey.shade300),
      ));

  Widget addEstilo() => ElevatedButton(
      onPressed: () {
        setState(() {
          estilo = true;
        });
        opcionAddProEst(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
      child: Text(
        "Servicio",
        style: TextStyle(color: Colors.grey.shade300),
      ));
  salir() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      ModalRoute.withName('/'));

  Widget btnConfirmarCompra() => ElevatedButton(
      autofocus: valorLista,
      onPressed: () {
        setState(() {
          sumaTotal();
          estilo = false;
          opcionConfimarCompra(context);
        });
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
      child: Text(
        "Confirmar",
        style: TextStyle(color: Colors.grey.shade300),
      ));

  sumaTotal() {
    int cn = 0;
    for (var a in productList) {
      if (cn > 0) {
        totalCompra = totalCompra + double.parse(a.total);
        print("Cuando vale total compra");
        print(totalCompra);
      }
      cn++;
    }
  }

  opcionConfimarCompra(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
            children: [
              Text("Deseas pagar $totalCompra ?"),
              botonAceptarConfirmar(),
              btnCancelar()
            ],
          )));
        });
  }

  Widget botonAceptarConfirmar() => InkWell(
        onTap: () {
          String message = "";
          try {
            print("Iniando metodo");

            VentasService ventasService = VentasService();
            var now = new DateTime.now();

            VentasModel ventas = VentasModel(
                idVenta: "IVN$sizeListaVentas",
                idCarrito: "IC$sizeListaVentas",
                fecha: now.toString(),
                total: totalCompra.toString());
            ventasService.create(ventas);

            //Primero se sube el carrito para sumar
            VentasCarritoService vnCarSer = VentasCarritoService();
            int cn = 0;
            for (var a in productList) {
              cn++;
              RowCarrito auxCar = productList[cn];
              VentasCarritos ventaCar = VentasCarritos(
                  idCarrito: "IC$sizeListaVentas",
                  nombre: auxCar.nombre,
                  cantidad: auxCar.cantidad,
                  total: auxCar.total);

              vnCarSer.create(ventaCar);
            }
          } catch (e) {
            //message = 'Ocurrió un error';
            print(e);
          } finally {
            limpiar();
            estado();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ));
          }
          Timer(const Duration(seconds: 1), salir);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                  child: Text("Aceptar",
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade600),
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
      );

  opcionAddProEst(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  campoNombreProEst(),
                  estilo ? campoPrecio() : campoCantidad(),
                  btnAgregar(),
                  btnCancelar(),
                ],
              ),
            ),
          );
        });
  }

  Widget campoPrecio() => InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.number,
                controller: myControllerPrecio,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )),
              Icon(
                Icons.monetization_on,
                color: Colors.black,
              )
            ],
          ),
        ),
      );

  Widget campoCantidad() => InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.number,
                controller: myControllerCantidad,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )),
              Icon(
                Icons.add,
                color: Colors.black,
              )
            ],
          ),
        ),
      );

  Widget campoNombreProEst() => InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                  child: estilo
                      ? TextFormField(
                          controller: myControllerEstiloNone,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      : AutocompleteProductos()),
              estilo
                  ? Icon(
                      CupertinoIcons.scissors,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                    )
            ],
          ),
        ),
      );

  Widget btnAgregar() => InkWell(
        onTap: () {
          cont++;
          double resul = 0;
          String canti = '';

          double can;
          var precioPro;
          var precioProDble;
          estilo
              ? {
                  canti = "Serv.",
                  resul = double.tryParse(myControllerPrecio.text)!.toDouble(),
                }
              : {
                  canti = myControllerCantidad.text,
                  can = double.tryParse(canti)!.toDouble(),
                  canti = "$canti Pza",
                  if (can > 0)
                    {
                      precioPro = valorSelec.split("\$"),
                      precioProDble = double.tryParse(precioPro[0])!.toDouble(),
                      resul = can * precioProDble,
                      print("El resultado es $resul"),
                    }
                };
          var nombreAux = estilo ? myControllerEstiloNone.text : valorSelec;
          datosNuevos = RowCarrito(
              "$cont", nombreAux.toString(), canti, resul.toString());
          estado();

          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                  child: Text("Agregar",
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade600),
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
      );

  Widget btnCancelar() => InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
        child: Row(
          children: [
            Expanded(
                child: Text("Cancelar",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center)),
          ],
        ),
      ));
  limpiar() {
    myControllerPrecio.text = "";
    myControllerCantidad.text = "";
    myControllerEstiloNone.text = "";
    valorSelec = "";
    productList = [];
  }

  estado() {
    setState(() {
      productList.add(datosNuevos);
      if (productList.isNotEmpty) {
        valorLista = true;
        if (productList.length == 1) {
          productList.clear();
          productList.add(RowCarrito("", "Nombre", "Cant.", "Total"));
          productList.add(
            datosNuevos,
          );
        }
      } else {
        valorLista = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: listaBotones,
        floatingActionButton: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
                child: Row(
              children: [
                addProducto(),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                addEstilo()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )),
            valorLista ? btnConfirmarCompra() : Container(),
          ],
        )));

    //ElevatedButton(child: Icon(Icons.add), onPressed: () => estado()));
  }
}

class RowCarrito extends StatelessWidget {
  String idCarrito = "", nombre = "", cantidad = "", total = "";
  RowCarrito(this.idCarrito, this.nombre, this.cantidad, this.total, {Key? key})
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
        Expanded(flex: 4, child: textStyleEdit(nombre)),
        SizedBox(
          height: 8,
          width: 8,
        ),
        Expanded(flex: 2, child: textStyleEdit(cantidad)),
        SizedBox(
          height: 8,
          width: 8,
        ),
        Expanded(flex: 3, child: textStyleEdit(total)),
      ],
    );
  }
}

ProductoService productoService = ProductoService();

class AutocompleteProductos extends StatelessWidget {
  AutocompleteProductos({Key? key}) {
    getProductos();
  }

  void getProductos() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("productos");

    QuerySnapshot productoQS = await collectionReference.get();
    if (productoQS.docs.length != 0) {
      for (var doc in productoQS.docs) {
        String resultado = "";
        String datos = doc.data().toString(); //Datos del documento
        print(datos);
        datos = datos.substring(
            1, datos.length - 1); //quita los {} del dato del documento
        var datosDivi = datos.split(",");
        var cont = 0;
        for (var da in datosDivi) {
          //el dato esta dividio en 3
          if (cont == 0) {
            cont++; //El primer dato es el size y no se requiere se llama dsize(es por orden alfabetico)
          } else {
            print("valor completo del da " + da);
            var datos2 = da.split(":"); //Quiamos la key del valor
            print(datos2[1]);
            if (cont == 1) {
              cont++;
              resultado = datos2[1] + "\$".trim();
            } else {
              resultado += datos2[1];
            }
            resultado = resultado.trim();
            _kOptions.add(resultado);
          }
        }
      }
    }
  }

  List<String> _kOptions = [];
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        String a = myControllerCantidad.text = "1";
        valorSelec = selection;

        print('You just selected $selection+ $a');
      },
    );
  }
}
