import 'package:barber_shop/screens/archivos/models/productos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoService {
  CollectionReference usuariosRef =
      FirebaseFirestore.instance.collection(Productos.collectionId);

  Future<void> create(Productos producto) async {
    await usuariosRef.add(producto.toMap());
  }

  Future<void> update(String path, Productos producto) async {
    await usuariosRef
        .doc(path)
        .update({
          'nombre': producto.nombre,
          'precio': producto.precio,
          'descripcion': producto.size
        })
        .then((_) => print('datos Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  borrar(String path) {
    usuariosRef.doc(path).delete().whenComplete(() => print("borrar Completo"));
  }

  Future<Productos?> getById(String uid) async {
    Productos? producto;
    DocumentSnapshot documentSnapshot = await usuariosRef.doc(uid).get();
    if (documentSnapshot.exists) {
      producto =
          Productos.fromSnapshot(documentSnapshot.id, documentSnapshot.data());
    }
    return producto;
  }

  Future<List<Productos>> get() async {
    QuerySnapshot querySnapshot = await usuariosRef.get();
    return querySnapshot.docs
        .map((ds) => Productos.fromSnapshot(ds.id, ds.data()))
        .toList();
  }

  Stream<List<Productos>> getByNombres(String nombres) {
    return usuariosRef.where('nombre', isEqualTo: nombres).snapshots().map(
        (e) => e.docs
            .map((ds) => Productos.fromSnapshot(ds.id, ds.data()))
            .toList());
  }
}
