import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkCurrentUser() async {
    emit(AuthLoading());
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user.email ?? 'Это не почта'));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(email, password);
      emit(Authenticated(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email, password);
      emit(Authenticated(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}