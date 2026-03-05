import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/auth/user_router.dart';
import 'package:task_manager/bloc/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/member.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;

  final _emailController = TextEditingController();

  final _firstNameController = TextEditingController();

  final _secondNameController = TextEditingController();

  final _birthdayController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  /// сравнивает контроллеры с данными и сохраняет только изменённые поля
  Future<void> _saveProfileChanges(Member member) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final updates = <String, dynamic>{};

    if (_firstNameController.text.isNotEmpty &&
        _firstNameController.text != member.firstName) {
      updates['first_name'] = _firstNameController.text;
    }
    if (_secondNameController.text.isNotEmpty &&
        _secondNameController.text != member.secondName) {
      updates['last_name'] = _secondNameController.text;
    }
    if (_emailController.text.isNotEmpty &&
        _emailController.text != member.email) {
      updates['email'] = _emailController.text;
    }
    if (_birthdayController.text.isNotEmpty &&
        _birthdayController.text != member.birthday) {
      updates['BirthDay'] = _birthdayController.text;
    }

    if (updates.isNotEmpty) {
      await docRef.update(updates);
    }

    setState(() {
      _editing = false;
      _emailController.clear();
      _firstNameController.clear();
      _secondNameController.clear();
      _birthdayController.clear();
    });
  }

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
              uid: getUid(user),
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
                      initialMember.name,
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

                    !_editing
                        ? Column(
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
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your first name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              TextFormField(
                                controller: _secondNameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your last name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _birthdayController,
                                decoration: InputDecoration(
                                  hintText: 'Choose your birthday',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _birthdayController.text = DateFormat(
                                        'dd.MM.yyyy',
                                      ).format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),

                    const SizedBox(height: 20),
                    !_editing
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _editing = true;
                                _emailController.text = member.email ?? '';
                                _firstNameController.text =
                                    member.firstName ?? '';
                                _secondNameController.text =
                                    member.secondName ?? '';
                                _birthdayController.text =
                                    member.birthday ?? '';
                              });
                            },
                            child: Text(
                              'Edit profile details',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editing = false;
                                    _emailController.clear();
                                    _firstNameController.clear();
                                    _secondNameController.clear();
                                    _birthdayController.clear();
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () async {
                                  await _saveProfileChanges(member);
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
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
