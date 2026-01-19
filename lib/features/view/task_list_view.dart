import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/features/view/add_task_view.dart';
import 'package:gorev_yonetimi/features/viewmodel/task_view_model.dart';
import 'package:gorev_yonetimi/features/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Görevlerim')),
      body: taskViewModel.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Henüz görev eklenmedi',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: taskViewModel.tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(task: taskViewModel.tasks[index]);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
