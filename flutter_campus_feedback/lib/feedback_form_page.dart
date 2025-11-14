import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  final void Function(FeedbackItem) onSavedToHome;
  final List<FeedbackItem> existing;
  const FeedbackFormPage({super.key, required this.onSavedToHome, required this.existing});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _pesanCtrl = TextEditingController();

  String? _fakultas;
  final List<String> _fakultasOpts = const [
    'Fakultas Ushuluddin dan Studi Agama',
    'Fakultas Syariah',
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Tarbiyah dan Keguruan',
    'Fakultas Dakwah',
    'Fakultas Adab dan Humaniora',
    'Fakultas Sains dan Teknologi',
  ];

  final Map<String, bool> _fasilitas = {
    'Perpustakaan': false,
    'Kelas': false,
    'Laboratorium': false,
    'Kantin': false,
    'Wi-Fi Kampus': false,
  };

  double _nilai = 3;
  String _jenis = 'Saran';
  bool _setuju = false;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _pesanCtrl.dispose();
    super.dispose();
  }

  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_setuju) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Aktifkan persetujuan Syarat & Ketentuan sebelum menyimpan.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final fasilitasDipilih = _fasilitas.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final item = FeedbackItem(
      nama: _namaCtrl.text.trim(),
      nim: _nimCtrl.text.trim(),
      fakultas: _fakultas!,
      fasilitas: fasilitasDipilih,
      nilaiKepuasan: _nilai,
      jenis: _jenis,
      pesanTambahan: _pesanCtrl.text.trim(),
      setuju: _setuju,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback disimpan!')),
    );

    widget.onSavedToHome(item);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          final combined = [...widget.existing, item];
          return FeedbackListPage(items: combined);
        },
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Feedback Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nimCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                  final onlyDigits = RegExp(r'^\d+$');
                  if (!onlyDigits.hasMatch(v.trim())) return 'NIM harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fakultas,
                items: _fakultasOpts
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Fakultas',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _fakultas = v),
                validator: (v) => v == null ? 'Pilih fakultas' : null,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fasilitas yang Dinilai',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ..._fasilitas.keys.map((k) => CheckboxListTile(
                          title: Text(k),
                          value: _fasilitas[k],
                          onChanged: (v) => setState(() => _fasilitas[k] = v ?? false),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nilai Kepuasan: ${_nilai.toStringAsFixed(1)} / 5'),
                  Slider(
                    value: _nilai,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    label: _nilai.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _nilai = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jenis Feedback', style: Theme.of(context).textTheme.titleMedium),
                  RadioListTile(
                    title: const Text('Saran'),
                    value: 'Saran',
                    groupValue: _jenis,
                    onChanged: (v) => setState(() => _jenis = v!),
                  ),
                  RadioListTile(
                    title: const Text('Keluhan'),
                    value: 'Keluhan',
                    groupValue: _jenis,
                    onChanged: (v) => setState(() => _jenis = v!),
                  ),
                  RadioListTile(
                    title: const Text('Apresiasi'),
                    value: 'Apresiasi',
                    groupValue: _jenis,
                    onChanged: (v) => setState(() => _jenis = v!),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pesanCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Pesan Tambahan (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Setuju Syarat & Ketentuan'),
                value: _setuju,
                onChanged: (v) => setState(() => _setuju = v),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Feedback'),
                  onPressed: _simpan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}