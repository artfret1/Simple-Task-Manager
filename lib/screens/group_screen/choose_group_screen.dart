import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:task_manager/bloc/groups/group_bloc.dart';
import 'package:task_manager/widgets/add_group_dialog.dart';
import 'package:task_manager/widgets/group_card.dart';
import 'package:task_manager/screens/account/profile_screen.dart';
import 'package:task_manager/screens/settings/settings_screen.dart';

class ChooseGroupScreen extends StatefulWidget {
  const ChooseGroupScreen({super.key});

  @override
  State<ChooseGroupScreen> createState() => _ChooseGroupScreenState();
}

class _ChooseGroupScreenState extends State<ChooseGroupScreen> {
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
        title: Center(child: Text('Группы')),
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupsInitial) {
              context.read<GroupBloc>().add(LoadGroups());
              return Center(child: CircularProgressIndicator());
            }

            if (state is GroupsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is GroupsLoaded) {
              if (state.groups.isEmpty) {
                return Center(child: Text('Создайте свою первую группу'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return GroupCard(group: group);
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
        onPressed: () => showGroupFormDialog(context),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
