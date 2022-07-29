class VentasCarritos {
  String idCarrito;
  String nombre;
  String cantidad;
  String total;
//En los String hay nombres raros porque se ordena de forma alfabertica
//el orden que se da con estos nombres nos beneficia en el trabajo
  static const String collectionId = 'ventasCarrito';
  VentasCarritos({
    required this.idCarrito,
    required this.nombre,
    required this.cantidad,
    required this.total,
  });

  VentasCarritos.fromSnapshot(String idNewVenta, venta)
      : idCarrito = venta['idCarrito'],
        nombre = venta['nombre'],
        cantidad = venta['Cantidad'],
        total = venta['total'];

  Map<String, dynamic> toMap() => {
        'idCarrito': idCarrito,
        'nombre': nombre,
        'cantidad': nombre,
        'total': total,
      };

  @override
  String toString() {
    return 'venta{idCarrito: $idCarrito, nombre: $nombre, cantidad: $cantidad, total: $total,}';
  }
}
