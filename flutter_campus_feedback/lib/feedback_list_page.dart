import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatefulWidget {
  final List<FeedbackItem> items;
  const FeedbackListPage({super.key, required this.items});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackItem> get _items => widget.items;

  IconData _iconFor(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Icons.thumb_up;
      case 'Saran':
        return Icons.lightbulb;
      case 'Keluhan':
        return Icons.report;
      default:
        return Icons.feedback;
    }
  }

  Color _colorFor(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.yellow[700]!;
      case 'Keluhan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _openDetail(int index) async {
    final item = _items[index];
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FeedbackDetailPage(
          item: item,
          onDelete: () {
            setState(() => _items.removeAt(index));
            Navigator.pop(context);
          },
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
    Navigator.pop(context, _items);
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: FeedbackSearchDelegate(
        items: _items,
        onOpenDetail: _openDetail,
        iconFor: _iconFor,
        colorFor: _colorFor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final it = _items[i];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _colorFor(it.jenis),
                      child: Icon(
                        _iconFor(it.jenis),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      it.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${it.fakultas}\nKepuasan: ${it.nilaiKepuasan.toStringAsFixed(1)} / 5',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openDetail(i),
                  ),
                );
              },
            ),
    );
  }
}

class FeedbackSearchDelegate extends SearchDelegate {
  final List<FeedbackItem> items;
  final Function(int) onOpenDetail;
  final IconData Function(String) iconFor;
  final Color Function(String) colorFor;

  FeedbackSearchDelegate({
    required this.items,
    required this.onOpenDetail,
    required this.iconFor,
    required this.colorFor,
  });

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = items
        .where((item) =>
            item.nama.toLowerCase().contains(query.toLowerCase()) ||
            item.fakultas.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('Tidak ditemukan hasil.'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final it = results[i];
        final index = items.indexOf(it);
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colorFor(it.jenis),
              child: Icon(iconFor(it.jenis), color: Colors.white),
            ),
            title: Text(
              it.nama,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(it.fakultas),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              close(context, null);
              onOpenDetail(index);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}