import 'package:flutter/material.dart';

enum TaskCategory { kisisel, isler, egitim, saglik }

extension TaskCategoryExtension on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.kisisel:
        return 'Kişisel';
      case TaskCategory.isler:
        return 'İş';
      case TaskCategory.egitim:
        return 'Eğitim';
      case TaskCategory.saglik:
        return 'Sağlık';
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.kisisel:
        return Colors.blue;
      case TaskCategory.isler:
        return Colors.orange;
      case TaskCategory.egitim:
        return Colors.green;
      case TaskCategory.saglik:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.kisisel:
        return Icons.person;
      case TaskCategory.isler:
        return Icons.work;
      case TaskCategory.egitim:
        return Icons.school;
      case TaskCategory.saglik:
        return Icons.favorite;
    }
  }
}
