import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem item;
  final VoidCallback onDelete;
  const FeedbackDetailPage({super.key, required this.item, required this.onDelete});

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Feedback?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      onDelete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chipStyle = Theme.of(context).textTheme.labelMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Nama'),
              subtitle: Text(item.nama),
            ),
            ListTile(
              title: const Text('NIM'),
              subtitle: Text(item.nim),
            ),
            ListTile(
              title: const Text('Fakultas'),
              subtitle: Text(item.fakultas),
            ),
            ListTile(
              title: const Text('Fasilitas yang dipilih'),
              subtitle: Wrap(
                spacing: 8,
                runSpacing: -8,
                children: item.fasilitas.isEmpty
                    ? [Text('Tidak ada', style: chipStyle)]
                    : item.fasilitas.map((f) => Chip(label: Text(f))).toList(),
              ),
            ),
            ListTile(
              title: const Text('Nilai Kepuasan'),
              subtitle: Text('${item.nilaiKepuasan.toStringAsFixed(1)} / 5'),
            ),
            ListTile(
              title: const Text('Jenis Feedback'),
              subtitle: Text(item.jenis),
            ),
            ListTile(
              title: const Text('Pesan Tambahan'),
              subtitle: Text(item.pesanTambahan.isEmpty ? '-' : item.pesanTambahan),
            ),
            SwitchListTile(
              title: const Text('Setuju S&K'),
              value: item.setuju,
              onChanged: null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}