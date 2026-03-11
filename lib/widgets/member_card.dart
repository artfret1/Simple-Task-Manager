import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';
import 'package:task_manager/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/widgets/add_task_dialog.dart';
import 'package:task_manager/widgets/expandable_tasks.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({
    super.key,
    required this.member,
    required this.isAdmin,
    required this.groupId,
  });

  final Member member;
  final bool isAdmin;
  final String groupId;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  static const double collapsedHeight = 20;
  @override
  Widget build(BuildContext context) {
    final groupData =
        widget.member.groups?[widget.groupId] as Map<String, dynamic>?;
    final tasks = groupData?["tasks"] ?? [];
    return Card(
      color: const Color.fromARGB(255, 35, 61, 133),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            bool editing =
                state is FamilyLoaded &&
                state.editingMemberUid == widget.member.uid;
            final lvl = editing
                ? (state.tempLvl ?? 0)
                : (groupData?["lvl"] ?? 0);
            final coins = editing
                ? (state.tempCoins ?? 0)
                : (groupData?["coins"] ?? 0);

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.member.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (widget.isAdmin)
                      GestureDetector(
                        onTap: () {
                          if (editing) {
                            context.read<FamilyBloc>().add(
                              UpdateMember(
                                widget.member.uid,
                                lvl,
                                coins,
                                widget.groupId,
                              ),
                            );
                          } else {
                            context.read<FamilyBloc>().add(
                              SetEditingMember(widget.member.uid),
                            );
                          }
                        },
                        child: Icon(
                          editing ? Icons.done : Icons.edit,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            DecreaseLvl(widget.member.uid, widget.groupId),
                          );
                        },
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                      ),

                    Text("Lvl: $lvl", style: const TextStyle(fontSize: 20)),

                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseLvl(widget.member.uid, widget.groupId),
                          );
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.amber,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            DecreaseCoins(widget.member.uid, widget.groupId),
                          );
                        },
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                      ),

                    Text("Coins: $coins", style: const TextStyle(fontSize: 20)),

                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseCoins(widget.member.uid, widget.groupId),
                          );
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.amber,
                        ),
                      ),
                  ],
                ),

                // ——— Заголовок ———
                if (tasks != null && tasks.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Задачи:",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // ——— Добавить задачу ———
                (widget.isAdmin && editing)
                    ? GestureDetector(
                        onTap: () => showTaskDialog(
                          context,
                          widget.member.uid,
                          widget.groupId,
                        ),
                        child: Row(
                          mainAxisSize: .max,
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              "-----",
                              style: TextStyle(
                                color: Colors.green,
                                letterSpacing: 2.0,
                                fontSize: 20,
                              ),
                            ),
                            Icon(Icons.add_circle, color: Colors.green),
                            Text(
                              "-----",
                              style: TextStyle(
                                color: Colors.green,
                                letterSpacing: 2.0,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                // ——— Нет задач ———
                if (tasks == null || tasks.isEmpty)
                  Container(
                    height: collapsedHeight,
                    alignment: Alignment.center,
                    child: const Text(
                      "Нет задач",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ExpandableTasks(
                  tasks: tasks,
                  isAdmin: widget.isAdmin,
                  editing: editing,
                  uid: widget.member.uid,
                  groupId: widget.groupId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String getUid(User? user) => user?.uid ?? 'Not available';
}
