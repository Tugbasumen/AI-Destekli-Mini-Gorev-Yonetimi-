import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gorev_yonetimi/core/models/task.dart';
import 'package:gorev_yonetimi/core/models/task_category.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
        leading: CircleAvatar(
          backgroundColor: task.category.color.withOpacity(0.15),
          child: Icon(task.category.icon, color: task.category.color),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
