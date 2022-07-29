import 'dart:io';
import 'package:barber_shop/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/cupertino.dart';

final LocalAuthentication auth = LocalAuthentication();
String? contra;
String contraV = "CONTRA";
final myControllerTextContra = TextEditingController();

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool visibilityContra = false;
  bool visibilityBtnEnter = false;
  bool visibilityBtnIngresar = true;
  int contInto = 0;

  final formKey = GlobalKey<FormState>();

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "Contra") {
        visibilityContra = visibility;
      }
      if (field == "Enter") {
        visibilityBtnEnter = visibility;
      }
      if (field == "Ingresar") {
        visibilityBtnIngresar = visibility;
      }
    });
  }

  Future<void> _biometrico() async {
    bool flag = true;
    if (flag) {
      bool authenticated = false;
      const androidString = const AndroidAuthMessages(
        cancelButton: "Cancelar",
        goToSettingsButton: "Ajustes",
        signInTitle: "Autentificando",
        biometricHint: "Toque el sensor",
        biometricNotRecognized: "Huella no reconozida",
        biometricSuccess: "Bienvenido",
      );

      try {
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: "En verdad eres tu?",
            useErrorDialogs: true,
            stickyAuth: true,
            androidAuthStrings: androidString);
        if (!authenticated) {
          exit(0);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } catch (e) {
        print(e);
      }
      if (!mounted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildContra() => TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          controller: myControllerTextContra,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.length < 4) {
              return 'Ingresa al menos 3 carácteres';
            } else {
              contra = value;
              return null;
            }
          },
          maxLength: 30,
        );

    Widget buildSubmit() => Builder(
          builder: (context) => ButtonWidget(
            text: 'Entrar',
            onClicked: () {
              if (contInto > 2) {
                final snackBar = SnackBar(
                  content: Text(
                    "Te equivocaste mucho...",
                    style: TextStyle(fontSize: 20),
                  ),
                  backgroundColor: Colors.black,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _changed(false, "Contra");
                _changed(false, "Ingresar");
                _changed(false, "Enter");
              }
              final isValid = formKey.currentState!.validate();
              if (isValid) {
                formKey.currentState!.save();
              }
              contra = myControllerTextContra.text;
              if (contraV == contra) {
                final snackBar = SnackBar(
                  content: Text(
                    "Bienvenido",
                    style: TextStyle(fontSize: 20),
                  ),
                  backgroundColor: Colors.black,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              } else {
                contInto = contInto + 1;
                int mos = 4 - contInto;
                myControllerTextContra.clear();
                final snackBar = SnackBar(
                  content: Text(
                    "Contraseña incorrecta, aún tienes $mos",
                    style: TextStyle(fontSize: 15),
                  ),
                  backgroundColor: Colors.black,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // formKey.currentState!.save();
            },
          ),
        );

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: primaryBlack,
          primaryColor: Color(0xff37474f),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Ingresa sesion"),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(1),
              children: [
                Center(
                  child: Image.asset(
                    "assets/splash.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                visibilityContra
                    ? new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            //  height: 10,
                            width: 10,
                          ),
                          new Expanded(
                            child: buildContra(),
                            flex: 11,
                          ),
                          SizedBox(
                            //height: 20,
                            width: 20,
                          )
                        ],
                      )
                    : new Container(),
                visibilityBtnEnter
                    ? Center(
                        child: buildSubmit(),
                      )
                    : Container(),
                visibilityBtnIngresar
                    ? ElevatedButton(
                        child: Text("Ingresa tu contraseña"),
                        onPressed: () {
                          _changed(true, "Contra");
                          _changed(false, "Ingresar");
                          _changed(true, "Enter");
                        },
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.black,
                        width: 5,
                        height: 5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 1,
                        height: 1,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.black,
                        width: 5,
                        height: 5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 1,
                        height: 1,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.black,
                        width: 5,
                        height: 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                Center(
                  child: Text(
                    "Ingresa con tu huella",
                    style: TextStyle(fontSize: 16, fontFamily: "Consolas"),
                  ),
                ),
                IconButton(
                    iconSize: 60,
                    onPressed: () {
                      _biometrico();
                    },
                    icon: Icon(
                      Icons.fingerprint,
                      size: 60,
                    ))
              ],
            ),
          ),
        ));
  }
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}
