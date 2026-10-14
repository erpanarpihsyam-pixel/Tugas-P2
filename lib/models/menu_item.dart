class MenuItem {
  final String id;
  final String name;
  final String category; // 'Makanan', 'Minuman', 'Camilan'
  final int price;
  final String description;
  final String imageUrl;
  final double rating;
  final int soldCount;
  final bool isPopular;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.soldCount,
    this.isPopular = false,
  });
}
