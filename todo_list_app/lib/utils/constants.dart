import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Todo List';
  static const String storageKey = 'todos';
  
  // Filter types
  static const String filterAll = 'all';
  static const String filterDone = 'done';
  static const String filterNotDone = 'notyet';
  
  // Messages
  static const String emptyTodoMessage = 'Belum ada todo';
  static const String addTodoTitle = 'Tambah Todo';
  static const String editTodoTitle = 'Edit Todo';
  static const String cancelText = 'Batal';
  static const String saveText = 'Simpan';
  static const String deleteText = 'Hapus';
  static const String confirmDeleteTitle = 'Hapus Todo';
  static const String confirmDeleteMessage = 'Apakah Anda yakin ingin menghapus todo ini?';
}

class AppColors {
  static const primaryColor = Colors.blue;
  static const accentColor = Colors.blueAccent;
  static const dangerColor = Colors.red;
  static const successColor = Colors.green;
}