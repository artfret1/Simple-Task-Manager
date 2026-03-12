import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/family/bloc/family_bloc.dart';

void showTaskDialog(BuildContext context, String uid, String groupId) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: _AddTaskDialog(uid: uid, groupId: groupId),
      );
    },
  );
}

class _AddTaskDialog extends StatefulWidget {
  final String uid;
  final String groupId;

  const _AddTaskDialog({required this.uid, required this.groupId});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _taskCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Новая задача", style: theme.textTheme.labelMedium),
            const SizedBox(height: 16),

            TextFormField(
              controller: _taskCtrl,
              decoration: const InputDecoration(hintText: "Введите задачу"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _taskCtrl.text.trim().isEmpty
                  ? null
                  : () {
                      context.read<FamilyBloc>().add(
                        AddTask(
                          widget.uid,
                          widget.groupId,
                          _taskCtrl.text.trim(),
                        ),
                      );
                      Navigator.pop(context);
                    },
              child: const Text("Добавить"),
            ),
          ],
        ),
      ),
    );
  }
}
