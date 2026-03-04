import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repositories/bloc/family_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';
import 'package:task_manager/screens/account/profile_screen.dart';

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
  final _uidController = TextEditingController();
  bool _uidFinding = false;
  bool _nameFinding = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
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
                        onPressed: () async {
                          // Получаем Member из Firestore
                          final member = await getDocumentData(
                            "users",
                            _uidController.text.trim(),
                          );

                          if (member == null) {
                            // Если пользователь не найден — показываем сообщение
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Пользователь не найден"),
                              ),
                            );
                            return;
                          }

                          // Если найден — добавляем в BLoC
                          context.read<FamilyBloc>().add(AddMember(member));

                          Navigator.pop(context);
                        },
                        child: const Text('Найти'),
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

  Future<Member?> getDocumentData(
    String collectionName,
    String documentId,
  ) async {
    final docRef = db.collection(collectionName).doc(documentId);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      return Member(
        uid: documentId,
        lvl: docSnap["lvl"],
        coins: docSnap["coins"],
        name: docSnap["name"],
      );
    } else {
      return null;
    }
  }
}
