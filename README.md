# Aplikasi Kantin Bu Sari - Tugas Praktikum Pemrograman Mobile (Pertemuan 2)

**Nama Mahasiswa:** Ervan  
**NPM:** 065124073  

Aplikasi pemesanan makanan dan minuman untuk **Kantin Bu Sari** (Pujasera Kampus Gedung B). Desain antarmuka dirancang dengan konsep **Modern Campus Bistro & Eatery** bernuansa *Deep Pine Green* (`#0F4C3A`) dan *Warm Terracotta* (`#E05A47`), dengan tata letak yang proporsional, interaktif, dan berbeda dari desain grid standar.

---

## 🎨 Konsep & Karakteristik Desain UI Baru

1. **Tema & Palet Warna**:
   * Warna Utama: *Deep Pine Green* (`#0F4C3A`) – memberikan kesan pujasera modern, segar, dan bersih.
   * Warna Aksen: *Warm Terracotta* (`#E05A47`) – untuk tombol aksi utama (*Call to Action*).
   * Latar Belakang: *Warm Canvas / Alabaster* (`#F7F5F0`) – kontras lembut di mata, bukan putih polos silau.
2. **Tata Letak Berbeda**:
   * **Beranda**: Menggunakan *Horizontal Carousel* untuk rekomendasi menu terlaris + *Vertical Row Cards* untuk daftar menu lengkap (bukan grid 2-kolom biasa).
   * **Detail Menu**: Menggunakan `CustomScrollView` dengan `SliverAppBar` & `FlexibleSpaceBar`, serta `SegmentedButton` untuk pilihan level pedas.
   * **Keranjang**: Opsi santap menggunakan `SegmentedButton` (Dine In vs Take Away) dan kartu pilihan pembayaran interaktif (QRIS, Tunai, Bank).
   * **Riwayat Pesanan**: Pelacakan visual horizontal step tracker (*Diterima -> Dimasak -> Siap Ambil*).
   * **Profil**: Kartu member loyalitas stempel makan siang (*Punch Card*) + slider kepedasan.

---

## 📱 Daftar Halaman & Implementasi Widget

Setiap halaman telah memenuhi ketentuan tugas praktikum dengan mengimplementasikan sekurang-kurangnya 5 jenis widget bervariasi:

### 1. Halaman Beranda (`HomeScreen` / `home_screen.dart`)
* **`TextField`**: Kolom pencarian menu dengan icon pencarian dan tombol pembersih (*clear*).
* **`SingleChildScrollView` (Horizontal)**: Kategori menu interaktif (*Semua, Makanan, Minuman, Camilan*) dengan icon tematik.
* **`ListView.separated` (Horizontal)**: Carousel sorotan menu paling laris hari ini.
* **`ListView.separated` (Vertikal)**: Daftar menu makanan/minuman dengan kartu baris horizontal.
* **`Badge`**: Indikator jumlah belanja pada icon keranjang di AppBar.
* **`RefreshIndicator`**: Menarik layar ke bawah untuk memuat ulang katalog.
* **`ElevatedButton`**: Tombol klaim kupon diskon makan siang mahasiswa.

### 2. Halaman Detail Menu (`DetailScreen` / `detail_screen.dart`)
* **`CustomScrollView` & `SliverAppBar`**: Header foto menu dengan efek gulir *flexible space*.
* **`SegmentedButton<String>`**: Pilihan level rasa (*Manis/Gurih, Sedang, Ekstra Cabai*).
* **`FilterChip`**: Pilihan topping tambahan (*Telur Dadar, Kerupuk Kaleng, Nasi Tambah*).
* **`TextField`**: Kolom catatan khusus untuk dapur Bu Sari.
* **`IconButton` & Counter**: Pengatur jumlah porsi pesanan.
* **`ElevatedButton.icon`**: Tombol konfirmasi tambah ke keranjang dengan total harga otomatis.
* **`SnackBar`**: Notifikasi konfirmasi berhasil masuk keranjang.

### 3. Halaman Keranjang (`CartScreen` / `cart_screen.dart`)
* **`ListView.separated`**: Daftar item pesanan beserta variasi level dan toppingnya.
* **`SegmentedButton<String>`**: Pemilih metode penyajian (*Makan di Tempat* atau *Bawa Pulang*).
* **`TextField`**: Input nomor meja kantin.
* **`TextField` & `ElevatedButton`**: Input dan validasi voucher diskon (*HEMAT10*).
* **`SwitchListTile`**: Opsi ramah lingkungan (*Sertakan Sendok Plastik & Tisu*).
* **Kartu Pilihan Pembayaran**: Pilihan metode *QRIS*, *Tunai di Kasir*, dan *Transfer Bank*.
* **`AlertDialog`**: Struk digital pop-up konfirmasi pesanan berhasil dibuat.

### 4. Halaman Status & Riwayat Pesanan (`OrderHistoryScreen` / `order_history_screen.dart`)
* **`SegmentedButton<int>`**: Switcher tab antara *Pesanan Berjalan* dan *Riwayat Selesai*.
* **Step Timeline Tracker**: Indikator visual progres memasak (*Diterima -> Dimasak -> Siap Ambil*).
* **`ExpansionTile`**: Membuka rincian tiap menu dan harga di dalam nota transaksi.
* **`Chip` / Badge**: Label status pesanan berwarna (*Diproses / Siap Diambil / Selesai*).
* **`ElevatedButton`**: Tombol interaktif simulasi progres status pesanan di dapur.
* **`OutlinedButton.icon`**: Tombol untuk memesan ulang menu (*Re-order*).
* **`RefreshIndicator`**: Memperbarui status pesanan.

### 5. Halaman Profil & Info Stan (`ProfileScreen` / `profile_screen.dart`)
* **Kartu Member Loyalitas**: Desain kartu mahasiswa dengan baris stempel hadiah makan siang.
* **`Slider`**: Pengatur preferensi toleransi pedas bawaan (Level 1 - 5).
* **`SwitchListTile`**: Pengaturan bunyi notifikasi makanan siap dan opsi ramah lingkungan.
* **`ExpansionTile`**: Akordion informasi lokasi stan, jam operasional, dan kontak WhatsApp Bu Sari.
* **`ElevatedButton.icon`**: Tombol simpan pengaturan preferensi.

---

## 📂 Struktur File

```
lib/
├── main.dart                      # Tema Deep Pine Green & routing utama
├── models/
│   ├── menu_item.dart             # Model item menu makanan & minuman
│   ├── cart_item.dart             # Model item belanjaan & varian
│   └── order_model.dart           # Model riwayat transaksi & status
├── data/
│   ├── dummy_data.dart            # Data menu khas kantin kampus
│   └── cart_state.dart            # Pengelola state keranjang & order (ChangeNotifier)
└── screens/
    ├── main_navigation_screen.dart # Navigasi custom + floating pill cart button
    ├── home_screen.dart           # Beranda, kupon, carousel, & list menu
    ├── detail_screen.dart         # Detail menu (SliverAppBar & SegmentedButton)
    ├── cart_screen.dart           # Keranjang, voucher, & checkout dialog
    ├── order_history_screen.dart  # Riwayat transaksi & visual step tracker
    └── profile_screen.dart        # Profil member, stempel loyalitas, & info stan
```

---

## 🚀 Cara Menjalankan

```bash
flutter pub get
flutter run
```
