// screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/study_task.dart';
import '../providers/study_plan_provider.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<StudyPlanProvider>(
        builder: (context, studyPlan, child) {
          final completionRate = studyPlan.getCompletionRate();
          final totalStudyTime = studyPlan.getTotalStudyTime();
          final totalTasks = studyPlan.tasks.length;
          final completedTasks =
              studyPlan.tasks.where((task) => task.completed).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Productivity Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                    'Completion Rate',
                    '${(completionRate * 100).toStringAsFixed(1)}%',
                    Icons.check_circle,
                    Colors.green,
                  )),
                  SizedBox(width: 8),
                  Expanded(
                      child: _buildStatCard(
                    'Total Study Time',
                    '${(totalStudyTime / 60).toStringAsFixed(1)}h',
                    Icons.timer,
                    Colors.blue,
                  )),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                    'Total Tasks',
                    '$totalTasks',
                    Icons.assignment,
                    Colors.orange,
                  )),
                  SizedBox(width: 8),
                  Expanded(
                      child: _buildStatCard(
                    'Completed',
                    '$completedTasks',
                    Icons.done_all,
                    Colors.purple,
                  )),
                ],
              ),
              SizedBox(height: 20),

              // Priority Distribution
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Priority Distribution',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      _buildPriorityDistribution(studyPlan.tasks),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDistribution(List<StudyTask> tasks) {
    final priorityCounts = {
      'High':
          tasks.where((task) => task.priority.toLowerCase() == 'high').length,
      'Medium':
          tasks.where((task) => task.priority.toLowerCase() == 'medium').length,
      'Low': tasks.where((task) => task.priority.toLowerCase() == 'low').length,
    };

    return Column(
      children: priorityCounts.entries.map((entry) {
        final percentage =
            tasks.isEmpty ? 0 : (entry.value / tasks.length * 100);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  entry.key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 5,
                child: LinearProgressIndicator(
                  value: tasks.isEmpty ? 0 : entry.value / tasks.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                      _getPriorityColor(entry.key.toLowerCase())),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
