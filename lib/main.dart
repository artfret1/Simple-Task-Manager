import 'package:cloud_firestore/cloud_firestore.dart';
import 'app/user_router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/groups/bloc/group_bloc.dart';
import 'features/family/repository/family_repository.dart';
import 'features/groups/repository/group_repository.dart';
import 'app/firebase_options.dart';
import 'app/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => GroupRepository(firestore)),
        Provider(create: (_) => FamilyRepository(firestore)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GroupBloc(context.read<GroupRepository>()),
          ),
          BlocProvider(create: (_) => AuthBloc(FirebaseAuth.instance)),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GetMaterialApp(
      theme: themeProvider.currentTheme.toThemeData(),
      home: UserRouter(),
    );
  }
}
