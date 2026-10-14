import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _spicyTolerance = 3.0;
  bool _enableSound = true;
  bool _ecoFriendlyDefault = true;

  static const primaryColor = Color(0xFF0F4C3A);
  static const accentColor = Color(0xFFE05A47);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Profil & Info Kantin',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF162A20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Widget 1: Kartu Member Mahasiswa Kantin Bu Sari Bergaya Kartu Loyalitas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C3A), Color(0xFF1E5E4B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: primaryColor, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Ervan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'NPM: 065124073',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9B949),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'MEMBER GOLD',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF162A20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 28),
                  const Text(
                    'Stempel Loyalitas Makan Siang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Widget 2: Baris Stempel Hadiah Kantin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final isStamped = index < 4;
                      return Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isStamped
                              ? const Color(0xFFE9B949)
                              : Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isStamped
                              ? Icons.check
                              : Icons.local_drink_outlined,
                          size: 14,
                          color: isStamped ? primaryColor : Colors.white60,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kumpulkan 2 stempel lagi untuk Gratis 1x Es Teh Jumbo!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Widget 3: Slider Preferensi Rasa Pedas
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
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department_rounded,
                              color: accentColor, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Toleransi Pedas Default',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF162A20),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Level ${_spicyTolerance.round()}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rekomendasi kepedasan yang otomatis dipilih saat memesan.',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Slider(
                    value: _spicyTolerance,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: primaryColor,
                    inactiveColor: const Color(0xFFEBE6DC),
                    label: 'Level ${_spicyTolerance.round()}',
                    onChanged: (val) {
                      setState(() => _spicyTolerance = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Widget 4: SwitchListTile Pengaturan Pesanan
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2DDD2)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Bunyi Notifikasi Pesanan Siap'),
                    subtitle: const Text('Membunyikan nada saat masakan selesai dimasak'),
                    secondary: const Icon(Icons.notifications_active_outlined,
                        color: primaryColor),
                    value: _enableSound,
                    activeThumbColor: primaryColor,
                    onChanged: (val) => setState(() => _enableSound = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Opsi Ramah Lingkungan Otomatis'),
                    subtitle: const Text('Tanpa sendok plastik bila tidak dicentang'),
                    secondary: const Icon(Icons.eco_outlined, color: Colors.green),
                    value: _ecoFriendlyDefault,
                    activeThumbColor: primaryColor,
                    onChanged: (val) => setState(() => _ecoFriendlyDefault = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Widget 5: ExpansionTile Informasi Stan Kantin & FAQ
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2DDD2)),
              ),
              child: Theme(
                data:
                    Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const Icon(Icons.storefront_rounded, color: primaryColor),
                  title: const Text(
                    'Informasi Stan Kantin Bu Sari',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162A20),
                    ),
                  ),
                  subtitle: const Text(
                    'Lokasi, jam buka, dan kontak',
                    style: TextStyle(fontSize: 11),
                  ),
                  children: [
                    const Divider(height: 1),
                    // Widget 6: ListTile info
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined, size: 20),
                      title: const Text('Lokasi Stan'),
                      subtitle: const Text('Pujasera Gedung B, Lantai 1 (Stan No. 04)'),
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.access_time_rounded, size: 20),
                      title: const Text('Jam Operasional'),
                      subtitle: const Text('Senin - Sabtu: 07.30 - 17.00 WIB'),
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.chat_outlined, size: 20),
                      title: const Text('WhatsApp Bu Sari'),
                      subtitle: const Text('+62 812-3456-7890'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Membuka kontak WhatsApp Kantin Bu Sari...'),
                            backgroundColor: primaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Widget 7: ElevatedButton Simpan Pengaturan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferensi profil berhasil disimpan!'),
                      backgroundColor: primaryColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text(
                  'Simpan Preferensi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
