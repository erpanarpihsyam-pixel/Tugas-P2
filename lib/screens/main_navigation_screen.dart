import 'package:flutter/material.dart';
import '../data/cart_state.dart';
import '../models/order_model.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final CartState _cartState = CartState();

  final List<Widget> _screens = const [
    HomeScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F4C3A);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Tombol Keranjang mengambang dengan pill badge elegan
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ListenableBuilder(
        listenable: _cartState,
        builder: (context, _) {
          final count = _cartState.totalCartCount;
          if (count == 0 || _currentIndex != 0) return const SizedBox.shrink();

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE05A47),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE05A47).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$count Item',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 14,
                    width: 1,
                    color: Colors.white38,
                  ),
                  Text(
                    CartState.formatRupiah(_cartState.subtotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Bottom Bar bernuansa bistro modern
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.storefront_outlined,
                  activeIcon: Icons.storefront_rounded,
                  label: 'Katalog',
                  primaryColor: primaryColor,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: 'Pesanan',
                  primaryColor: primaryColor,
                  showBadge: true,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profil',
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color primaryColor,
    bool showBadge = false,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (showBadge)
              ListenableBuilder(
                listenable: _cartState,
                builder: (context, _) {
                  final activeOrders = _cartState.orderHistory
                      .where((o) => o.status != OrderStatus.selesai)
                      .length;
                  return Badge(
                    isLabelVisible: activeOrders > 0,
                    label: Text('$activeOrders'),
                    backgroundColor: const Color(0xFFE05A47),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      color: isSelected ? primaryColor : Colors.grey.shade600,
                      size: 22,
                    ),
                  );
                },
              )
            else
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? primaryColor : Colors.grey.shade600,
                size: 22,
              ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
