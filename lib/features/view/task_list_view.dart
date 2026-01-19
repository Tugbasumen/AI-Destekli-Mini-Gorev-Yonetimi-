import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gorev_yonetimi/features/view/add_task_view.dart';
import 'package:gorev_yonetimi/features/viewmodel/task_view_model.dart';
import 'package:gorev_yonetimi/features/viewmodel/auth_view_model.dart';
import 'package:gorev_yonetimi/features/widgets/task_tile.dart';

/// Kullanıcının tüm görevlerini listeleyen ana görünüm ekranı.
class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  /// Çıkış  işlemi
  Future<void> _handleLogout(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Vazgeç
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Onayla
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await authViewModel.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Center(child: const Text('Görevlerim')),
        actions: [
          if (user != null)
            Padding(padding: const EdgeInsets.only(right: 8), child: Center()),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      // Görev listesi boşsa bir uyarı mesajı, doluysa listeyi gösterir.
      body: taskViewModel.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
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

      // Yeni görev ekleme ekranına yönlendiren yüzen buton.
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
