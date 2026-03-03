import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/repositories/auth/user_router.dart';
import 'package:task_manager/repositories/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/repositories/models/member.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = FirebaseAuth.instance.currentUser;

            final Member initialMember = Member(
              lvl: 1,
              coins: 0,
              name: getUsername(user),
              email: user?.email,
            );

            return FutureBuilder<Member>(
              future: user != null
                  ? getDetails(user.uid, initialMember)
                  : Future.value(initialMember),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final member = snapshot.data ?? initialMember;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/img/defoult-avatar.png',
                      ),
                    ),
                    const SizedBox(height: 40),

                    Text(
                      member.getName ?? getUsername(user),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'User UID:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    _UidWidget(uid: getUid(user)),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Level: ${member.lvl}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Coins: ${member.coins}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(member.firstName ?? ''),
                            const SizedBox(width: 8),
                            Text(member.secondName ?? ''),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Text('Email: ${member.email ?? 'not set'}'),
                        Text('Birthday: ${member.birthday ?? 'not set'}'),
                      ],
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Add profile details',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const Spacer(),

                    _LogoutButton(
                      isLoading: state is AuthLoading,
                      isAnonymous: user?.isAnonymous ?? false,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ---------------- sub-widgets -----------------------

class _UidWidget extends StatelessWidget {
  final String uid;
  const _UidWidget({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Text(uid, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: uid));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('UID copied to clipboard')),
            );
          },
          child: const Icon(Icons.copy, size: 18, color: Colors.grey),
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final bool isLoading;
  final bool isAnonymous;

  const _LogoutButton({required this.isLoading, required this.isAnonymous});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isAnonymous
          ? () {
              //Get.to(CreateScreen());
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Get.to(UserRouter());
            }
          : () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Get.to(UserRouter());
            },
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(isAnonymous ? 'Create Account' : 'Logout'),
    );
  }
}

String getUsername(User? user) {
  if (user == null) return 'Guest';
  if (user.isAnonymous) return 'Anonymous User';
  return user.displayName ?? user.email?.split('@')[0] ?? 'User';
}

String getUid(User? user) => user?.uid ?? 'Not available';

Future<Member> getDetails(uid, Member currentMember) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  if (documentSnapshot.exists) {
    currentMember.name = documentSnapshot.get('name') ?? currentMember.name;
    currentMember.lvl = documentSnapshot.get('lvl') ?? currentMember.lvl;
    currentMember.coins = documentSnapshot.get('coins') ?? currentMember.coins;
    currentMember.firstName = documentSnapshot.get('first_name');
    currentMember.secondName = documentSnapshot.get('last_name');
    currentMember.email = documentSnapshot.get('email') ?? currentMember.email;

    // Convert Timestamp to String with format DD.MM.YYYY
    final birthdayValue = documentSnapshot.get('BirthDay');
    if (birthdayValue != null) {
      if (birthdayValue is Timestamp) {
        final date = birthdayValue.toDate();
        currentMember.birthday = DateFormat('dd.MM.yyyy').format(date);
      } else {
        currentMember.birthday = birthdayValue.toString();
      }
    }
  }
  return currentMember;
}
