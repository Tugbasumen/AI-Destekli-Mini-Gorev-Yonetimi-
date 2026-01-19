import 'task_category.dart';

class Task {
  final String id;
  final String title;
  final TaskCategory category;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.category,
    this.isDone = false,
  });

  Task copyWith({String? title, TaskCategory? category, bool? isDone}) {
    return Task(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
    );
  }
}
