import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import 'feedback_result_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  int _rating = 1;

  String _previewNama = '';
  String _previewKomentar = '';
  int _previewRating = 1;

  void _updatePreview() {
    setState(() {
      _previewNama = _namaController.text;
      _previewKomentar = _komentarController.text;
      _previewRating = _rating;
    });
  }

  void _kirimFeedback() {
    if (_namaController.text.isEmpty || _komentarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final feedback = FeedbackModel(
      nama: _namaController.text,
      komentar: _komentarController.text,
      rating: _rating,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackResultPage(feedback: feedback),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Feedback Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Input Nama
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updatePreview(),
            ),
            const SizedBox(height: 16),

            // Input Komentar
            TextField(
              controller: _komentarController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updatePreview(),
            ),
            const SizedBox(height: 16),

            // Pilih Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rating (1–5):'),
                DropdownButton<int>(
                  value: _rating,
                  items: List.generate(5, (index) {
                    final value = index + 1;
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _rating = value ?? 1;
                      _updatePreview();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol Kirim
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _kirimFeedback,
                child: const Text(
                  'Kirim Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔁 Preview Real-time
            const Text(
              'Preview Real-time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              color: Colors.teal.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama     : $_previewNama'),
                    Text('Komentar : $_previewKomentar'),
                    Text('Rating   : $_previewRating / 5'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
