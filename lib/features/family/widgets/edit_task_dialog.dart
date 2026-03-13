import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/family_bloc.dart';

// Открывает диалог управления задачей: удаление или выдача награды участнику.
void showEditTaskDialog(
  BuildContext context,
  String uid,
  String groupId,
  String task,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      // Передаём существующий BLoC, чтобы не создавать новый экземпляр.
      return BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: _EditTaskDialog(uid: uid, groupId: groupId, task: task),
      );
    },
  );
}

class _EditTaskDialog extends StatefulWidget {
  final String uid;
  final String groupId;
  final String task;

  const _EditTaskDialog({
    required this.uid,
    required this.groupId,
    required this.task,
  });

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  final _awardCtrl = TextEditingController();
  // Флаг переключает диалог между режимом действий и режимом ввода награды.
  bool awarding = false;

  ButtonStyle get _dialogButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.grey.withOpacity(0.24),
    disabledBackgroundColor: Colors.grey.withOpacity(0.24),
    foregroundColor: Colors.white,
    disabledForegroundColor: Colors.white70,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    minimumSize: const Size(90, 34),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Задача", style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            Text(widget.task, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),

            if (!awarding) ...[
              ElevatedButton(
                // Удаляем задачу через BLoC без выдачи награды.
                style: _dialogButtonStyle,
                onPressed: () {
                  context.read<FamilyBloc>().add(
                    RemoveTask(widget.uid, widget.groupId, widget.task),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Удалить"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // Переходим в режим ввода количества монет для награды.
                style: _dialogButtonStyle,
                onPressed: () => setState(() => awarding = true),
                child: const Text("Наградить"),
              ),
            ],

            if (awarding) ...[
              TextFormField(
                controller: _awardCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: "Введите награду (coins)",
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: _dialogButtonStyle,
                    onPressed: () => setState(() => awarding = false),
                    child: const Text("Отмена"),
                  ),
                  ElevatedButton(
                    style: _dialogButtonStyle,
                    onPressed: _awardCtrl.text.trim().isEmpty
                        ? null
                        : () {
                            final award = int.tryParse(_awardCtrl.text) ?? 0;

                            final bloc = context.read<FamilyBloc>();

                            // Начисляем монеты, повышаем уровень, удаляем задачу и сохраняем в Firestore.
                            bloc.add(
                              IncreaseManyCoins(
                                widget.uid,
                                widget.groupId,
                                award,
                              ),
                            );
                            bloc.add(IncreaseLvl(widget.uid, widget.groupId));
                            bloc.add(
                              RemoveTask(
                                widget.uid,
                                widget.groupId,
                                widget.task,
                              ),
                            );
                            bloc.add(
                              UpdateMember(widget.uid, 0, 0, widget.groupId),
                            );

                            Navigator.pop(context);
                          },
                    child: const Text("Принять"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
