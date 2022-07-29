import 'dart:async';
import 'package:flutter/material.dart';
import '../button_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:barber_shop/screens/archivos/models/estilos.dart';
import 'package:barber_shop/screens/archivos/servicios/estilos_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_shop/screens/home.dart';

class AddEstilos extends StatefulWidget {
  AddEstilos() {
    imagen = null;
    editando = false;
  }
  @override
  _addEstilosState createState() => _addEstilosState();
  editar(String id1, String nombre, String desc, String urlI, String pathimg) {
    nameEstilo = nombre;
    descripcion = desc;
    urlImg = urlI;
    id = id1;
    editando = true;
    pathImg = pathimg;
  }
}

String nameEstilo = '';
String descripcion = '';
String id = '';
String urlImg = "";
String pathImg = "";
File? imagen;
bool editando = false;

final picker = ImagePicker();

class _addEstilosState extends State<AddEstilos> {
  final formKey = GlobalKey<FormState>();

  Future setImagen(op) async {
    var pickerFile;
    if (op == 1) {
      pickerFile = await picker.getImage(source: ImageSource.camera);
    } else {
      // ignore: deprecated_member_use
      pickerFile = await picker.getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickerFile != null) {
        imagen = File(pickerFile.path);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: editando ? Text("Editando... ") : Text("Registrando... "),
        ),
        body: Form(
          key: formKey,
          child: ListView(padding: EdgeInsets.all(20), children: [
            buildNameEstilo(),
            const SizedBox(height: 16),
            buildDescripcion(),
            const SizedBox(height: 16),
            buildImage(),
            imagen == null
                ? Center()
                : Image.file(
                    imagen!,
                    semanticLabel:
                        "La resolucion es del tamaño de la foto real",
                  ),
            editando
                ? Image.network(
                    urlImg,
                  )
                : new Container(),
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

  Widget buildImage() => ElevatedButton(
      onPressed: () {
        opcionImagen(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
      child: Text(
        "Selecciona una imagen",
        style: TextStyle(color: Colors.grey.shade300),
      ));

  Widget buildNameEstilo() => TextFormField(
        initialValue: editando ? nameEstilo : null,
        decoration: InputDecoration(
          labelText: 'Nombre del estilo',
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
        onSaved: (value) => setState(() => nameEstilo = value!),
      );

  opcionImagen(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setImagen(1);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey.shade300))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Tomar una foto",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center)),
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setImagen(2);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey.shade300))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Seleccionar una foto",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center)),
                          Icon(
                            Icons.photo_camera_back_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey.shade300))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Cancelar",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red),
                                  textAlign: TextAlign.center)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildDescripcion() => TextFormField(
        initialValue: editando ? descripcion : null,
        decoration: InputDecoration(
          labelText: 'Breve descripcion',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 1) {
            return 'Ingresa al menos 1 número';
          } else {
            return null;
          }
        },
        maxLength: 300,
        onSaved: (value) => setState(() => descripcion = value!),
      );

  Widget builBtnRegistrar() => Builder(
        builder: (context) => ButtonWidget(
          text: 'Guardar',
          onClicked: () async {
            final isValid = formKey.currentState!.validate();

            if (isValid) {
              formKey.currentState!.save();
              EstiloService estiloService = EstiloService();
              FirebaseFirestore.instance.collection("estilos").snapshots();
              if (imagen != null) {
                var r;
                editando
                    ? {}
                    : {
                        r = await estiloService.uploadFile(imagen!),
                        urlImg = r.toString(),
                        print("editando guardar" + urlImg),
                        pathImg = await estiloService.getImgPath()
                      };
              }
              String message = '';
              try {
                Estilos estilo = Estilos(
                    descripcion: descripcion,
                    nombre: nameEstilo,
                    precio: "Costo dado por el estilista",
                    idEstilo: editando ? id : "",
                    imgUrl: urlImg,
                    imgPath: pathImg);

                editando
                    ? await estiloService.update(estilo)
                    : await estiloService.create(estilo);

                message = 'Estilo guardado correctamente';
              } catch (e) {
                message = 'Ocurrió un error';
              } finally {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  duration: Duration(seconds: 2),
                ));
              }
            }
            Timer(
              Duration(seconds: 1),
              salir,
            );
          },
        ),
      );

  Widget btnBorrar() => Builder(
      builder: (context) => ButtonWidget(
            text: 'Borrar',
            onClicked: () async {
              String resul = "";
              _showAlertDialog();
            },
          ));
  _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Borrando"),
            content: Text("Borrar $nameEstilo?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Borrar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  EstiloService estiloService = EstiloService();
                  estiloService.borrar(id, pathImg);
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

  salir() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      ModalRoute.withName('/'));
}
