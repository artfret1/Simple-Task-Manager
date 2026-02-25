import 'package:task_manager/repositories/bloc/family_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showEditMemberDialog(BuildContext context, Member member) {
  showDialog(
    context: context,
    builder: (context) {
      return _EditMemberDialog(member: member);
    },
  );
}

class _EditMemberDialog extends StatefulWidget {
  final Member member;

  const _EditMemberDialog({required this.member});

  @override
  State<_EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<_EditMemberDialog> {
  late final TextEditingController nameController = TextEditingController(
    text: widget.member.name,
  );
  late final TextEditingController lvlController = TextEditingController(
    text: widget.member.lvl.toString(),
  );
  late final TextEditingController coinsController = TextEditingController(
    text: widget.member.coins.toString(),
  );

  @override
  void dispose() {
    nameController.dispose();
    lvlController.dispose();
    coinsController.dispose();
    super.dispose();
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: const Text(
          'Вы уверены, что хотите сохранить изменения?',
          style: TextStyle(color: Colors.black),
        ),
        actionsPadding: EdgeInsets.all(16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена', style: TextStyle(fontSize: 24)),
              ),
              TextButton(
                onPressed: () {
                  final updatedMember = Member(
                    name: nameController.text,
                    lvl: int.tryParse(lvlController.text) ?? widget.member.lvl,
                    coins:
                        int.tryParse(coinsController.text) ??
                        widget.member.coins,
                  );
                  context.read<FamilyBloc>().add(
                    UpdateMember(widget.member.name, updatedMember),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Сохранить', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: const Text(
          'Вы уверены, что хотите удалить этого члена семьи? Это действие нельзя отменить.',
          style: TextStyle(color: Colors.black),
        ),
        actionsPadding: EdgeInsets.all(16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена', style: TextStyle(fontSize: 24)),
              ),
              TextButton(
                onPressed: () {
                  context.read<FamilyBloc>().add(
                    DeleteMember(widget.member.name),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Удалить', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
              'Редактировать члена семьи',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(hintText: 'Имя'),
            ),
            TextField(
              controller: lvlController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(hintText: 'Уровень'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: coinsController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(hintText: 'Монеты'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showSaveConfirmation,
                  child: Icon(Icons.check),
                ),
                ElevatedButton(
                  onPressed: _showDeleteConfirmation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
