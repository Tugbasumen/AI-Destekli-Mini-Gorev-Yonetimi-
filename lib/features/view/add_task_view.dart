import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_view_model.dart';
import '../../core/models/task_category.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController _controller = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.kisisel;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Görev'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskCategory>(
              value: _selectedCategory,
              items: TaskCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon, color: category.color, size: 20),
                      const SizedBox(width: 8),
                      Text(category.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Görev',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Görevini yaz',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                label: const Text(
                  'Görevi Kaydet',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;

                  taskViewModel.addTask(
                    _controller.text.trim(),
                    _selectedCategory,
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
