import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/todo_item.dart';
import '../widgets/empty_state.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  List<Todo> filteredTodos = [];
  String currentFilter = AppConstants.filterAll;
  bool isLoading = true;

  final TodoService _todoService = TodoService();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    setState(() => isLoading = true);
    todos = await _todoService.loadTodos();
    _applyFilter();
    setState(() => isLoading = false);
  }

  void _applyFilter() {
    switch (currentFilter) {
      case AppConstants.filterDone:
        filteredTodos = todos.where((todo) => todo.isCompleted).toList();
        break;
      case AppConstants.filterNotDone:
        filteredTodos = todos.where((todo) => !todo.isCompleted).toList();
        break;
      default:
        filteredTodos = List.from(todos);
    }
    
    // Sort by completion status and creation date
    filteredTodos.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  void _saveTodos() {
    _todoService.saveTodos(todos);
  }

  void _showAddTodoDialog() {
    _textController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.addTodoTitle),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Masukkan judul todo",
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _addTodo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelText),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text(AppConstants.saveText),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final title = _textController.text.trim();
    if (title.isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
    );

    setState(() {
      todos.insert(0, newTodo);
      _applyFilter();
    });

    _saveTodos();
    Navigator.pop(context);
  }

  void _showEditTodoDialog(Todo todo) {
    _textController.text = todo.title;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.editTodoTitle),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Edit judul todo",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelText),
          ),
          ElevatedButton(
            onPressed: () => _updateTodo(todo),
            child: const Text(AppConstants.saveText),
          ),
        ],
      ),
    );
  }

  void _updateTodo(Todo todo) {
    final newTitle = _textController.text.trim();
    if (newTitle.isEmpty) return;

    setState(() {
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo.copyWith(
          title: newTitle,
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    });

    _saveTodos();
    Navigator.pop(context);
  }

  void _toggleTodoStatus(Todo todo) {
    setState(() {
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo.copyWith(
          isCompleted: !todo.isCompleted,
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    });
    _saveTodos();
  }

  void _showDeleteConfirmation(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.confirmDeleteTitle),
        content: const Text(AppConstants.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelText),
          ),
          TextButton(
            onPressed: () {
              _deleteTodo(todo);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.dangerColor,
            ),
            child: const Text(AppConstants.deleteText),
          ),
        ],
      ),
    );
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      todos.removeWhere((t) => t.id == todo.id);
      _applyFilter();
    });
    _saveTodos();
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo berhasil dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllTodos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Todo'),
        content: const Text('Apakah Anda yakin ingin menghapus semua todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelText),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                todos.clear();
                filteredTodos.clear();
              });
              _saveTodos();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.dangerColor,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Filter menu
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                currentFilter = value;
                _applyFilter();
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: AppConstants.filterAll,
                child: Text("Semua"),
              ),
              PopupMenuItem(
                value: AppConstants.filterDone,
                child: Text("Selesai"),
              ),
              PopupMenuItem(
                value: AppConstants.filterNotDone,
                child: Text("Belum Selesai"),
              ),
            ],
          ),
          // Clear all button (only show if there are todos)
          if (todos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllTodos,
              tooltip: 'Hapus Semua',
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTodos.isEmpty
              ? EmptyState(
                  message: currentFilter == AppConstants.filterAll
                      ? AppConstants.emptyTodoMessage
                      : currentFilter == AppConstants.filterDone
                          ? 'Belum ada todo yang selesai'
                          : 'Semua todo sudah selesai',
                )
              : ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTodos[index];
                    return TodoItem(
                      todo: todo,
                      onToggle: (value) => _toggleTodoStatus(todo),
                      onEdit: () => _showEditTodoDialog(todo),
                      onDelete: () => _showDeleteConfirmation(todo),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}