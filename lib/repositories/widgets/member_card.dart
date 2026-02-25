import 'package:task_manager/repositories/bloc/family_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';
import 'package:task_manager/repositories/widgets/edit_member_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.name,
    required this.lvl,
    required this.coins,
  });

  final String name;
  final int lvl;
  final int coins;
  @override
  Widget build(BuildContext context) {
    final member = Member(name: name, lvl: lvl, coins: coins);
    return Card(
      color: Color.fromARGB(255, 35, 61, 133),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            final editing =
                state is FamilyLoaded && state.editingMember == name;
            return Column(
              spacing: 20,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          editing
                              ? GestureDetector(
                                  onTap: () =>
                                      showEditMemberDialog(context, member),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<FamilyBloc>().add(
                        SetEditingMember(name),
                      ),
                      child: !editing
                          ? Icon(
                              Icons.edit_note,
                              size: 20,
                              color: Colors.white70,
                            )
                          : Icon(Icons.done, size: 20, color: Colors.white70),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    editing
                        ? GestureDetector(
                            onTap: () {
                              context.read<FamilyBloc>().add(DecreaseLvl(name));
                            },
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                          )
                        : Container(),
                    Text('Lvl: $lvl', style: TextStyle(fontSize: 20)),
                    editing
                        ? GestureDetector(
                            onTap: () {
                              context.read<FamilyBloc>().add(IncreaseLvl(name));
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 20,
                              color: Colors.amber,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    editing
                        ? GestureDetector(
                            onTap: () {
                              context.read<FamilyBloc>().add(
                                DecreaseCoins(name),
                              );
                            },
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                          )
                        : Container(),
                    Text('Coins: $coins', style: TextStyle(fontSize: 20)),
                    editing
                        ? GestureDetector(
                            onTap: () {
                              context.read<FamilyBloc>().add(
                                IncreaseCoins(name),
                              );
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 20,
                              color: Colors.amber,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
