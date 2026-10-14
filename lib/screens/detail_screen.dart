import 'package:flutter/material.dart';
import '../data/cart_state.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  const DetailScreen({super.key, required this.menuItem});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CartState _cartState = CartState();
  final TextEditingController _notesController = TextEditingController();

  int _quantity = 1;
  String _selectedSpicyLevel = 'Sedang';
  bool _isBookmarked = false;

  static const primaryColor = Color(0xFF0F4C3A);

  final List<String> _selectedToppings = [];
  final Map<String, int> _toppingOptions = {
    'Telur Dadar': 3000,
    'Kerupuk Kaleng': 1000,
    'Nasi Tambah': 3000,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedTotalPrice {
    int toppingTotal = 0;
    for (final t in _selectedToppings) {
      toppingTotal += _toppingOptions[t] ?? 0;
    }
    return (widget.menuItem.price + toppingTotal) * _quantity;
  }

  void _submitAddToCart() {
    final newItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      menu: widget.menuItem,
      quantity: _quantity,
      spicyLevel: _selectedSpicyLevel,
      toppings: List.from(_selectedToppings),
      notes: _notesController.text.trim(),
    );

    _cartState.addToCart(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.menuItem.name} ditambahkan ke keranjang!'),
        backgroundColor: primaryColor,
        action: SnackBarAction(
          label: 'Lihat Keranjang',
          textColor: const Color(0xFFE9B949),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      // Widget 1: CustomScrollView dengan SliverAppBar untuk efek header modern
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.menuItem.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.menuItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => Container(
                      color: const Color(0xFFEBE6DC),
                      child: const Icon(Icons.restaurant,
                          size: 60, color: primaryColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? const Color(0xFFE9B949) : Colors.white,
                ),
                onPressed: () {
                  setState(() => _isBookmarked = !_isBookmarked);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isBookmarked
                          ? 'Menu disimpan ke favorit'
                          : 'Dihapus dari favorit'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu Info Harga & Rating
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2DDD2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CartState.formatRupiah(widget.menuItem.price),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBE6DC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.menuItem.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFE9B949), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.menuItem.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${widget.menuItem.soldCount}+ pesanan berhasil',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.menuItem.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Widget 2: SegmentedButton untuk Pilihan Rasa / Level Pedas
                  const Text(
                    'Pilihan Level Pedas',
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
                          value: 'Tidak Pedas',
                          label: Text('Manis/Gurih'),
                          icon: Icon(Icons.spa_outlined, size: 16),
                        ),
                        ButtonSegment(
                          value: 'Sedang',
                          label: Text('Sedang'),
                          icon: Icon(Icons.whatshot_outlined, size: 16),
                        ),
                        ButtonSegment(
                          value: 'Pedas Mantap',
                          label: Text('Ekstra Cabai'),
                          icon: Icon(Icons.local_fire_department, size: 16),
                        ),
                      ],
                      selected: {_selectedSpicyLevel},
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
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedSpicyLevel = newSelection.first;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Widget 3: FilterChip / Wrap Topping Tambahan
                  const Text(
                    'Topping Tambahan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _toppingOptions.entries.map((entry) {
                      final isSelected = _selectedToppings.contains(entry.key);
                      return FilterChip(
                        label: Text(
                            '${entry.key} (+${CartState.formatRupiah(entry.value)})'),
                        selected: isSelected,
                        selectedColor: primaryColor.withValues(alpha: 0.15),
                        checkmarkColor: primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? primaryColor : Colors.grey.shade800,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFFE2DDD2),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedToppings.add(entry.key);
                            } else {
                              _selectedToppings.remove(entry.key);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // Widget 4: TextField Catatan Khusus
                  const Text(
                    'Catatan Khusus',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'Contoh: Kuah dipisah, jangan pakai timun, es sedikit...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2DDD2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2DDD2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Widget 5: Stepper Kuantitas
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2DDD2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Porsi Pesanan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF162A20),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFF7F5F0),
                              ),
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFF7F5F0),
                                foregroundColor: primaryColor,
                              ),
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Widget 6: Bottom Bar dengan Total dan Tombol Tambah Keranjang
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Subtotal:',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    CartState.formatRupiah(_calculatedTotalPrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _submitAddToCart,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: const Text(
                    'Tambah Pesanan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
