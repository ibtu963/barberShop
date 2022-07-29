import 'package:barber_shop/screens/archivos/models/estilos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

String url = '';
String pathImg = '';

class EstiloService {
  CollectionReference estiloRef =
      FirebaseFirestore.instance.collection(Estilos.collectionId);

  Future<void> create(Estilos estilo) async {
    estilo.imgUrl = url;
    await estiloRef.add(estilo.toMap());
  }

  Future<void> update(Estilos estilo) async {
    await estiloRef
        .doc(estilo.idEstilo)
        .update({
          'nombre': estilo.nombre,
          'precio': estilo.precio,
          'descripcion': estilo.descripcion,
          'urlImg': estilo.imgUrl,
          'imgPath': estilo.imgPath
        })
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  borrar(String path, imgpath) {
    print("$imgpath");
    deleteImage(imgpath);
    estiloRef.doc(path).delete().whenComplete(() => print("borrar Completo"));
  }

  Future<void> deleteImage(String imgp) async {
    final ref = FirebaseStorage.instance.ref().child(imgp);
    // Create a reference to the file to delete

    ref.delete().whenComplete(() => print("Borro img"));
  }

  Future<String> uploadFile(imagen) async {
    try {
      String nombreImagen = Uuid().v1();
      var imagePath = "/imagen/$nombreImagen.jpg";
      pathImg = imagePath;
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = ref.putFile(imagen);
      dynamic downUrl =
          await uploadTask.then((doc) => doc.ref.getDownloadURL());
      url = downUrl.toString();
    } on FirebaseException catch (e) {
      print("UploadImagen $e");
    }
    return url;
  }

  getImgPath() {
    //Estilos estilo) {
    return //estilo.
        pathImg;
  }

  Future<List<Estilos>> get() async {
    QuerySnapshot querySnapshot = await estiloRef.get();
    return querySnapshot.docs
        .map((ds) => Estilos.fromSnapshot(ds.id, ds.data()))
        .toList();
  }
}
