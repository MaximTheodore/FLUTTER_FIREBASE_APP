import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_app/features/home/domain/repositories/note_repository.dart';
import 'core/routers/go_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/blocs/auth_cubit.dart';
import 'features/home/data/repositories/note_repository_impl.dart';
import 'features/home/presentation/blocs/cubit/note_cubit.dart';  // Import NoteCubit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepositoryImpl()),
        ),
        BlocProvider( 
          create: (context) => NoteCubit(NoteRepositoryImpl()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}