import 'package:flutter/material.dart';
import '../data/cart_state.dart';
import 'order_history_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartState _cartState = CartState();
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _voucherController = TextEditingController();

  String _diningOption = 'Makan di Tempat';
  String _paymentMethod = 'QRIS';
  bool _needCutlery = true;
  bool _voucherApplied = false;

  static const primaryColor = Color(0xFF0F4C3A);
  static const accentColor = Color(0xFFE05A47);

  @override
  void dispose() {
    _tableNumberController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  int get _discountAmount => _voucherApplied ? 3000 : 0;
  int get _finalTotal {
    final subtotal = _cartState.subtotal;
    return (subtotal - _discountAmount).clamp(0, subtotal);
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim().toUpperCase();
    if (code == 'HEMAT10') {
      setState(() => _voucherApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher HEMAT10 berhasil digunakan! Potongan Rp 3.000'),
          backgroundColor: primaryColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid. Coba masukkan: HEMAT10'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _processCheckout() {
    if (_cartState.cartItems.isEmpty) return;

    if (_diningOption == 'Makan di Tempat' &&
        _tableNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi nomor meja Anda!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newOrder = _cartState.checkout(
      diningOption: _diningOption,
      paymentMethod: _paymentMethod,
      tableNumber: _tableNumberController.text.trim(),
    );

    // Struk Digital Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_rounded,
                  color: primaryColor, size: 40),
            ),
            const SizedBox(height: 12),
            const Text(
              'Struk Pemesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF162A20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              newOrder.orderId,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const Divider(height: 24),
            _buildReceiptRow('Status', newOrder.statusLabel),
            _buildReceiptRow('Metode', newOrder.diningOption),
            if (newOrder.tableNumber != '-')
              _buildReceiptRow('Meja', newOrder.tableNumber),
            _buildReceiptRow('Pembayaran', newOrder.paymentMethod),
            if (_voucherApplied) _buildReceiptRow('Diskon Kupon', '-Rp 3.000'),
            const Divider(height: 20),
            _buildReceiptRow(
              'Total Bayar',
              CartState.formatRupiah(_finalTotal),
              isBold: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Mohon tunggu sebentar, pesanan sedang disiapkan di dapur Kantin Bu Sari.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Ke Beranda', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(initialTab: 0),
                ),
              );
            },
            child: const Text('Pantau Pesanan'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: isBold ? const Color(0xFF162A20) : Colors.grey.shade600,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 12,
                color: isBold ? primaryColor : const Color(0xFF162A20),
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF162A20),
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _cartState,
            builder: (context, _) {
              if (_cartState.cartItems.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: accentColor),
                tooltip: 'Kosongkan Keranjang',
                onPressed: () {
                  _cartState.clearCart();
                },
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _cartState,
        builder: (context, _) {
          final items = _cartState.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE6DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 50, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang Anda Masih Kosong',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Jelajahi menu lezat Kantin Bu Sari dan pesan sekarang!',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Lihat Menu'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Jumlah Pesanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu Dipesan (${_cartState.totalCartCount} item)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF162A20),
                      ),
                    ),
                    Text(
                      '${items.length} macam menu',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Widget 1: ListView.separated item keranjang
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2DDD2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.network(
                                item.menu.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, _) => Container(
                                  color: const Color(0xFFEBE6DC),
                                  child: const Icon(Icons.fastfood,
                                      color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.menu.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF162A20),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Level: ${item.spicyLevel}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                if (item.toppings.isNotEmpty)
                                  Text(
                                    '+ Topping: ${item.toppings.join(', ')}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: primaryColor,
                                    ),
                                  ),
                                if (item.notes.isNotEmpty)
                                  Text(
                                    'Catatan: "${item.notes}"',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color: accentColor,
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  CartState.formatRupiah(item.itemTotal),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Stepper Counter Kuantitas Item
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F5F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _cartState.updateQuantity(item.id, -1),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(Icons.remove, size: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      _cartState.updateQuantity(item.id, 1),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(Icons.add,
                                        size: 14, color: primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // Widget 2: SegmentedButton Opsi Santap (Dine In vs Take Away)
                const Text(
                  'Metode Penyajian',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF162A20),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'Makan di Tempat',
                        label: Text('Makan di Tempat'),
                        icon: Icon(Icons.table_restaurant_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: 'Bawa Pulang',
                        label: Text('Bawa Pulang (Bungkus)'),
                        icon: Icon(Icons.takeout_dining_rounded, size: 16),
                      ),
                    ],
                    selected: {_diningOption},
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
                      setState(() => _diningOption = newSelection.first);
                    },
                  ),
                ),

                if (_diningOption == 'Makan di Tempat') ...[
                  const SizedBox(height: 12),
                  // Widget 3: TextField Nomor Meja
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2DDD2)),
                    ),
                    child: TextField(
                      controller: _tableNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Meja',
                        hintText: 'Misal: Meja 05 atau Lesehan 2',
                        prefixIcon: Icon(Icons.place_outlined, color: primaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                // Widget 4: Pilihan Metode Pembayaran
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF162A20),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPaymentCard('QRIS', Icons.qr_code_rounded, 'Scan QR'),
                    const SizedBox(width: 8),
                    _buildPaymentCard('Tunai', Icons.payments_rounded, 'Di Kasir'),
                    const SizedBox(width: 8),
                    _buildPaymentCard('Transfer', Icons.account_balance_rounded, 'Bank BCA'),
                  ],
                ),

                const SizedBox(height: 18),

                // Widget 5: Input Voucher Promo Diskon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2DDD2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined,
                          color: Color(0xFFE9B949)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _voucherController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Kode Voucher (HEMAT10)',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _applyVoucher,
                        child: const Text('Pakai', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Widget 6: SwitchListTile Ramah Lingkungan
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2DDD2)),
                  ),
                  child: SwitchListTile(
                    title: const Text('Sertakan Sendok Plastik & Tisu'),
                    subtitle: const Text('Bantu kurangi sampah jika bawa sendiri'),
                    secondary: const Icon(Icons.eco_outlined, color: Colors.green),
                    value: _needCutlery,
                    activeThumbColor: primaryColor,
                    onChanged: (val) => setState(() => _needCutlery = val),
                  ),
                ),

                const SizedBox(height: 18),

                // Rincian Biaya
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2DDD2)),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                          'Subtotal Menu', CartState.formatRupiah(_cartState.subtotal)),
                      if (_voucherApplied)
                        _buildSummaryRow('Diskon Voucher', '-Rp 3.000',
                            isNegative: true),
                      const Divider(height: 16),
                      _buildSummaryRow(
                        'Total Tagihan',
                        CartState.formatRupiah(_finalTotal),
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Widget 7: Tombol Checkout
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _processCheckout,
                    child: Text(
                      'Pesan Sekarang • ${CartState.formatRupiah(_finalTotal)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(String id, IconData icon, String subtitle) {
    final isSelected = _paymentMethod == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xFFE2DDD2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? primaryColor : Colors.grey.shade600,
                  size: 22),
              const SizedBox(height: 4),
              Text(
                id,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primaryColor : const Color(0xFF162A20),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: isBold ? const Color(0xFF162A20) : Colors.grey.shade600,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                color: isNegative
                    ? Colors.green
                    : (isBold ? primaryColor : const Color(0xFF162A20)),
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
