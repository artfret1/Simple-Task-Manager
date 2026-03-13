import '../bloc/auth_bloc.dart';
import 'create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Контроллеры хранят значения полей между перестроениями виджета.
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // Ошибки авторизации показываем неблокирующим сообщением.
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              // Пока идет запрос, действия авторизации временно отключаем.
              final isLoading = state is AuthLoading;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login Screen'),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          // Переключаем видимость пароля для удобства ввода.
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 10,
                    ),
                    onPressed: isLoading ? null : _handleAuth,
                    child: Text('Log in'),
                  ),
                  Text('Don\'t have account?'),
                  // Переход на регистрацию с очисткой стека навигации.
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 10,
                    ),
                    onPressed: isLoading
                        ? null
                        : () => Get.offAll(CreateScreen()),
                    child: Text('Register now'),
                  ),
                  Text('OR'),
                  // Гостевой вход полезен для демо-сценариев и быстрого теста.
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 78, 134),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 10,
                    ),
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthBloc>().add(
                            AuthLoginRequested(),
                          ),
                    child: Text(
                      'log in anonymously',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleAuth() {
    // Нормализуем ввод перед проверкой и отправкой события.
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Базовая валидация на клиенте до обращения к бизнес-логике.
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Передаем запрос в BLoC: экран не выполняет авторизацию напрямую.
    context.read<AuthBloc>().add(AuthLoginWithEmailRequested(email, password));
  }
}
