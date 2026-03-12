import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/family/bloc/family_bloc.dart';
import 'package:task_manager/features/family/repository/family_repository.dart';
import 'package:task_manager/features/family/widgets/add_member_dialog.dart';
import 'package:task_manager/features/family/widgets/member_card.dart';
import 'package:task_manager/features/family/screens/profile_screen.dart';
import 'package:task_manager/features/groups/screens/choose_group_screen.dart';
import 'package:task_manager/features/groups/screens/rename_group_dialog.dart';
import 'package:task_manager/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/groups/models/group.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  const GroupScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FamilyBloc(context.read<FamilyRepository>())
            ..add(LoadFamily(group.id)),
      child: _GroupView(group: group),
    );
  }
}

class _GroupView extends StatelessWidget {
  const _GroupView({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isAdmin = currentUser?.uid == group.admin;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.to(() => const SettingsScreen()),
          icon: Icon(Icons.settings, color: theme.appBarTheme.iconTheme?.color),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => Get.to(() => const ProfileScreen()),
              icon: Icon(
                Icons.portrait,
                color: theme.appBarTheme.iconTheme?.color,
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: SizedBox(
          width: .maxFinite,
          child: Stack(
            alignment: .center,
            children: [
              GestureDetector(
                onTap: () => Get.to(ChooseGroupScreen()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(group.name),
                    SizedBox(width: 5),
                    const Icon(Icons.list, color: Colors.blueAccent, size: 18),
                  ],
                ),
              ),
              isAdmin
                  ? Positioned(
                      right: MediaQuery.of(context).size.width / 2 + 10,
                      child: GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                        onTap: () =>
                            showRenameFormDialog(context, group.id, group.name),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
      ),

      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FamilyLoaded) {
            if (state.members.isEmpty) {
              return Center(
                child: Text(
                  "Добавьте участника",
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];

                return IntrinsicHeight(
                  child: MemberCard(
                    key: ValueKey(member.uid),
                    member: member,
                    isAdmin: isAdmin,
                    groupId: group.id,
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Unknown state"));
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFormDialog(context),
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
