// providers/study_plan_provider.dart
import 'package:flutter/material.dart';

import '../models/study_task.dart';

class StudyPlanProvider with ChangeNotifier {
  List<StudyTask> _tasks = [];
  bool _isLoading = false;

  List<StudyTask> get tasks => _tasks;
  bool get isLoading => _isLoading;


  Future<void> generateStudyPlan(
      String topic, String duration, String difficulty) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    try {
      _tasks = _generateMockStudyPlan(topic, duration, difficulty);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to generate study plan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<StudyTask> _generateMockStudyPlan(
      String topic, String duration, String difficulty) {
    // Mock data - replace this with actual ChatGPT API integration
    return [
      StudyTask(
        id: '1',
        title: 'Introduction to $topic',
        description: 'Learn basic concepts and fundamentals',
        subject: topic,
        duration: 60,
        priority: 'high',
        completed: false,
        date: DateTime.now().add(Duration(days: 1)),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
      ),
      StudyTask(
        id: '2',
        title: 'Advanced $topic Concepts',
        description: 'Dive deeper into complex topics',
        subject: topic,
        duration: 90,
        priority: 'medium',
        completed: false,
        date: DateTime.now().add(Duration(days: 2)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 30),
      ),
      StudyTask(
        id: '3',
        title: '$topic Practice Session',
        description: 'Apply what you\'ve learned through exercises',
        subject: topic,
        duration: 120,
        priority: 'medium',
        completed: false,
        date: DateTime.now().add(Duration(days: 3)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
    ];
  }

  void addTask(StudyTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTaskCompletion(String taskId, bool completed) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(completed: completed);
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  List<StudyTask> getTasksForDate(DateTime date) {
    return _tasks
        .where((task) =>
            task.date.year == date.year &&
            task.date.month == date.month &&
            task.date.day == date.day)
        .toList();
  }

  double getCompletionRate() {
    if (_tasks.isEmpty) return 0.0;
    final completedTasks = _tasks.where((task) => task.completed).length;
    return completedTasks / _tasks.length;
  }

  int getTotalStudyTime() {
    return _tasks.fold(0, (sum, task) => sum + task.duration);
  }
}
