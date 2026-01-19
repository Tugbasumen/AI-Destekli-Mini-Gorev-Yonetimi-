import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';
import 'package:gorev_yonetimi/core/services/deepseek_service.dart';
import 'package:gorev_yonetimi/features/view/add_task_view.dart';
import 'package:gorev_yonetimi/features/viewmodel/task_view_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();
    final deepSeek = DeepSeekService();

    Future<void> _showAIRecommendation() async {
      /// Loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final suggestion = await deepSeek.getTaskRecommendation(
          task.title,
          category: task.category.label,
        );

        if (!context.mounted) return;

        Navigator.of(context).pop(); // loading kapat

        /// Sonuç dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('AI Önerisi'),
            content: SizedBox(
              width: double.maxFinite,
              height: 240,
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
      } catch (e) {
        if (!context.mounted) return;

        Navigator.of(context).pop(); // loading kapat

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('AI önerisi alınamadı: $e')));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
        border: Border(left: BorderSide(width: 5, color: task.category.color)),
      ),
      child: ListTile(
        onTap: _showAIRecommendation,

        /// Checkbox
        leading: Checkbox(
          value: task.isDone,
          activeColor: task.category.color,
          onChanged: (_) {
            taskViewModel.toggleTaskDone(task.id);
          },
        ),

        /// Başlık
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black,
          ),
        ),

        /// Aksiyonlar (AI - Sil - Düzenle)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline, color: Colors.amber),
              tooltip: 'AI önerisi al',
              onPressed: _showAIRecommendation,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                taskViewModel.deleteTask(task.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTaskView(task: task)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
