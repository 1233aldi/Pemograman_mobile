import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetDasarApp());
}

class WidgetDasarApp extends StatelessWidget {
  const WidgetDasarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Widget Dasar App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F3),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 3,
        title: const Text(
          'Biodata Aldi Darmawan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shadowColor: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Foto profil
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/aldi.jpg'),
                ),
                const SizedBox(height: 20),

                // Nama
                const Text(
                  'Aldi Darmawan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),

                // Info baris 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.school, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Mahasiswa UIN STS Jambi',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Info baris 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      'Jambi, Indonesia',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Tombol aksi
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint('Tombol Lihat Profil ditekan!');
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text(
                    'Lihat Profil',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
