// models/study_task.dart
import 'package:flutter/material.dart';

class StudyTask {
  final String id;
  final String title;
  final String description;
  final String subject;
  final int duration;
  final String priority;
  final bool completed;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  StudyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.duration,
    required this.priority,
    required this.completed,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  StudyTask copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    int? duration,
    String? priority,
    bool? completed,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
