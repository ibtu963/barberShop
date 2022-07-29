import 'package:barber_shop/screens/archivos/productos/add_productos.dart';
import 'package:barber_shop/screens/archivos/models/productos.dart';
import 'package:barber_shop/screens//archivos/servicios/producto_service.dart';
import 'package:flutter/material.dart';

bool activo = false;

class editProductos extends StatelessWidget {
  ProductoService productoService = ProductoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Center(
        child: FutureBuilder<List<Productos>>(
          future: productoService.get(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Productos>> snapshot) {
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
                final productos = snapshot.data;
                return ListView.builder(
                  itemCount: productos!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        productos[index].nombre,
                        style: TextStyle(fontSize: 23, fontFamily: "Consolas"),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        String id = productos[index].idProducto;
                        String nom = productos[index].nombre;
                        String desc = productos[index].size;
                        String precio = productos[index].precio;
                        var num = [];
                        num = desc.split("-");
                        addProductos ad = addProductos();
                        ad.productoEditar(id, nom, precio, num[0]);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ad));
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
