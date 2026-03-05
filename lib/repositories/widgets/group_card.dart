import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/repositories/bloc/family/family_bloc.dart';
import 'package:task_manager/repositories/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCard extends StatelessWidget {
  final String name;

  const GroupCard({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Card(
      color: Color.fromARGB(255, 35, 61, 133),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [Text(name)],
            );
          },
        ),
      ),
    );
  }

  String getUid(User? user) => user?.uid ?? 'Not available';
}
