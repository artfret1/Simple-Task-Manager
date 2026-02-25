import 'package:task_manager/repositories/bloc/family_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showFormDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const _AddMemberDialog();
    },
  );
}

class _AddMemberDialog extends StatefulWidget {
  const _AddMemberDialog();

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController lvlController = TextEditingController();
  late final TextEditingController coinsController = TextEditingController();
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateName);
  }

  void _validateName() {
    setState(() {
      _isNameValid = nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    lvlController.dispose();
    coinsController.dispose();
    super.dispose();
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
              'Введите данные нового члена семьи',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
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
            ElevatedButton(
              onPressed: _isNameValid
                  ? () {
                      final newMember = Member(
                        name: nameController.text,
                        lvl: int.tryParse(lvlController.text) ?? 1,
                        coins: int.tryParse(coinsController.text) ?? 0,
                      );
                      context.read<FamilyBloc>().add(AddMember(newMember));

                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
