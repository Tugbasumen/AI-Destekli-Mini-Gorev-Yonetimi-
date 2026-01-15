import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/task_view_model.dart';
import '../../core/models/task.dart';
import '../../core/models/task_category.dart';
import '../../core/theme/app_theme.dart';

/// Yeni bir görev eklemek veya mevcut bir görevi düzenlemek için kullanılan ekran.
class AddTaskView extends StatefulWidget {
  final Task? task; // Düzenleme için

  const AddTaskView({super.key, this.task});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController _controller = TextEditingController();
  late TaskCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.task?.title ?? '';
    _selectedCategory = widget.task?.category ?? TaskCategory.kisisel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.task == null ? 'Yeni Görev' : 'Görevi Düzenle'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori seçimi
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // Kategori Dropdown Menüsü
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButton<TaskCategory>(
                value: _selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: TaskCategory.values.map((category) {
                  return DropdownMenuItem<TaskCategory>(
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
                onChanged: (category) {
                  if (category != null) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Görev başlığı
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Görev Başlığı',
                hintText: 'Örn: Proje sunumunu hazırla',
              ),
              maxLines: 3,
              autofocus: widget.task == null,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // Kaydet / Güncelle Butonu
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: taskViewModel.isLoading
              ? null
              : () async {
                  final text = _controller.text.trim();

                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen görev başlığı girin'),
                      ),
                    );
                    return;
                  }

                  if (widget.task == null) {
                    await taskViewModel.addTask(text, _selectedCategory);
                  } else {
                    await taskViewModel.updateTask(
                      widget.task!.id,
                      text,
                      _selectedCategory,
                    );
                  }

                  if (!mounted) return;

                  final errorMsg = taskViewModel.errorMessage;
                  if (errorMsg != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                },
          label: Text(widget.task == null ? 'Görevi Kaydet' : 'Güncelle'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
