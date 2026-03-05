import 'package:task_manager/repositories/bloc/family/family_bloc.dart';
import 'package:task_manager/repositories/widgets/add_member_dialog.dart';
import 'package:task_manager/repositories/widgets/member_card.dart';
import 'package:task_manager/screens/account/profile_screen.dart';
import 'package:task_manager/screens/group_screen/choose_group_screen.dart';
import 'package:task_manager/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:task_manager/repositories/models/group.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  const GroupScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilyBloc()..add(LoadFamily(group.id)),
      child: _GroupView(group: group),
    );
  }
}

class _GroupView extends StatelessWidget {
  const _GroupView({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
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
                      name: member.name,
                      lvl: member.lvl,
                      coins: member.coins,
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
}
