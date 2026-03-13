import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/family_bloc.dart';

// Открывает диалог добавления задачи, передавая контекст участника и группы.
void showTaskDialog(BuildContext context, String uid, String groupId) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      // Передаём уже созданный BLoC, чтобы не терять его состояние.
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
  // Контроллер хранит текст новой задачи до момента отправки.
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
              // Кнопка неактивна, пока поле пустое.
              onPressed: _taskCtrl.text.trim().isEmpty
                  ? null
                  : () {
                      // Передаём задачу в BLoC и закрываем диалог.
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
