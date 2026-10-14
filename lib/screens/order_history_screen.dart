import 'package:flutter/material.dart';
import '../data/cart_state.dart';
import '../models/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int initialTab;

  const OrderHistoryScreen({super.key, this.initialTab = 0});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final CartState _cartState = CartState();
  late int _selectedTab;

  static const primaryColor = Color(0xFF0F4C3A);
  static const accentColor = Color(0xFFE05A47);

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF162A20),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _cartState,
        builder: (context, _) {
          final allOrders = _cartState.orderHistory;
          final activeOrders = allOrders
              .where((o) => o.status != OrderStatus.selesai)
              .toList();
          final completedOrders = allOrders
              .where((o) => o.status == OrderStatus.selesai)
              .toList();

          return Column(
            children: [
              // Widget 1: SegmentedButton untuk Switcher Tab
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: [
                      ButtonSegment(
                        value: 0,
                        label: Text('Pesanan Berjalan (${activeOrders.length})'),
                        icon: const Icon(Icons.timer_outlined, size: 16),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Selesai (${completedOrders.length})'),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                      ),
                    ],
                    selected: {_selectedTab},
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return primaryColor;
                        }
                        return Colors.white;
                      }),
                      foregroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return const Color(0xFF162A20);
                      }),
                    ),
                    onSelectionChanged: (newSelection) {
                      setState(() => _selectedTab = newSelection.first);
                    },
                  ),
                ),
              ),

              // Widget 2: RefreshIndicator & Daftar Pesanan
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: primaryColor,
                  child: _selectedTab == 0
                      ? _buildOrdersList(activeOrders, isActive: true)
                      : _buildOrdersList(completedOrders, isActive: false),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE6DC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isActive
                          ? Icons.soup_kitchen_outlined
                          : Icons.receipt_long_outlined,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isActive
                        ? 'Belum ada pesanan aktif'
                        : 'Belum ada riwayat pesanan',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive
                        ? 'Pesanan yang Anda buat akan langsung dipantau di sini.'
                        : 'Semua pesanan yang telah rampung akan tersimpan rapi.',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Widget 3: ListView.separated
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, isActive);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? primaryColor : const Color(0xFFE2DDD2),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header ID Pesanan & Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.orderId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${order.orderTime.hour.toString().padLeft(2, '0')}:${order.orderTime.minute.toString().padLeft(2, '0')} WIB',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
              // Widget 4: Chip status
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order.status == OrderStatus.selesai
                      ? Colors.green.withValues(alpha: 0.12)
                      : accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: order.status == OrderStatus.selesai
                        ? Colors.green.shade800
                        : accentColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Widget 5: Custom Horizontal Timeline / Tracker untuk Pesanan Berjalan
          if (isActive) ...[
            _buildTimelineTracker(order.status),
            const SizedBox(height: 14),
          ],

          // Widget 6: ExpansionTile Rincian Menu
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 6),
              title: Text(
                '${order.items.length} Menu • ${CartState.formatRupiah(order.totalAmount)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF162A20),
                ),
              ),
              subtitle: Text(
                '${order.diningOption} • ${order.paymentMethod}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              children: order.items.map((it) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${it.quantity}x ${it.menu.name}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade800),
                      ),
                      Text(
                        CartState.formatRupiah(it.itemTotal),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 12),

          // Widget 7: Tombol Aksi Interaktif
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (order.tableNumber != '-')
                Text(
                  'Meja: ${order.tableNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                )
              else
                const Text('Bungkus', style: TextStyle(fontSize: 11)),
              if (isActive)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (order.status == OrderStatus.diproses) {
                        order.status = OrderStatus.siapAmbil;
                      } else {
                        order.status = OrderStatus.selesai;
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Status ${order.orderId} sekarang: ${order.statusLabel}'),
                        backgroundColor: primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    order.status == OrderStatus.diproses
                        ? 'Simulasikan Siap'
                        : 'Selesaikan Pesanan',
                    style: const TextStyle(fontSize: 11),
                  ),
                )
              else
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                  ),
                  icon: const Icon(Icons.replay_rounded, size: 14),
                  label: const Text('Pesan Lagi', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    for (final it in order.items) {
                      _cartState.addToCart(it);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu telah dimasukkan ke keranjang'),
                        backgroundColor: primaryColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Visual Horizontal Timeline Tracker
  Widget _buildTimelineTracker(OrderStatus status) {
    final isStep2Active = status == OrderStatus.siapAmbil;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildStepCircle(Icons.check, true, 'Diterima'),
          Expanded(
            child: Container(
              height: 2,
              color: primaryColor,
            ),
          ),
          _buildStepCircle(
            Icons.soup_kitchen_rounded,
            true,
            'Dimasak',
          ),
          Expanded(
            child: Container(
              height: 2,
              color: isStep2Active ? primaryColor : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle(
            Icons.notifications_active_rounded,
            isStep2Active,
            'Siap Ambil',
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(IconData icon, bool active, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12, color: Colors.white),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? primaryColor : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
