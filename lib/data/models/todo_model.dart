import '../models/subtask_model.dart';
import '../models/tag_model.dart';

class TodoModel {
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int priority; // 0: low, 1: medium, 2: high
  final int status; // 0: pending, 1: in progress, 2: completed
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubtaskModel> subtasks;
  final List<TagModel> tags;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 0,
    this.status = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.subtasks = const [],
    this.tags = const [],
  }) : this.createdAt = createdAt ?? DateTime.now(),
       this.updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      priority: map['priority'] ?? 0,
      status: map['status'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SubtaskModel>? subtasks,
    List<TagModel>? tags,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtasks: subtasks ?? this.subtasks,
      tags: tags ?? this.tags,
    );
  }
}
