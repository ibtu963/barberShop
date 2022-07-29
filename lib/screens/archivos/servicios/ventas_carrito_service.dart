import 'package:barber_shop/screens/archivos/models/ventas_carrito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentasCarritoService {
  CollectionReference ventasCarritoRef =
      FirebaseFirestore.instance.collection(VentasCarritos.collectionId);

  Future<void> create(VentasCarritos venta) async {
    await ventasCarritoRef.add(venta.toMap());
  }

  borrar(String path) {
    ventasCarritoRef
        .doc(path)
        .delete()
        .whenComplete(() => print("borrar Completo"));
  }

  Future<List<VentasCarritos>> get() async {
    QuerySnapshot querySnapshot = await ventasCarritoRef.get();
    return querySnapshot.docs
        .map((ds) => VentasCarritos.fromSnapshot(ds.id, ds.data()))
        .toList();
  }

  Stream<List<VentasCarritos>> getByNombres(String nombres) {
    return ventasCarritoRef.where('nombre', isEqualTo: nombres).snapshots().map(
        (e) => e.docs
            .map((ds) => VentasCarritos.fromSnapshot(ds.id, ds.data()))
            .toList());
  }
}
