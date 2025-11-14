import 'dart:convert';
import 'package:flutter/foundation.dart';

class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitas;
  final double nilaiKepuasan;
  final String jenis;
  final String pesanTambahan;
  final bool setuju;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenis,
    required this.pesanTambahan,
    required this.setuju,
  });

  // Convert to Map untuk SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'fakultas': fakultas,
      'fasilitas': fasilitas,
      'nilaiKepuasan': nilaiKepuasan,
      'jenis': jenis,
      'pesanTambahan': pesanTambahan,
      'setuju': setuju,
    };
  }

  // Create from Map untuk SharedPreferences
  factory FeedbackItem.fromMap(Map<String, dynamic> map) {
    return FeedbackItem(
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
      fakultas: map['fakultas'] ?? '',
      fasilitas: List<String>.from(map['fasilitas'] ?? []),
      nilaiKepuasan: (map['nilaiKepuasan'] is double) 
          ? map['nilaiKepuasan'] 
          : (map['nilaiKepuasan'] is int)
            ? map['nilaiKepuasan'].toDouble()
            : double.parse(map['nilaiKepuasan'].toString()),
      jenis: map['jenis'] ?? '',
      pesanTambahan: map['pesanTambahan'] ?? '',
      setuju: map['setuju'] ?? false,
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Create from JSON
  factory FeedbackItem.fromJson(String source) => 
      FeedbackItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeedbackItem(nama: $nama, nim: $nim, fakultas: $fakultas, fasilitas: $fasilitas, nilaiKepuasan: $nilaiKepuasan, jenis: $jenis, pesanTambahan: $pesanTambahan, setuju: $setuju)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FeedbackItem &&
        other.nama == nama &&
        other.nim == nim &&
        other.fakultas == fakultas &&
        listEquals(other.fasilitas, fasilitas) &&
        other.nilaiKepuasan == nilaiKepuasan &&
        other.jenis == jenis &&
        other.pesanTambahan == pesanTambahan &&
        other.setuju == setuju;
  }

  @override
  int get hashCode {
    return nama.hashCode ^
        nim.hashCode ^
        fakultas.hashCode ^
        fasilitas.hashCode ^
        nilaiKepuasan.hashCode ^
        jenis.hashCode ^
        pesanTambahan.hashCode ^
        setuju.hashCode;
  }
}