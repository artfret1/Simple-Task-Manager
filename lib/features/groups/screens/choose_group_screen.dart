import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/group_bloc.dart';
import 'add_group_dialog.dart';
import '../widgets/group_card.dart';
import '../../family/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';

class ChooseGroupScreen extends StatefulWidget {
  const ChooseGroupScreen({super.key});

  @override
  State<ChooseGroupScreen> createState() => _ChooseGroupScreenState();
}

class _ChooseGroupScreenState extends State<ChooseGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Навигация в настройки и профиль вынесена в боковые иконки шапки.
        leading: GestureDetector(
          onTap: () => Get.to(SettingsScreen()),
          child: Icon(
            Icons.settings,
            color: theme.appBarTheme.iconTheme?.color,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.to(ProfileScreen()),
              child: Icon(
                Icons.portrait,
                color: theme.appBarTheme.iconTheme?.color,
              ),
            ),
          ),
        ],
        title: const Text('Группы'),
        centerTitle: true,
      ),

      // Слой BlocListener перехватывает ошибки и показывает их через snackbar.
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
            // Запускаем загрузку при первом рендере, пока данных ещё нет.
            if (state is GroupsInitial) {
              context.read<GroupBloc>().add(LoadGroups());
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroupsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroupsLoaded) {
              // Пустой список — подсказка создать первую группу.
              if (state.groups.isEmpty) {
                return Center(
                  child: Text(
                    'Создайте свою первую группу',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return GroupCard(group: group);
                },
              );
            }

            return const Center(child: Text('Unknown state'));
          },
        ),
      ),

      // FAB открывает диалог создания новой группы.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showGroupFormDialog(context),
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
