import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';
import 'package:task_manager/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({super.key, required this.member, required this.isAdmin});

  final Member member;
  final bool isAdmin;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 35, 61, 133),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            bool editing =
                state is FamilyLoaded &&
                state.editingMemberUid == widget.member.uid;

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
                              UpdateMember(widget.member),
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
                            DecreaseLvl(widget.member.uid),
                          );
                        },
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                      ),

                    Text(
                      "Lvl: ${widget.member.lvl}",
                      style: const TextStyle(fontSize: 20),
                    ),

                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseLvl(widget.member.uid),
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
                            DecreaseCoins(widget.member.uid),
                          );
                        },
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                      ),

                    Text(
                      "Coins: ${widget.member.coins}",
                      style: const TextStyle(fontSize: 20),
                    ),

                    if (editing)
                      GestureDetector(
                        onTap: () {
                          context.read<FamilyBloc>().add(
                            IncreaseCoins(widget.member.uid),
                          );
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.amber,
                        ),
                      ),
                  ],
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
