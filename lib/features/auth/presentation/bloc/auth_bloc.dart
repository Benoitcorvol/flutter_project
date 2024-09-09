import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> additionalInfo;

  SignupRequested(this.email, this.password, this.additionalInfo);
}

class LoginWithMagicLinkRequested extends AuthEvent {
  final String email;

  LoginWithMagicLinkRequested(this.email);
}

class SignupWithPhoneRequested extends AuthEvent {
  final String phone;
  final String password;

  SignupWithPhoneRequested(this.phone, this.password);
}

class LoginWithSmsOtpRequested extends AuthEvent {
  final String phone;

  LoginWithSmsOtpRequested(this.phone);
}

class VerifySmsOtpRequested extends AuthEvent {
  final String phone;
  final String token;

  VerifySmsOtpRequested(this.phone, this.token);
}

class LoginWithOAuthRequested extends AuthEvent {
  final String provider;

  LoginWithOAuthRequested(this.provider);
}

class GetUserRequested extends AuthEvent {}

class PasswordRecoveryRequested extends AuthEvent {
  final String email;

  PasswordRecoveryRequested(this.email);
}

class UpdateUserRequested extends AuthEvent {
  final Map<String, dynamic> attributes;

  UpdateUserRequested(this.attributes);
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;

  AuthSuccess({this.user});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final authResponse = await authRepository.login(event.email, event.password);
        emit(AuthSuccess(user: authResponse.user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final authResponse = await authRepository.signup(event.email, event.password, event.additionalInfo);
        emit(AuthSuccess(user: authResponse.user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LoginWithMagicLinkRequested>(_onLoginWithMagicLinkRequested);
    on<SignupWithPhoneRequested>(_onSignupWithPhoneRequested);
    on<LoginWithSmsOtpRequested>(_onLoginWithSmsOtpRequested);
    on<VerifySmsOtpRequested>(_onVerifySmsOtpRequested);
    on<LoginWithOAuthRequested>(_onLoginWithOAuthRequested);
    on<GetUserRequested>(_onGetUserRequested);
    on<PasswordRecoveryRequested>(_onPasswordRecoveryRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginWithMagicLinkRequested(LoginWithMagicLinkRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.loginWithMagicLink(event.email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignupWithPhoneRequested(SignupWithPhoneRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signupWithPhone(event.phone, event.password);
      emit(AuthSuccess(user: response.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithSmsOtpRequested(LoginWithSmsOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.loginWithSmsOtp(event.phone);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifySmsOtpRequested(VerifySmsOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.verifySmsOtp(event.phone, event.token);
      emit(AuthSuccess(user: response.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithOAuthRequested(LoginWithOAuthRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.loginWithOAuth(event.provider);
      emit(AuthSuccess(user: response.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGetUserRequested(GetUserRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getUser();
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onPasswordRecoveryRequested(PasswordRecoveryRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.passwordRecovery(event.email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpdateUserRequested(UpdateUserRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.updateUser(event.attributes);
      emit(AuthSuccess(user: response.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}