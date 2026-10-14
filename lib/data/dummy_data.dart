import '../models/menu_item.dart';

class DummyData {
  static const List<MenuItem> menuList = [
    MenuItem(
      id: 'm1',
      name: 'Ayam Geprek Sambal Bawang',
      category: 'Makanan',
      price: 15000,
      description:
          'Ayam goreng tepung renyah dengan ulekan cabai rawit pedas mantap khas racikan Bu Sari, disajikan bersama nasi hangat dan lalapan segar.',
      imageUrl:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      soldCount: 320,
      isPopular: true,
    ),
    MenuItem(
      id: 'm2',
      name: 'Nasi Goreng Spesial Bu Sari',
      category: 'Makanan',
      price: 14000,
      description:
          'Nasi goreng aroma smokey dengan suwiran ayam gurih, irisan bakso sapi, telur orak-arik, taburan bawang goreng, dan kerupuk.',
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      soldCount: 275,
      isPopular: true,
    ),
    MenuItem(
      id: 'm3',
      name: 'Mie Ayam Pangsit Bakso',
      category: 'Makanan',
      price: 13000,
      description:
          'Mie kenyal berpadu dengan tumisan ayam kecap manis gurih, sawi hijau segar, pangsit goreng renyah, dan kuah kaldu hangat terpisah.',
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80',
      rating: 4.7,
      soldCount: 198,
      isPopular: false,
    ),
    MenuItem(
      id: 'm4',
      name: 'Soto Ayam Lamongan',
      category: 'Makanan',
      price: 15000,
      description:
          'Soto ayam berkuah kuning rempah harum, disajikan dengan koya gurih melimpah, soun, irisan kol, telur rebus, dan sambal cabai rawit.',
      imageUrl:
          'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      soldCount: 164,
      isPopular: false,
    ),
    MenuItem(
      id: 'm5',
      name: 'Nasi Uduk Komplit',
      category: 'Makanan',
      price: 14000,
      description:
          'Nasi gurih harum serai dan santan, dilengkapi orek tempe manis, bihun goreng, telur balado pedas manis, dan taburan kerupuk.',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=600&q=80',
      rating: 4.6,
      soldCount: 140,
      isPopular: false,
    ),
    MenuItem(
      id: 'm6',
      name: 'Es Teh Manis Jumbo',
      category: 'Minuman',
      price: 4000,
      description:
          'Es teh melati segar dengan racikan gula asli yang pas, disajikan dalam gelas jumbo untuk menyegarkan tenggorokan setelah kuliah.',
      imageUrl:
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      soldCount: 450,
      isPopular: true,
    ),
    MenuItem(
      id: 'm7',
      name: 'Es Jeruk Peras Asli',
      category: 'Minuman',
      price: 5000,
      description:
          'Minuman sari jeruk segar asli yang diperas langsung saat dipesan, kaya vitamin C dan rasa manis alami menyegarkan.',
      imageUrl:
          'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=600&q=80',
      rating: 4.7,
      soldCount: 210,
      isPopular: false,
    ),
    MenuItem(
      id: 'm8',
      name: 'Kopi Susu Gula Aren',
      category: 'Minuman',
      price: 8000,
      description:
          'Espresso kopi robusta lokal berpadu dengan susu creamy dan legitnya gula aren organik, pas untuk teman nugas.',
      imageUrl:
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      soldCount: 185,
      isPopular: true,
    ),
    MenuItem(
      id: 'm9',
      name: 'Tempe Mendoan Hangat (3 Pcs)',
      category: 'Camilan',
      price: 6000,
      description:
          'Tempe kedelai berbalut adonan tepung daun bawang lembut setengah matang, disajikan hangat dengan sambal kecap rawit pedas manis.',
      imageUrl:
          'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      soldCount: 290,
      isPopular: true,
    ),
    MenuItem(
      id: 'm10',
      name: 'Bakwan Sayur Krispi (3 Pcs)',
      category: 'Camilan',
      price: 5000,
      description:
          'Gorengan bakwan sayur isi kol, wortel, dan tauge renyah keemasan, nikmat dicocol dengan cabai rawit hijau segar.',
      imageUrl:
          'https://images.unsplash.com/photo-1541544741938-0af808871cc0?auto=format&fit=crop&w=600&q=80',
      rating: 4.6,
      soldCount: 215,
      isPopular: false,
    ),
    MenuItem(
      id: 'm11',
      name: 'Pisang Goreng Keju Crispy',
      category: 'Camilan',
      price: 8000,
      description:
          'Pisang kepok manis berbalut tepung krispi renyah, diberi topping parutan keju cheddar melimpah dan susu kental manis.',
      imageUrl:
          'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      soldCount: 160,
      isPopular: false,
    ),
  ];

  static const List<String> categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Camilan',
  ];
}
