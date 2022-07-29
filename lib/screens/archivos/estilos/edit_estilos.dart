import 'package:barber_shop/screens/archivos/estilos/add_estilos.dart';
import 'package:barber_shop/screens/archivos/models/estilos.dart';
import 'package:barber_shop/screens//archivos/servicios/estilos_service.dart';
import 'package:flutter/material.dart';

class editEstilos extends StatelessWidget {
  EstiloService estiloService = EstiloService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Center(
        child: FutureBuilder<List<Estilos>>(
          future: estiloService.get(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Estilos>> snapshot) {
            if (snapshot.hasError) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ]);
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Esperando resultados...'),
                      )
                    ]);
              default:
                final estilos = snapshot.data;
                return ListView.builder(
                  itemCount: estilos!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        estilos[index].nombre,
                        style: TextStyle(fontSize: 23, fontFamily: "Consolas"),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        String id = estilos[index].idEstilo;
                        String nom = estilos[index].nombre;
                        String desc = estilos[index].descripcion;
                        String img = estilos[index].imgUrl;
                        String imgPa = estilos[index].imgPath;
                        print("Aqui va la url " + img);
                        AddEstilos adE = AddEstilos();
                        adE.editar(id, nom, desc, img, imgPa);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => adE));
                      },
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
