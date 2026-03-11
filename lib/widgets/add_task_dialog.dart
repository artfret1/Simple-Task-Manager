import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';

void showTaskDialog(BuildContext context, String uid, String groupId) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: _AddTaskDialog(uid: uid, groupId: groupId),
      );
    },
  );
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog({required this.uid, required this.groupId});

  final String uid;
  final String groupId;

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Задача участника:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: _taskController,
                  decoration: InputDecoration(
                    hoverColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<FamilyBloc>().add(
                      AddTask(
                        widget.uid,
                        widget.groupId,
                        _taskController.text.trim(),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
