import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';
import 'local_storage_service.dart';

class HomePage extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleTheme;
  const HomePage({super.key, required this.darkMode, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeedbackItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadFeedbackItems();
  }

  void _loadFeedbackItems() async {
    final items = await LocalStorageService.loadFeedbackItems();
    setState(() {
      _items = items;
    });
  }

  void _saveFeedbackItems() async {
    await LocalStorageService.saveFeedbackItems(_items);
  }

  void _goToForm() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FeedbackFormPage(
          onSavedToHome: (item) {
            setState(() {
              _items.add(item);
              _saveFeedbackItems();
            });
          },
          existing: List.of(_items),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _goToList() async {
    final updated = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FeedbackListPage(items: List.of(_items)),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    
    if (updated is List<FeedbackItem>) {
      setState(() {
        _items
          ..clear()
          ..addAll(updated);
        _saveFeedbackItems();
      });
    }
  }

  void _goToAbout() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AboutPage(),
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Dark'),
              ),
              Switch(
                value: widget.darkMode,
                onChanged: widget.onToggleTheme,
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Image.asset('assets/flutter_logo.png', width: 72, height: 72),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Campus Feedback',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _goToForm,
                          icon: const Icon(Icons.feedback),
                          label: const Text('Formulir Feedback Mahasiswa'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_items.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _goToList,
                            icon: const Icon(Icons.list_alt),
                            label: const Text('Daftar Feedback'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _goToAbout,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Profil Aplikasi / Tentang Kami'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Jumlah Feedback: ${_items.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              '“Coding adalah seni memecahkan masalah dengan logika dan kreativitas.”',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}