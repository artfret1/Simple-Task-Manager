import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/app/user_router.dart';
import 'package:task_manager/features/auth/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/family/models/member.dart';
import 'dart:ui';

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
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 19, 33, 70), Color(0xFF0A1226)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = FirebaseAuth.instance.currentUser;

                  final Member initialMember = Member(
                    uid: getUid(user),
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
                          // ---------------- Avatar ----------------
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                backgroundImage: const AssetImage(
                                  'assets/img/defoult-avatar.png',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            initialMember.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'User UID:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          _UidWidget(uid: getUid(user)),
                          const SizedBox(height: 20),

                          // ---------------- Profile Info ----------------
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (!_editing) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            member.firstName ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            member.secondName ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Email: ${member.email ?? 'not set'}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        'Birthday: ${member.birthday ?? 'not set'}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ] else ...[
                                      _buildTextField(
                                        'First name',
                                        _firstNameController,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildTextField(
                                        'Last name',
                                        _secondNameController,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildTextField(
                                        'Email',
                                        _emailController,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildTextField(
                                        'Birthday',
                                        _birthdayController,
                                        readOnly: true,
                                        onTap: _pickBirthday,
                                      ),
                                    ],
                                    const SizedBox(height: 24),
                                    !_editing
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _editing = true;
                                                _emailController.text =
                                                    member.email ?? '';
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
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _editing = false;
                                                    _emailController.clear();
                                                    _firstNameController
                                                        .clear();
                                                    _secondNameController
                                                        .clear();
                                                    _birthdayController.clear();
                                                  });
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: theme
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color:
                                                            Colors.blueAccent,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 24),
                                              GestureDetector(
                                                onTap: () async {
                                                  await _saveProfileChanges(
                                                    member,
                                                  );
                                                },
                                                child: Text(
                                                  'Save',
                                                  style: theme
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color:
                                                            Colors.blueAccent,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Future<void> _pickBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
      });
    }
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
        Flexible(
          child: Text(
            uid,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
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
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(AuthLogoutRequested());
        Get.to(UserRouter());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              isAnonymous ? 'Create Account' : 'Logout',
              style: theme.textTheme.labelMedium,
            ),
    );
  }
}

String getUsername(User? user) {
  if (user == null) return 'Guest';
  if (user.isAnonymous) return 'Anonymous User';
  return user.displayName ?? user.email?.split('@')[0] ?? 'User';
}

String getUid(User? user) => user?.uid ?? 'Not available';

Future<Member> getDetails(String uid, Member currentMember) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  if (documentSnapshot.exists) {
    currentMember.name = documentSnapshot.get('name') ?? currentMember.name;
    currentMember.firstName = documentSnapshot.get('first_name');
    currentMember.secondName = documentSnapshot.get('last_name');
    currentMember.email = documentSnapshot.get('email') ?? currentMember.email;

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
