import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';

void showEditTaskDialog(
  BuildContext context,
  String uid,
  String groupId,
  String task,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: _EditTaskDialog(uid: uid, groupId: groupId, task: task),
      );
    },
  );
}

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({
    required this.uid,
    required this.groupId,
    required this.task,
  });

  final String uid;
  final String groupId;
  final String task;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  final _awardController = TextEditingController();
  bool awarding = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Задача участника: ${widget.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            !awarding
                ? ElevatedButton(
                    onPressed: () {
                      context.read<FamilyBloc>().add(
                        RemoveTask(widget.uid, widget.groupId, widget.task),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text('Удалить'),
                  )
                : TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _awardController,
                    keyboardType: TextInputType.number, // Цифровая клавиатура
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Только цифры
                    ],
                    decoration: InputDecoration(
                      hintText: "Введите награду в coins",
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
            !awarding
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        awarding = true;
                      });
                    },
                    child: const Text('Наградить'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        awarding = false;
                      });
                    },
                    child: const Text('Отменить'),
                  ),
            awarding
                ? ElevatedButton(
                    onPressed: () {
                      final award = int.tryParse(_awardController.text);

                      if (award != null) {
                        final bloc = context.read<FamilyBloc>();

                        // Повышаем coins
                        bloc.add(
                          IncreaseManyCoins(widget.uid, widget.groupId, award),
                        );

                        // Повышаем lvl
                        bloc.add(IncreaseLvl(widget.uid, widget.groupId));

                        // Удаляем задачу из Firestore
                        bloc.add(
                          RemoveTask(widget.uid, widget.groupId, widget.task),
                        );

                        // Сохраняем lvl и coins в Firestore
                        bloc.add(
                          UpdateMember(widget.uid, 0, 0, widget.groupId),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Принять'),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
