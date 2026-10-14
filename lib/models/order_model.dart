import 'cart_item.dart';

enum OrderStatus {
  diproses,
  siapAmbil,
  selesai,
}

class OrderModel {
  final String orderId;
  final DateTime orderTime;
  final List<CartItem> items;
  final int totalAmount;
  final String diningOption; // 'Makan di Tempat' atau 'Bungkus'
  final String paymentMethod; // 'Tunai di Kasir', 'QRIS', dll.
  final String tableNumber; // Nomor Meja jika dine-in
  OrderStatus status;

  OrderModel({
    required this.orderId,
    required this.orderTime,
    required this.items,
    required this.totalAmount,
    required this.diningOption,
    required this.paymentMethod,
    required this.tableNumber,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.diproses:
        return 'Sedang Dimasak';
      case OrderStatus.siapAmbil:
        return 'Siap Diambil';
      case OrderStatus.selesai:
        return 'Selesai';
    }
  }
}
