import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/screens/group_screen/group_screen.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GroupScreen(group: group));
      },
      child: Card(
        color: const Color.fromARGB(255, 35, 61, 133),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                group.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
