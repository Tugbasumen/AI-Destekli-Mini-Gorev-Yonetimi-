import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';

import '../../core/services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> get tasks => _taskService.getTasks();

  void addTask(String title, TaskCategory category) {
    if (title.trim().isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
    );

    _taskService.addTask(newTask);
    notifyListeners();
  }
}
