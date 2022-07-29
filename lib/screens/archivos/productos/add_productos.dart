import 'dart:async';
import 'package:barber_shop/screens/archivos/models/productos.dart';
import 'package:barber_shop/screens/archivos/servicios/producto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../button_widget.dart';
import 'package:barber_shop/screens/home.dart';

String id = "";
String nombreEd = "";
String precioEd = "";
String sizeProducto = "";
bool editando = false;
Productos? productoEditando;

class addProductos extends StatefulWidget {
  addProductos() {
    editando = false;
  }
  @override
  _addProductosState createState() => _addProductosState();

  productoEditar(String id1, String nom, String precio1, String desc) {
    editando = true;
    id = id1;
    nombreEd = nom;
    precioEd = precio1;
    sizeProducto = desc;
  }
}

class _addProductosState extends State<addProductos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductos();
  }

  List nombresProducto = [];

  void getProductos() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("productos");

    QuerySnapshot productoQS = await collectionReference.get();
    if (productoQS.docs.length != 0) {
      for (var doc in productoQS.docs) {
        String resultado = "";
        String datos = doc.data().toString(); //Datos del documento
        datos = datos.substring(
            1, datos.length - 1); //quita los {} del dato del documento
        var datosDivi = datos.split(",");
        var cont = 0;
        for (var da in datosDivi) {
          //el dato esta dividio en 3
          if (cont == 0) {
            cont++; //No se ocupa)
          } else {
            var datos2 = da.split(":"); //Quiamos la key del valor
            if (cont == 1) {
              cont++;
            } else {
              resultado = datos2[1];
              resultado = resultado.trim();
              nombresProducto.add(resultado);

              print(resultado);
            }
          }
        }
      }
    }
  }

  @override
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: editando ? Text("Editando... ") : Text("Registrando... "),
        ),
        body: Form(
          key: formKey,
          child: ListView(padding: EdgeInsets.all(20), children: [
            buildNameProductos(),
            const SizedBox(height: 16),
            buildPrecio(),
            const SizedBox(height: 16),
            buildTipoProducto(),
            const SizedBox(height: 16),
            editando
                ? Center(
                    child: Row(children: [
                    builBtnRegistrar(),
                    SizedBox(height: 10, width: 10),
                    btnBorrar()
                  ]))
                : builBtnRegistrar()
          ]),
        ),
      );

  _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Borrando"),
            content: Text("Borrar $nombreEd?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Borrar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  ProductoService productoService = ProductoService();
                  productoService.borrar(id);
                  Timer(const Duration(seconds: 1), salir);
                },
              ),
              RaisedButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget btnBorrar() => Builder(
      builder: (context) => ButtonWidget(
            text: 'Borrar',
            onClicked: () async {
              String resul = "";
              _showAlertDialog();
            },
          ));

  Widget buildTipoProducto() => TextFormField(
      initialValue: editando ? sizeProducto : null,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Tamaño',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.length < 1) {
          return 'Ingresa al menos 1 número';
        } else {
          return null;
        }
      },
      maxLength: 10,
      onSaved: (value) {
        setState(() {
          sizeProducto = value!;
          if (int.parse(sizeProducto) > 10) {
            sizeProducto = sizeProducto + ' - Mml o Grms';
          } else {
            sizeProducto = sizeProducto + ' - Lts o Kilos';
          }
        });
      });

  Widget buildNameProductos() => TextFormField(
        initialValue: editando ? nombreEd : null,
        decoration: InputDecoration(
          labelText: 'Nombre del producto',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 4) {
            return 'Ingresa al menos 3 carácteres';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => nombreEd = value!),
      );

  Widget buildPrecio() => TextFormField(
        initialValue: editando ? precioEd : null,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Precio',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 1) {
            return 'Ingresa al menos 1 número';
          } else {
            return null;
          }
        },
        maxLength: 10,
        onSaved: (value) => setState(() => precioEd = value!),
      );

  nombreValido(String nombre5) {
    int kk = 0;
    for (var a in nombresProducto) {
      if (nombresProducto[kk] == nombre5) return false;
    }
    return true;
  }

  Widget builBtnRegistrar() => Builder(
        builder: (context) => ButtonWidget(
          text: 'Guardar',
          onClicked: () async {
            final isValid = formKey.currentState!.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              formKey.currentState!.save();
              ProductoService productoService = ProductoService();

              String message = '';
              try {
                //FirebaseFirestore.instance.collection("productos").snapshots();
                bool nombreNoExiste = nombreValido(nombreEd);
                if (nombreNoExiste) {}
                Productos producto = Productos(
                    nombre: nombreEd,
                    precio: precioEd,
                    size: sizeProducto,
                    idProducto: editando ? id : '');
                editando
                    ? {
                        await productoService.update(id, producto),
                        message = 'Producto guardado correctamente'
                      }
                    : {
                        if (nombreNoExiste)
                          {
                            await productoService.create(producto),
                            message = 'Producto guardado correctamente',
                          }
                        else
                          {
                            message = 'El nombre ya existe',
                          }
                      };
              } catch (e) {
                //  message = 'Ocurrió un error';
              } finally {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 2),
                ));
              }
              if (nombreValido(nombreEd)) {
                Timer(
                  Duration(seconds: 1),
                  salir,
                );
              }
            }
          },
        ),
      );

  salir() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      ModalRoute.withName('/'));
}
