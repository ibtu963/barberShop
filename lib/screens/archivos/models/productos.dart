class Productos {
  String idProducto;
  String nombre;
  String precio;
  String size;
//En los String hay nombres raros porque se ordena de forma alfabertica
//el orden que se da con estos nombres nos beneficia en el trabajo
  static const String collectionId = 'productos';
  Productos(
      {required this.idProducto,
      required this.nombre,
      required this.precio,
      required this.size});

  Productos.fromSnapshot(String idProductos, producto)
      : idProducto = idProductos,
        nombre = producto['enombre'],
        precio = producto['cprecio'],
        size = producto['dsize'];

  Map<String, dynamic> toMap() =>
      {'enombre': nombre, 'cprecio': precio, 'dsize': size};

  @override
  String toString() {
    return 'producto{idProducto: $idProducto, enombre: $nombre, cprecio: $precio, dsize: $size}';
  }
}
