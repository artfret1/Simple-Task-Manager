import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_bloc.dart';

void showGroupFormDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<GroupBloc>(),
        child: const _AddGroupDialog(),
      );
    },
  );
}

class _AddGroupDialog extends StatefulWidget {
  const _AddGroupDialog();

  @override
  State<_AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<_AddGroupDialog> {
  final _nameController = TextEditingController();
  bool get _isValid => _nameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Введите название новой группы',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Text field
            TextFormField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: 'Моя группа'),
            ),

            const SizedBox(height: 20),

            // Add button
            ElevatedButton(
              onPressed: _isValid
                  ? () {
                      context.read<GroupBloc>().add(
                        AddGroup(_nameController.text.trim()),
                      );

                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
