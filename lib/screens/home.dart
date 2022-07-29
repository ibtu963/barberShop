import 'package:barber_shop/screens/agenda.dart';
import 'package:barber_shop/screens/archivos.dart';
import 'package:barber_shop/screens/ventas/vender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:barber_shop/screens/configuracion/config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    agenda(),
    Vender(),
    archivos(),
    config(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:
            const Center(child: Text('OliBarber', textAlign: TextAlign.center)),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        fixedColor: Colors.blue.shade900,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar), label: 'Ventas'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder),
            label: 'Archivos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuraciones',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
