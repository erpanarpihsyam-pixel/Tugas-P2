import 'package:flutter/material.dart';
import '../data/cart_state.dart';
import '../data/dummy_data.dart';
import '../models/menu_item.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CartState _cartState = CartState();

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  static const primaryColor = Color(0xFF0F4C3A); // Deep Pine Green
  static const accentColor = Color(0xFFE05A47); // Warm Terracotta

  final List<Map<String, dynamic>> _categoryData = [
    {'name': 'Semua', 'icon': Icons.restaurant},
    {'name': 'Makanan', 'icon': Icons.lunch_dining_rounded},
    {'name': 'Minuman', 'icon': Icons.local_cafe_rounded},
    {'name': 'Camilan', 'icon': Icons.cookie_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredMenu {
    return DummyData.menuList.where((item) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<MenuItem> get _popularItems {
    return DummyData.menuList.where((item) => item.isPopular).toList();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _selectedCategory = 'Semua';
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Buka • 07.30 - 17.00 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Kantin Bu Sari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF162A20),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          // Widget 1: Badge ikon keranjang di AppBar
          ListenableBuilder(
            listenable: _cartState,
            builder: (context, _) {
              final count = _cartState.totalCartCount;
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFEBE6DC),
                    foregroundColor: primaryColor,
                  ),
                  icon: Badge(
                    isLabelVisible: count > 0,
                    label: Text('$count'),
                    backgroundColor: accentColor,
                    child: const Icon(Icons.shopping_bag_outlined, size: 20),
                  ),
                  tooltip: 'Lihat Keranjang',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      // Widget 2: RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card Sapaan & Kupon Diskon Mahasiswa
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  children: [
                    // Widget 3: TextField Pencarian Menu
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F5F0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2DDD2)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari soto, es teh, ayam geprek...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(Icons.search, color: primaryColor),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Widget 4: Card Kupon Diskon Bergaya Tiket Pujasera
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_activity_rounded,
                              color: Color(0xFFE9B949),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kupon Makan Siang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Gunakan kode "HEMAT10" untuk potongan belanja.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Widget 5: ElevatedButton pada Kupon
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE9B949),
                              foregroundColor: const Color(0xFF162A20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Kode HEMAT10 tersalin! Diskon aktif di keranjang.'),
                                  backgroundColor: primaryColor,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text(
                              'Klaim',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Widget 6: Kategori Menu Horizontal dengan Icon Bulat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori Menu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF162A20),
                      ),
                    ),
                    if (_selectedCategory != 'Semua' || _searchQuery.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = 'Semua';
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        child: const Text('Reset', style: TextStyle(color: accentColor)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _categoryData.map((cat) {
                    final isSelected = _selectedCategory == cat['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat['name'];
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : const Color(0xFFE2DDD2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['name'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF162A20),
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Bagian 1: Carousel Rekomendasi Terlaris (hanya jika tanpa filter spesifik)
              if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFE9B949), size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        'Pilihan Terlaris Hari Ini',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF162A20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Widget 7: Horizontal ListView untuk Pilihan Terlaris
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _popularItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final item = _popularItems[index];
                      return _buildFeaturedCard(item);
                    },
                  ),
                ),
              ],

              const SizedBox(height: 22),

              // Bagian 2: Daftar Menu Lengkap (Tata letak kartu horizontal modern)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Daftar Menu (${_filteredMenu.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF162A20),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              if (_filteredMenu.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        'Menu tidak ditemukan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coba cari menu lain atau reset kategori filter.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Widget 8: ListView.separated vertikal kartu menu baris
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredMenu.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filteredMenu[index];
                    return _buildHorizontalMenuCard(item);
                  },
                ),

              const SizedBox(height: 90), // Ruang untuk floating cart button
            ],
          ),
        ),
      ),
    );
  }

  // Kartu Spotlight Carousel
  Widget _buildFeaturedCard(MenuItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(menuItem: item)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2DDD2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 105,
              width: double.infinity,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                  color: const Color(0xFFEBE6DC),
                  child: const Icon(Icons.fastfood, color: primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          CartState.formatRupiah(item.price),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFE9B949), size: 11),
                            const SizedBox(width: 2),
                            Text(
                              '${item.rating}',
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu Menu Vertikal Horizontal-Row
  Widget _buildHorizontalMenuCard(MenuItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(menuItem: item)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2DDD2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar makanan dengan radius halus
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, _) => Container(
                    color: const Color(0xFFEBE6DC),
                    child: const Icon(Icons.restaurant, color: primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Deskripsi & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE6DC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: Color(0xFFE9B949), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '${item.rating} (${item.soldCount}+ terjual)',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CartState.formatRupiah(item.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      // Tombol quick add bernuansa soft button
                      InkWell(
                        onTap: () {
                          _cartState.quickAddToCart(item);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${item.name} dimasukkan ke keranjang'),
                              backgroundColor: primaryColor,
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Buka',
                                textColor: const Color(0xFFE9B949),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CartScreen()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add, size: 14, color: Colors.white),
                              SizedBox(width: 2),
                              Text(
                                'Pesan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
