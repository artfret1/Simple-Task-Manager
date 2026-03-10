import 'package:flutter/material.dart';

class ExpandableTasks extends StatefulWidget {
  final List<dynamic>? tasks;

  const ExpandableTasks({super.key, required this.tasks});

  @override
  State<ExpandableTasks> createState() => _ExpandableTasksState();
}

class _ExpandableTasksState extends State<ExpandableTasks> {
  bool expanded = false;

  static const double collapsedHeight = 20;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ——— Заголовок ———
          if (tasks != null && tasks.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "Задачи:",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // ——— Нет задач ———
          if (tasks == null || tasks.isEmpty)
            Container(
              height: collapsedHeight,
              alignment: Alignment.center,
              child: const Text(
                "Нет задач",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

          // ——— Список задач ———
          if (tasks != null && tasks.isNotEmpty)
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  constraints: BoxConstraints(
                    maxHeight: expanded ? 300 : collapsedHeight,
                  ),
                  child: SingleChildScrollView(
                    physics: expanded
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: tasks.map((task) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$task",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ——— Кнопка Подробнее ———
                GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      expanded ? "Скрыть" : "Подробнее",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
