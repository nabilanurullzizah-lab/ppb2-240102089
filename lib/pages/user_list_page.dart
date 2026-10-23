import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

/// Halaman 2: Daftar Mahasiswa (StatefulWidget).
/// FutureBuilder -> ListView.builder, pull-to-refresh, dan SnackBar saat error.
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = _loadUsers();
  }

  /// Memanggil service; jika gagal tampilkan SnackBar lalu teruskan error
  /// agar FutureBuilder menampilkan state error.
  Future<List<User>> _loadUsers() async {
    try {
      return await ApiService.fetchUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Gagal load — cek koneksi')),
          );
      }
      rethrow;
    }
  }

  Future<void> _refresh() async {
    final newFuture = _loadUsers();
    setState(() {
      _futureUsers = newFuture;
    });
    try {
      await newFuture;
    } catch (_) {
      // Error sudah ditangani (SnackBar + state error di FutureBuilder).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mahasiswa')),
      body: RefreshIndicator(
        color: AppTheme.textDark,
        backgroundColor: AppTheme.secondary,
        onRefresh: _refresh,
        child: FutureBuilder<List<User>>(
          future: _futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 160),
                  Icon(Icons.wifi_off_rounded,
                      size: 64, color: AppTheme.textSoft),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Gagal memuat data.\nTarik ke bawah untuk coba lagi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSoft),
                    ),
                  ),
                ],
              );
            }

            final users = snapshot.data ?? const <User>[];

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: users.length,
              itemBuilder: (context, index) => _UserCard(user: users[index]),
            );
          },
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: AppTheme.primary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppTheme.accent,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSoft,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Chip(
                        text: user.city,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: _Chip(
                          text: user.company,
                          color: AppTheme.secondary,
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

class _Chip extends StatelessWidget {
  final String text;
  final Color color;

  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11, color: AppTheme.textDark),
      ),
    );
  }
}
