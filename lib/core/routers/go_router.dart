
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:flutter_firebase_app/features/home/data/repositories/note_repository_impl.dart';
import 'package:flutter_firebase_app/features/home/domain/repositories/note_repository.dart';
import 'package:flutter_firebase_app/features/home/presentation/blocs/cubit/note_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/blocs/auth_cubit.dart';
import '../../features/home/presentation/screens/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) =>  AuthScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
  redirect: (context, state) async {
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkCurrentUser();

    final isAuthenticated = authCubit.state is Authenticated;
    if (isAuthenticated && state.matchedLocation == '/auth') {
      return '/home';
    } else if (!isAuthenticated && state.matchedLocation == '/home') {
      return '/auth'; 
    }
    return null;
  },
);