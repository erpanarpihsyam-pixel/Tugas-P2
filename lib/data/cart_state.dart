import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/order_model.dart';
import 'dummy_data.dart';

class CartState extends ChangeNotifier {
  // Singleton pattern agar state keranjang dapat diakses konsisten antar layar
  static final CartState _instance = CartState._internal();
  factory CartState() => _instance;
  CartState._internal() {
    _initSampleOrders();
  }

  final List<CartItem> _cartItems = [];
  final List<OrderModel> _orderHistory = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<OrderModel> get orderHistory => List.unmodifiable(_orderHistory);

  // Total jumlah item di keranjang untuk badge ikon
  int get totalCartCount {
    int count = 0;
    for (final item in _cartItems) {
      count += item.quantity;
    }
    return count;
  }

  // Total biaya belanja di keranjang
  int get subtotal {
    int total = 0;
    for (final item in _cartItems) {
      total += item.itemTotal;
    }
    return total;
  }

  // Tambah item ke keranjang
  void addToCart(CartItem newItem) {
    // Cek apakah item yang sama persis (menu id, level pedas, topping) sudah ada
    final existingIndex = _cartItems.indexWhere((item) =>
        item.menu.id == newItem.menu.id &&
        item.spicyLevel == newItem.spicyLevel &&
        item.toppings.join(',') == newItem.toppings.join(','));

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += newItem.quantity;
    } else {
      _cartItems.add(newItem);
    }
    notifyListeners();
  }

  // Tambah cepat dari halaman beranda
  void quickAddToCart(MenuItem menu) {
    addToCart(
      CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        menu: menu,
        quantity: 1,
        spicyLevel: 'Sedang',
        toppings: const [],
        notes: '',
      ),
    );
  }

  // Update kuantitas item
  void updateQuantity(String id, int delta) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final newQty = _cartItems[index].quantity + delta;
      if (newQty <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  // Hapus item dari keranjang
  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Kosongkan keranjang
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Checkout pesanan baru
  OrderModel checkout({
    required String diningOption,
    required String paymentMethod,
    required String tableNumber,
  }) {
    final newOrder = OrderModel(
      orderId: 'KBS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      orderTime: DateTime.now(),
      items: List.from(_cartItems),
      totalAmount: subtotal,
      diningOption: diningOption,
      paymentMethod: paymentMethod,
      tableNumber: tableNumber.isEmpty ? '-' : tableNumber,
      status: OrderStatus.diproses,
    );

    _orderHistory.insert(0, newOrder);
    _cartItems.clear();
    notifyListeners();
    return newOrder;
  }

  // Format angka ke format mata uang Rupiah (contoh: 15000 -> "Rp 15.000")
  static String formatRupiah(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  // Data contoh riwayat pesanan awal untuk simulasi interaksi
  void _initSampleOrders() {
    _orderHistory.addAll([
      OrderModel(
        orderId: 'KBS-82914',
        orderTime: DateTime.now().subtract(const Duration(minutes: 12)),
        items: [
          CartItem(
            id: 'demo-1',
            menu: DummyData.menuList[0], // Ayam Geprek
            quantity: 1,
            spicyLevel: 'Pedas Mantap',
            toppings: ['Kerupuk Gurih'],
            notes: 'Sambalnya jangan terlalu asin ya bu',
          ),
          CartItem(
            id: 'demo-2',
            menu: DummyData.menuList[5], // Es Teh Manis Jumbo
            quantity: 1,
            spicyLevel: 'Biasa',
            toppings: const [],
            notes: 'Es batunya banyakin',
          ),
        ],
        totalAmount: 21000,
        diningOption: 'Makan di Tempat',
        paymentMethod: 'QRIS / GoPay',
        tableNumber: 'Meja 08',
        status: OrderStatus.diproses,
      ),
      OrderModel(
        orderId: 'KBS-71042',
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        items: [
          CartItem(
            id: 'demo-3',
            menu: DummyData.menuList[1], // Nasi Goreng Spesial
            quantity: 1,
            spicyLevel: 'Sedang',
            toppings: const [],
            notes: '',
          ),
          CartItem(
            id: 'demo-4',
            menu: DummyData.menuList[8], // Tempe Mendoan
            quantity: 1,
            spicyLevel: 'Biasa',
            toppings: const [],
            notes: '',
          ),
        ],
        totalAmount: 20000,
        diningOption: 'Bungkus (Take Away)',
        paymentMethod: 'Tunai di Kasir',
        tableNumber: '-',
        status: OrderStatus.selesai,
      ),
    ]);
  }
}
