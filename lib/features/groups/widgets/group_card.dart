import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/group.dart';
import '../../family/screens/group_screen.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.to(() => GroupScreen(group: group)),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 28),
          alignment: Alignment.center,
          child: Text(
            group.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
