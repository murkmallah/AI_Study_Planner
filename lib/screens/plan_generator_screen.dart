// screens/plan_generator_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/study_plan_provider.dart';
import '../services/notification_service.dart'; // ADD THIS IMPORT

class PlanGeneratorScreen extends StatefulWidget {
  @override
  _PlanGeneratorScreenState createState() => _PlanGeneratorScreenState();
}

class _PlanGeneratorScreenState extends State<PlanGeneratorScreen> {
  final _topicController = TextEditingController();
  String _selectedDuration = '1 week';
  String _selectedDifficulty = 'Beginner';

  final List<String> _durations = ['3 days', '1 week', '2 weeks', '1 month'];
  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Generate Your Study Plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _topicController,
            decoration: InputDecoration(
              labelText: 'Study Topic/Subject',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedDuration,
            decoration: InputDecoration(
              labelText: 'Study Duration',
              border: OutlineInputBorder(),
            ),
            items: _durations.map((duration) {
              return DropdownMenuItem(
                value: duration,
                child: Text(duration),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDuration = value!;
              });
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedDifficulty,
            decoration: InputDecoration(
              labelText: 'Difficulty Level',
              border: OutlineInputBorder(),
            ),
            items: _difficulties.map((difficulty) {
              return DropdownMenuItem(
                value: difficulty,
                child: Text(difficulty),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDifficulty = value!;
              });
            },
          ),
          SizedBox(height: 24),
          Consumer<StudyPlanProvider>(
            builder: (context, studyPlan, child) {
              if (studyPlan.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_topicController.text.isNotEmpty) {
                        try {
                          await studyPlan.generateStudyPlan(
                            _topicController.text,
                            _selectedDuration,
                            _selectedDifficulty,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Study plan generated successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Generate AI Study Plan',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10), // ADD SPACING
                  // ADD THE TEST NOTIFICATION BUTTON HERE
                  ElevatedButton(
                    onPressed: () {
                      if (_topicController.text.isNotEmpty) {
                        NotificationService().showNotification(
                          'Study Reminder',
                          'Time to study ${_topicController.text}',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notification sent!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please enter a study topic first')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Test Notification',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: Consumer<StudyPlanProvider>(
              builder: (context, studyPlan, child) {
                if (studyPlan.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No study plan generated yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: studyPlan.tasks.length,
                  itemBuilder: (context, index) {
                    final task = studyPlan.tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (value) {
                            studyPlan.updateTaskCompletion(task.id, value!);
                          },
                        ),
                        title: Text(task.title),
                        subtitle: Text(
                          '${_formatDate(task.date)} • ${task.startTime.format(context)} - ${task.endTime.format(context)}',
                        ),
                        trailing: Icon(
                          _getPriorityIcon(task.priority),
                          color: _getPriorityColor(task.priority),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.low_priority;
      default:
        return Icons.circle;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
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
