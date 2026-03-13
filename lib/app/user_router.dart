import 'package:task_manager/features/auth/screens/auth_screen.dart';
import 'package:task_manager/features/groups/screens/choose_group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRouter extends StatelessWidget {
  const UserRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ChooseGroupScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
