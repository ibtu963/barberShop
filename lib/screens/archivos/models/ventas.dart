class VentasModel {
  String idVenta;
  String idCarrito;
  String fecha;
  String total;
//En los String hay nombres raros porque se ordena de forma alfabertica
//el orden que se da con estos nombres nos beneficia en el trabajo
  static const String collectionId = 'ventas';
  VentasModel({
    required this.idVenta,
    required this.idCarrito,
    required this.fecha,
    required this.total,
  });

  VentasModel.fromSnapshot(String idNewVenta, venta)
      : idVenta = idNewVenta,
        idCarrito = venta['idCarrito'],
        fecha = venta['fecha'],
        total = venta['total'];

  Map<String, dynamic> toMap() => {
        'idVenta': idVenta,
        'idCarrito': idCarrito,
        'fecha': fecha,
        'total': total,
      };

  @override
  String toString() {
    return 'venta{idVenta: $idVenta, idCarrito: $idCarrito, total: $total, fecha: $fecha}';
  }
}
