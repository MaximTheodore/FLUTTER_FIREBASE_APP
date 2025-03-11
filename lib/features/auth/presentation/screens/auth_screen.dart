import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_app/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:go_router/go_router.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isReg = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            showCustomToast(context, state.message);
          }
        },
        builder: (context, state) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Почта'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Пароль'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (isReg) {
                        context.read<AuthCubit>().signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                      } else {
                        context.read<AuthCubit>().signUp(
                              _emailController.text,
                              _passwordController.text,
                            );
                      }
                    },
                    child: Text(isReg ? 'Войти' : 'Зарегистрироваться'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isReg = !isReg;
                      });
                    },
                    child: Text(isReg ? 'Еще не зарегистрированы?' : 'Уже есть аккаунт? Войти'),
                  ),
                  if (state is AuthLoading)
                    CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showCustomToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}