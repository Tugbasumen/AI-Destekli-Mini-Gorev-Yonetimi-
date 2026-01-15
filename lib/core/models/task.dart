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

  /// Kopyalama metodu
  Task copyWith({String? title, TaskCategory? category, bool? isDone}) {
    return Task(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
    );
  }

  /// Firestore’a kaydetmek için Map’e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.name, // Enum’u string olarak kaydet
      'isDone': isDone,
    };
  }

  /// Firestore’dan gelen veriyi Task objesine dönüştür
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: TaskCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TaskCategory.kisisel,
      ),
      isDone: map['isDone'] ?? false,
    );
  }
}
