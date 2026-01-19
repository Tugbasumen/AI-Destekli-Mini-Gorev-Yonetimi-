import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';
import 'package:gorev_yonetimi/core/services/deepseek_service.dart';
import 'package:gorev_yonetimi/core/services/task_service.dart';

/// Görevlerin listelenmesi, eklenmesi, silinmesi ve AI önerilerinin
/// yönetildiği ana iş mantığı  sınıfı.
class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final DeepSeekService _aiService;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<Task>>? _tasksSubscription;

  TaskViewModel({TaskService? taskService, DeepSeekService? aiService})
    : _taskService = taskService ?? TaskService(),
      _aiService = aiService ?? DeepSeekService() {
    // Listen auth changes and update tasks accordingly
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      // If user logged in, subscribe to their tasks stream
      if (user != null) {
        _subscribeToTasksStream();
      } else {
        // If logged out, clear tasks and cancel subscription
        _tasksSubscription?.cancel();
        _tasks = [];
        notifyListeners();
      }
    });
  }

  void _subscribeToTasksStream() {
    _tasksSubscription?.cancel();
    _tasksSubscription = _taskService.streamTasks().listen(
      (list) {
        _tasks = list;
        notifyListeners();
      },
      onError: (e) {
        _setError(e.toString());
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _tasksSubscription?.cancel();
    super.dispose();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- CRUD İşlemleri (Oluşturma, Okuma, Güncelleme, Silme) ---

  /// Görevleri manuel olarak Firestore'dan çeker.
  Future<void> loadTasks() async {
    _setLoading(true);
    clearError();
    try {
      _tasks = await _taskService.getTasks();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Yeni bir görev ekler.
  Future<void> addTask(String title, TaskCategory category) async {
    // Prevent concurrent adds
    if (_isLoading) return;

    clearError();
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      _setError('Görev başlığı boş olamaz');
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmedTitle,
      category: category,
    );

    _setLoading(true);
    try {
      // Rely on Firestore stream to update the list to avoid duplicates
      await _taskService.addTask(newTask);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Belirli bir görevi siler.
  Future<void> deleteTask(String id) async {
    clearError();
    _setLoading(true);
    try {
      await _taskService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Görev bilgilerini günceller.
  Future<void> updateTask(
    String id,
    String newTitle,
    TaskCategory newCategory,
  ) async {
    clearError();
    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) {
      _setError('Görev başlığı boş olamaz');
      return;
    }

    _setLoading(true);
    try {
      await _taskService.updateTask(id, trimmedTitle, newCategory);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          title: trimmedTitle,
          category: newCategory,
        );
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Görevi tamamlandı/tamamlanmadı olarak işaretler.
  Future<void> toggleTaskDone(String id) async {
    clearError();
    _setLoading(true);
    try {
      await _taskService.toggleTaskDone(id);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// DeepSeek AI kile  göre öneri alır.
  Future<String> getAIRecommendation(String taskTitle, String category) async {
    _setLoading(true);
    clearError();
    try {
      final result = await _aiService.getTaskRecommendation(
        taskTitle,
        category: category,
      );
      return result;
    } catch (e) {
      _setError('AI önerisi alınırken bir hata oluştu: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
