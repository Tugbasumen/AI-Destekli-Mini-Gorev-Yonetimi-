import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';
import 'package:provider/provider.dart';

import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/features/view/add_task_view.dart';
import 'package:gorev_yonetimi/features/viewmodel/task_view_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  ///  akıllı öneriler alan ve gösteren metod.
  Future<void> _showAIRecommendation(BuildContext context) async {
    final taskViewModel = context.read<TaskViewModel>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // AI servisine istek atar.
      final suggestion = await taskViewModel.getAIRecommendation(
        task.title,
        task.category.label,
      );

      if (!context.mounted) return;

      Navigator.of(context).pop();
      // Öneriyi  kullanıcıya sunar.
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('AI Önerisi'),
          content: SizedBox(
            width: double.maxFinite,
            height: 220,
            child: SingleChildScrollView(child: Text(suggestion)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      Navigator.of(context).pop();

      final errorMessage = taskViewModel.errorMessage ?? 'AI önerisi alınamadı';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  /// Silme işlemi öncesinde kullanıcıdan onay alan diyalog.
  void _showDeleteConfirm(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Görev Silinsin mi?'),
        content: const Text('Bu görevi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              taskViewModel.deleteTask(task.id);
              Navigator.of(context).pop();
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
        border: Border(left: BorderSide(width: 5, color: task.category.color)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Checkbox(
          value: task.isDone,
          activeColor: task.category.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) => taskViewModel.toggleTaskDone(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
        trailing: PopupMenuButton<_TaskMenuAction>(
          icon: const Icon(Icons.more_vert),
          onSelected: (action) {
            switch (action) {
              case _TaskMenuAction.ai:
                _showAIRecommendation(context);
                break;
              case _TaskMenuAction.edit:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTaskView(task: task)),
                );
                break;
              case _TaskMenuAction.delete:
                _showDeleteConfirm(context);
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _TaskMenuAction.ai,
              child: ListTile(
                leading: Icon(Icons.auto_awesome, color: Colors.amber),
                title: Text('AI önerisi al'),
              ),
            ),
            PopupMenuItem(
              value: _TaskMenuAction.edit,
              child: ListTile(
                leading: Icon(Icons.edit_outlined, color: Colors.blueAccent),
                title: Text('Görevi düzenle'),
              ),
            ),
            PopupMenuItem(
              value: _TaskMenuAction.delete,
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text('Görevi sil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _TaskMenuAction { ai, edit, delete }
