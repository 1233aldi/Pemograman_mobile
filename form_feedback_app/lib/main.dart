import 'package:flutter/material.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FeedbackFormPage(),
    );
  }
}

class Feedback {
  final String nama;
  final String komentar;
  final int rating;

  Feedback({required this.nama, required this.komentar, required this.rating});
}

// 📝 Halaman 1: Formulir Feedback
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  double _rating = 3;

  // 🔹 List untuk menyimpan history feedback sementara
  final List<Feedback> _feedbackHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)], // 🌤️ Biru awan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Masukkan Feedback Anda',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _komentarController,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Rating: ${_rating.toInt()}',
              style: const TextStyle(fontSize: 18),
            ),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.blueAccent,
              label: _rating.toString(),
              onChanged: (value) {
                setState(() {
                  _rating = value; // update rating real-time
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                if (_namaController.text.isEmpty ||
                    _komentarController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama dan komentar wajib diisi!'),
                    ),
                  );
                  return;
                }

                setState(() {
                  // Tambahkan ke history (maksimal 10 data)
                  _feedbackHistory.insert(
                    0,
                    Feedback(
                      nama: _namaController.text,
                      komentar: _komentarController.text,
                      rating: _rating.toInt(),
                    ),
                  );
                  if (_feedbackHistory.length > 10) {
                    _feedbackHistory.removeLast();
                  }

                  // Reset form
                  _namaController.clear();
                  _komentarController.clear();
                  _rating = 3;
                });

                // Navigasi ke halaman hasil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FeedbackResultPage(feedbackHistory: _feedbackHistory),
                  ),
                );
              },
              child: const Text(
                'Kirim Feedback',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 10),
            const Text(
              'Riwayat :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._feedbackHistory.map(
              (f) => Card(
                child: ListTile(
                  title: Text(f.nama),
                  subtitle: Text('"${f.komentar}"'),
                  trailing: Text('⭐ ${f.rating}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📊 Halaman 2: Menampilkan hasil feedback (dengan riwayat)
class FeedbackResultPage extends StatelessWidget {
  final List<Feedback> feedbackHistory;

  const FeedbackResultPage({super.key, required this.feedbackHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)], // 🌤️ Biru awan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Terima Kasih atas Feedback Anda!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (feedbackHistory.isEmpty)
              const Text(
                'Belum ada feedback dikirim.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              )
            else
              ...feedbackHistory.map(
                (f) => Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.blueAccent),
                    title: Text(f.nama),
                    subtitle: Text('${f.komentar}\nRating: ${f.rating}/5'),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // 🔙 Kembali ke form
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
