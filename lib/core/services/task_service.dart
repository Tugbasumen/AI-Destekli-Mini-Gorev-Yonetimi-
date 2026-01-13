import 'package:gorev_yonetimi/core/models/task_category.dart';

import '../models/task.dart';

class TaskService {
  final List<Task> _tasks = [];

  List<Task> getTasks() {
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  void updateTask({
    required String id,
    required String title,
    required TaskCategory category,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(title: title, category: category);
  }

  void toggleTaskDone(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    }
  }
}
