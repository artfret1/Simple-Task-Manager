import 'package:task_manager/repositories/auth/user_router.dart';
import 'package:task_manager/repositories/bloc/auth_bloc.dart';
import 'package:task_manager/repositories/bloc/family_bloc.dart';
import 'package:task_manager/repositories/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyD07vYslhDno9fkcK95C2JslnOpx_erxBg',
      appId: '1:426834336038:android:2793689ab2c92c2e0ac9e7',
      messagingSenderId: '426834336038',
      projectId: 'task-manager-d7b3c',
      storageBucket: 'task-manager-d7b3c.firebasestorage.app',
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider<FamilyBloc>(create: (_) => FamilyBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(FirebaseAuth.instance)),
      ],
      child: const MainApp(),
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
