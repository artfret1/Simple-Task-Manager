import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/family/bloc/family_bloc.dart';

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
  bool awarding = false;

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
                    onPressed: () => setState(() => awarding = false),
                    child: const Text("Отмена"),
                  ),
                  ElevatedButton(
                    onPressed: _awardCtrl.text.trim().isEmpty
                        ? null
                        : () {
                            final award = int.tryParse(_awardCtrl.text) ?? 0;

                            final bloc = context.read<FamilyBloc>();

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
