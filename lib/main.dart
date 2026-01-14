import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'features/view/task_list_view.dart';
import 'features/viewmodel/task_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Task Manager',
        theme: AppTheme.lightTheme,
        home: const TaskListView(),
      ),
    );
  }
}
