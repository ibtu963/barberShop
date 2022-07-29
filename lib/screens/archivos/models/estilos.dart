import 'dart:io';

class Estilos {
  String idEstilo = '';
  String nombre = '';
  String precio = '';
  String descripcion = '';
  String imgUrl = '';
  String imgPath = "";
  File? imagen;

  static const String collectionId = 'estilos';
  Estilos(
      {required this.idEstilo,
      required this.nombre,
      required this.precio,
      required this.descripcion,
      required this.imgPath,
      required this.imgUrl,
      imagen});

  Estilos.fromSnapshot(String idEstilos, estilo)
      : idEstilo = idEstilos,
        nombre = estilo['nombre'],
        precio = estilo['precio'],
        descripcion = estilo['descripcion'],
        imgUrl = estilo['urlImg'],
        imgPath = estilo['imgPath'];
  // imagen = imagen;

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'urlImg': imgUrl,
        'imgPath': imgPath
      };

  @override
  String toString() {
    return 'estilo{idEstilo: $idEstilo, nombre: $nombre, precio: $precio, descripcion: $descripcion, urlImg:$imgUrl, imgPath: $imgPath}';
  }
}
