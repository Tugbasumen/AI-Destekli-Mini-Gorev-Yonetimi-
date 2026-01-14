import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_view_model.dart';
import '../../core/models/task.dart';
import '../../core/models/task_category.dart';
import 'package:gorev_yonetimi/core/services/deepseek_service.dart';

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

  /// AI Önerisi al fonksiyonu
  Future<void> _getAIRecommendation() async {
    final taskTitle = _controller.text.trim();
    if (taskTitle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Önce görev başlığı girin')));
      return;
    }

    final deepSeek = DeepSeekService(); // LOCAL AI

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final recommendation = await deepSeek.getTaskRecommendation(taskTitle);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('AI Önerisi'),
          content: Text(recommendation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('AI önerisi alınamadı: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Yeni Görev' : 'Görevi Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kategori seçimi
            DropdownButtonFormField<TaskCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TaskCategory.kisisel,
                  child: Text('Kişisel'),
                ),
                DropdownMenuItem(value: TaskCategory.isler, child: Text('İş')),
                DropdownMenuItem(
                  value: TaskCategory.egitim,
                  child: Text('Eğitim'),
                ),
                DropdownMenuItem(
                  value: TaskCategory.saglik,
                  child: Text('Sağlık'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // Görev başlığı
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Görev',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Kaydet / Güncelle
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  if (widget.task == null) {
                    taskViewModel.addTask(text, _selectedCategory);
                  } else {
                    taskViewModel.updateTask(
                      widget.task!.id,
                      text,
                      _selectedCategory,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(widget.task == null ? 'Kaydet' : 'Güncelle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
