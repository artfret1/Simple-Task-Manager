import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/family/bloc/family_bloc.dart';

void showFormDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: const _AddMemberDialog(),
      );
    },
  );
}

class _AddMemberDialog extends StatefulWidget {
  const _AddMemberDialog();

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _uidController = TextEditingController();
  bool _uidFinding = false;
  bool _nameFinding = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Добавить участника', style: theme.textTheme.labelMedium),
            const SizedBox(height: 20),

            // ПЕРВЫЙ ЭКРАН — выбор метода поиска
            if (!_uidFinding && !_nameFinding)
              Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _uidFinding = true),
                    child: Text(
                      "Найти по UID",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() => _nameFinding = true);
                    },
                    child: Text(
                      "Найти по имени",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

            // ------------------------- ПОИСК ПО UID -------------------------
            if (_uidFinding)
              Column(
                children: [
                  TextFormField(
                    controller: _uidController,
                    decoration: const InputDecoration(
                      hintText: "Вставьте UID",
                      suffixIcon: Icon(Icons.paste),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _uidController.text.trim().isEmpty
                        ? null
                        : () {
                            context.read<FamilyBloc>().add(
                              AddMemberByUid(_uidController.text.trim()),
                            );

                            Navigator.pop(context);
                          },
                    child: const Text("Добавить"),
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => _uidFinding = false),
                    child: Text("Назад", style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),

            // ------------------------- ПОИСК ПО ИМЕНИ -------------------------
            if (_nameFinding)
              Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Введите имя"),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: null,
                    child: const Text("Поиск недоступен"),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => _nameFinding = false),
                    child: Text("Назад", style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
