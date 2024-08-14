import 'dart:developer';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_app/data/services/fcm_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final _fcmService = FCMService();

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthRegister>(_onRegister);
    on<AuthSignIn>(_onSignIn);
    on<AuthLogout>(_onLogout);
    on<CheckTokenExpiry>(_onCheckTokenExpiry);
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.register(event.email, event.password);
      final token = await _fcmService.getToken();

      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(e.response?.data["error"]['message']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckTokenExpiry(
    CheckTokenExpiry event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authService.checkTokenExpiry();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.signIn(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(e.response?.data["error"]['message']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
