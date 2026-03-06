import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/bloc/family/family_bloc.dart';
import 'package:task_manager/models/member.dart';
import 'package:task_manager/repositories/family_repository.dart';
import 'package:task_manager/widgets/add_member_dialog.dart';
import 'package:task_manager/widgets/member_card.dart';
import 'package:task_manager/screens/account/profile_screen.dart';
import 'package:task_manager/screens/group_screen/choose_group_screen.dart';
import 'package:task_manager/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:task_manager/models/group.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.to(SettingsScreen()),
          child: Icon(
            Icons.settings,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: Icon(
                Icons.portrait,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              onTap: () => Get.to(ProfileScreen()),
            ),
          ),
        ],
        title: Center(
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Text(group.name),
                SizedBox(width: 5),
                Icon(Icons.list, color: Colors.purple),
              ],
            ),
            onTap: () => Get.to(ChooseGroupScreen()),
          ),
        ),
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: BlocListener<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is FamilyError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            if (state is FamilyLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is FamilyLoaded) {
              if (state.members.isEmpty) {
                return Center(child: Text('Добавьте первого члена семьи'));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  itemCount: state.members.length,
                  itemBuilder: (context, index) {
                    final member = state.members[index];
                    return MemberCard(
                      key: ValueKey(member.uid),
                      member: member,
                      isAdmin: isAdmin,
                    );
                  },
                ),
              );
            }

            return Center(child: Text('Unknown state'));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(
          context,
        ).floatingActionButtonTheme.backgroundColor,
        onPressed: () => showFormDialog(context),

        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void increaseLvl(BuildContext context, Member member) {
    context.read<FamilyBloc>().add(
      UpdateMember(member.copyWith(lvl: member.lvl + 1)),
    );
  }
}
