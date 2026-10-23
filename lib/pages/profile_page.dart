import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'user_list_page.dart';

/// Halaman 1: Profil (StatelessWidget).
/// Memakai Container + Column untuk foto/identitas dan Row untuk info singkat.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Ganti dengan data kamu sendiri.
  static const String _nama = 'Nabila Nurul Azizah';
  static const String _nim = '240102089';
  static const String _prodi = 'Teknik Informatika - UM Bandung';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Kartu foto + identitas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: AppTheme.accent,
                      child: Icon(
                        Icons.person,
                        size: 64,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _nama,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _nim,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Baris info singkat
              const Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.school_rounded,
                      label: 'Prodi',
                      value: _prodi,
                      color: AppTheme.secondary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.menu_book_rounded,
                      label: 'Mata Kuliah',
                      value: 'PPB',
                      color: AppTheme.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserListPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.people_alt_rounded),
                label: const Text('Lihat Daftar Mahasiswa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.textDark),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSoft),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
