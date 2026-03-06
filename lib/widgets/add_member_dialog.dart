import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';

void showFormDialog(BuildContext context) {
  showDialog(
    context: context,
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
  final bool _nameFinding = false;
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
              'Найдите члена своей группы!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            (!_uidFinding && !_nameFinding)
                ? Column(
                    children: [
                      GestureDetector(
                        child: Text(
                          "Найти по UID",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _uidFinding = !_uidFinding;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        child: Text(
                          "Найти по имени/нику",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  )
                : _uidFinding
                ? Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: _uidController,
                        decoration: InputDecoration(
                          hoverColor: Colors.black,
                          hintText: 'Вставьте UID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.paste),
                            onPressed: () async {
                              final data = await Clipboard.getData(
                                Clipboard.kTextPlain,
                              );
                              if (data?.text != null) {
                                setState(() {
                                  _uidController.text = data!.text!;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<FamilyBloc>().add(
                            AddMemberByUid(_uidController.text.trim()),
                          );

                          Navigator.pop(context);
                        },
                        child: const Text('Добавить'),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _uidFinding = !_uidFinding;
                        }),
                        child: Text(
                          "Отмена",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                : _nameFinding
                ? TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Введите имя/никнейм',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  )
                : SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
