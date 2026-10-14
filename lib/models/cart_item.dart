import 'menu_item.dart';

class CartItem {
  final String id;
  final MenuItem menu;
  int quantity;
  String spicyLevel;
  List<String> toppings;
  String notes;

  CartItem({
    required this.id,
    required this.menu,
    this.quantity = 1,
    this.spicyLevel = 'Sedang',
    this.toppings = const [],
    this.notes = '',
  });

  // Biaya tambahan per topping Rp 2.000
  int get toppingCost => toppings.length * 2000;

  // Total harga per item pesanan (termasuk topping dikali kuantitas)
  int get itemTotal => (menu.price + toppingCost) * quantity;
}
