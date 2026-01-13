import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';
import 'package:provider/provider.dart';
import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/features/view/add_task_view.dart';
import 'package:gorev_yonetimi/features/viewmodel/task_view_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

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
        // ✅ DONE CHECKBOX
        leading: Checkbox(
          value: task.isDone,
          activeColor: task.category.color,
          onChanged: (_) {
            taskViewModel.toggleTaskDone(task.id);
          },
        ),

        // ✅ BAŞLIK (ÇİZGİ + RENK)
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black,
          ),
        ),

        // ✅ SİL + DÜZENLE
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
