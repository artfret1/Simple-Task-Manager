import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_bloc.dart';

void showRenameFormDialog(
  BuildContext context,
  String groupId,
  String oldName,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<GroupBloc>(),
        child: _RenameGroupDialog(groupId: groupId, oldName: oldName),
      );
    },
  );
}

class _RenameGroupDialog extends StatefulWidget {
  final String groupId;
  final String oldName;

  const _RenameGroupDialog({required this.groupId, required this.oldName});

  @override
  State<_RenameGroupDialog> createState() => _RenameGroupDialogState();
}

class _RenameGroupDialogState extends State<_RenameGroupDialog> {
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Переименовать группу", style: theme.textTheme.labelMedium),
            const SizedBox(height: 20),

            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(hintText: widget.oldName),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _nameCtrl.text.trim().isEmpty
                  ? null
                  : () {
                      context.read<GroupBloc>().add(
                        RenameGroup(widget.groupId, _nameCtrl.text.trim()),
                      );
                      Navigator.pop(context);
                    },
              child: const Text("Переименовать"),
            ),
          ],
        ),
      ),
    );
  }
}
