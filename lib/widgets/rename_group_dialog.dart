import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/groups/group_bloc.dart';

void showRenameFormDialog(BuildContext context, groupId, oldName) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<GroupBloc>(),
        child: _RenameGroupDialog(groupId: groupId, oldName: oldName),
      );
    },
  );
}

class _RenameGroupDialog extends StatefulWidget {
  const _RenameGroupDialog({required this.groupId, required this.oldName});

  final String groupId;
  final String oldName;

  @override
  State<_RenameGroupDialog> createState() => _RenameGroupDialogState();
}

class _RenameGroupDialogState extends State<_RenameGroupDialog> {
  final _nameController = TextEditingController();
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
              'Введите новое название группы',
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    hoverColor: Colors.black,
                    hintText: widget.oldName,
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
                    context.read<GroupBloc>().add(
                      RenameGroup(widget.groupId, _nameController.text.trim()),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Переименовать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
