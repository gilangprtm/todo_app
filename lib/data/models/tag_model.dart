import 'package:flutter/material.dart';

class TagModel {
  final int? id;
  final String name;
  final String? color;
  final DateTime createdAt;

  TagModel({this.id, required this.name, this.color, DateTime? createdAt})
    : this.createdAt = createdAt ?? DateTime.now();

  // Helper method to get color as a Flutter Color
  Color getColor() {
    if (color == null) {
      return Colors.grey;
    }
    try {
      return Color(int.parse(color!.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey; // Default color if parsing fails
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  TagModel copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
