import 'package:task_manager/features/family/bloc/family_bloc.dart';
import 'package:task_manager/features/family/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/family/widgets/add_task_dialog.dart';
import 'package:task_manager/features/family/widgets/expandable_tasks.dart';

class MemberCard extends StatefulWidget {
  final Member member;
  final bool isAdmin;
  final String groupId;

  const MemberCard({
    super.key,
    required this.member,
    required this.isAdmin,
    required this.groupId,
  });

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final groupData =
        widget.member.groups?[widget.groupId] as Map<String, dynamic>?;

    final tasks = groupData?["tasks"] ?? [];
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 26),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            final editing =
                state is FamilyLoaded &&
                state.editingMemberUid == widget.member.uid;

            final lvl = editing
                ? (state.tempLvl ?? 0)
                : (groupData?["lvl"] ?? 0);

            final coins = editing
                ? (state.tempCoins ?? 0)
                : (groupData?["coins"] ?? 0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------------- NAME + EDIT ICON ----------------
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.member.name,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (widget.isAdmin)
                      GestureDetector(
                        onTap: () async {
                          if (editing) {
                            setState(() => saving = true);

                            final bloc = context.read<FamilyBloc>();

                            bloc.add(
                              UpdateMember(
                                widget.member.uid,
                                lvl,
                                coins,
                                widget.groupId,
                              ),
                            );

                            await Future.doWhile(() async {
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                              final st = bloc.state;
                              return !(st is FamilyLoaded &&
                                  st.editingMemberUid == null);
                            });

                            setState(() => saving = false);
                          } else {
                            context.read<FamilyBloc>().add(
                              SetEditingMember(widget.member.uid),
                            );
                          }
                        },
                        child: saving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                editing ? Icons.done : Icons.edit,
                                color: Colors.blueAccent,
                              ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------------- LEVEL ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (editing)
                      _iconBtn(
                        icon: Icons.remove_circle,
                        color: Colors.redAccent,
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            DecreaseLvl(widget.member.uid, widget.groupId),
                          );
                        },
                      ),
                    Text("Lvl: $lvl", style: theme.textTheme.bodyLarge),
                    if (editing)
                      _iconBtn(
                        icon: Icons.add_circle,
                        color: Colors.amber,
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseLvl(widget.member.uid, widget.groupId),
                          );
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                // ---------------- COINS ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (editing)
                      _iconBtn(
                        icon: Icons.remove_circle,
                        color: Colors.redAccent,
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            DecreaseCoins(widget.member.uid, widget.groupId),
                          );
                        },
                      ),

                    Text("Coins: $coins", style: theme.textTheme.bodyLarge),

                    if (editing)
                      _iconBtn(
                        icon: Icons.add_circle,
                        color: Colors.amber,
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseCoins(widget.member.uid, widget.groupId),
                          );
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                // ---------------- TASKS HEADER ----------------
                if (tasks != null && tasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Задачи:",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // ---------------- ADD TASK ----------------
                if (editing && widget.isAdmin)
                  GestureDetector(
                    onTap: () => showTaskDialog(
                      context,
                      widget.member.uid,
                      widget.groupId,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("-----", style: TextStyle(color: Colors.green)),
                          Icon(Icons.add_circle, color: Colors.green),
                          Text("-----", style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ),

                if (tasks == null || tasks.isEmpty) const SizedBox(height: 8),

                // ---------------- TASKS LIST ----------------
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

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color),
    );
  }
}
