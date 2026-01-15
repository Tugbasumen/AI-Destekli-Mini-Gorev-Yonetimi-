import 'package:gorev_yonetimi/core/errors/app_exceptions.dart';
import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Firestore üzerinden kullanıcı bazlı görev yönetimi
class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException('Kullanıcı oturumu yok');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _userTasksCollection =>
      _firestore.collection('users').doc(_uid).collection('tasks');

  /// Tüm görevleri getir
  Future<List<Task>> getTasks() async {
    try {
      final snapshot = await _userTasksCollection.get();
      return snapshot.docs.map((doc) {
        final data = {
          ...Map<String, dynamic>.from(doc.data() as Map),
          'id': doc.id,
        };
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      throw ApiException('Görevler yüklenirken bir hata oluştu: $e', e);
    }
  }

  /// ID ile görev getir
  Future<Task?> getTaskById(String id) async {
    try {
      final doc = await _userTasksCollection.doc(id).get();
      if (!doc.exists) return null;
      final data = {
        ...Map<String, dynamic>.from(doc.data() as Map),
        'id': doc.id,
      };
      return Task.fromMap(data);
    } catch (e) {
      throw ApiException('Görev getirilemedi: $e', e);
    }
  }

  /// Görev ekle
  Future<void> addTask(Task task) async {
    try {
      final docRef = task.id.isNotEmpty
          ? _userTasksCollection.doc(task.id)
          : _userTasksCollection.doc();
      final exists = await docRef.get();
      if (exists.exists) {
        throw ValidationException('Bu görev zaten mevcut');
      }
      final data = {...task.toMap(), 'id': docRef.id};
      await docRef.set(data);
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw ApiException('Görev eklenirken bir hata oluştu: $e', e);
    }
  }

  /// Görev güncelle
  Future<void> updateTask(
    String id,
    String title,
    TaskCategory category,
  ) async {
    try {
      final doc = _userTasksCollection.doc(id);
      final snapshot = await doc.get();
      if (!snapshot.exists) throw TaskNotFoundException(id);

      await doc.update({'title': title, 'category': category.name});
    } catch (e) {
      if (e is TaskNotFoundException) rethrow;
      throw ApiException('Görev güncellenirken bir hata oluştu: $e', e);
    }
  }

  /// Görev tamamlanma durumunu değiştir
  Future<void> toggleTaskDone(String id) async {
    try {
      final doc = _userTasksCollection.doc(id);
      final snapshot = await doc.get();
      if (!snapshot.exists) throw TaskNotFoundException(id);

      final currentIsDone = (snapshot.data()?['isDone'] as bool?) ?? false;
      await doc.update({'isDone': !currentIsDone});
    } catch (e) {
      if (e is TaskNotFoundException) rethrow;
      throw ApiException('Görev durumu değiştirilirken bir hata oluştu: $e', e);
    }
  }

  /// Görev sil
  Future<void> deleteTask(String id) async {
    try {
      final doc = _userTasksCollection.doc(id);
      final snapshot = await doc.get();
      if (!snapshot.exists) throw TaskNotFoundException(id);

      await doc.delete();
    } catch (e) {
      if (e is TaskNotFoundException) rethrow;
      throw ApiException('Görev silinirken bir hata oluştu: $e', e);
    }
  }

  /// Tüm görevleri sil
  Future<void> clearAllTasks() async {
    try {
      final snapshot = await _userTasksCollection.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw ApiException('Tüm görevler silinirken bir hata oluştu: $e', e);
    }
  }

  /// Kullanıcının görevleri için gerçek zamanlı stream
  Stream<List<Task>> streamTasks() {
    return _userTasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = {
          ...Map<String, dynamic>.from(doc.data() as Map),
          'id': doc.id,
        };
        return Task.fromMap(data);
      }).toList();
    });
  }
}
