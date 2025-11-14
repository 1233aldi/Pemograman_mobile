import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            '🌤 Flutter Navigation Demo\n\n'
            'Aplikasi ini dibuat untuk mempelajari navigasi dasar Flutter, termasuk:\n\n'
            '• Navigator.push() & Navigator.pop()\n'
            '• Pengiriman data antar halaman\n'
            '• BottomNavigationBar & Drawer\n\n'
            'Desain dengan tema warna biru yang lembut.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}