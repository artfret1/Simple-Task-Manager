import 'package:flutter/material.dart';
import 'edit_task_dialog.dart';

class ExpandableTasks extends StatefulWidget {
  final List<dynamic>? tasks;
  final bool isAdmin;
  final bool editing;
  final String uid;
  final String groupId;

  const ExpandableTasks({
    super.key,
    required this.tasks,
    required this.isAdmin,
    required this.editing,
    required this.uid,
    required this.groupId,
  });

  @override
  State<ExpandableTasks> createState() => _ExpandableTasksState();
}

class _ExpandableTasksState extends State<ExpandableTasks> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;

    if (tasks == null || tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text("Нет задач", style: TextStyle(color: Colors.white70)),
      );
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(maxHeight: expanded ? 260 : 24),
          child: ClipRRect(
            child: SingleChildScrollView(
              physics: expanded
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Column(
                children: tasks.reversed.map((task) {
                  return GestureDetector(
                    onTap: () => showEditTaskDialog(
                      context,
                      widget.uid,
                      widget.groupId,
                      task,
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "$task",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        GestureDetector(
          onTap: () => setState(() => expanded = !expanded),
          child: Text(
            expanded ? "Скрыть" : "Подробнее",
            style: const TextStyle(
              color: Colors.white70,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
