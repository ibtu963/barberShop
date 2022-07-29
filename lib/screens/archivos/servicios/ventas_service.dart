import 'package:barber_shop/screens/archivos/models/ventas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentasService {
  CollectionReference ventassRef =
      FirebaseFirestore.instance.collection(VentasModel.collectionId);

  Future<void> create(VentasModel venta) async {
    await ventassRef.add(venta.toMap());
  }

  borrar(String path) {
    ventassRef.doc(path).delete().whenComplete(() => print("borrar Completo"));
  }

  Future<VentasModel?> getById(String uid) async {
    VentasModel? producto;
    DocumentSnapshot documentSnapshot = await ventassRef.doc(uid).get();
    if (documentSnapshot.exists) {
      producto = VentasModel.fromSnapshot(
          documentSnapshot.id, documentSnapshot.data());
    }
    return producto;
  }

  Future<List<VentasModel>> get() async {
    QuerySnapshot querySnapshot = await ventassRef.get();
    return querySnapshot.docs
        .map((ds) => VentasModel.fromSnapshot(ds.id, ds.data()))
        .toList();
  }

  Stream<List<VentasModel>> getByNombres(String nombres) {
    return ventassRef.where('nombre', isEqualTo: nombres).snapshots().map((e) =>
        e.docs
            .map((ds) => VentasModel.fromSnapshot(ds.id, ds.data()))
            .toList());
  }

  int lengthList() {
    List po = [get()];
    po.length;
    return po.length;
  }
}
