import 'task_category.dart';

class Task {
  final String id;
  final String title;
  final TaskCategory category;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}
