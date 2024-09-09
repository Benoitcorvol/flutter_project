import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponse> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<AuthResponse> signup(String email, String password, Map<String, dynamic> additionalInfo) async {
    return await remoteDataSource.signup(email, password, additionalInfo);
  }

  @override
  Future<AuthResponse> loginWithMagicLink(String email) async {
    return await remoteDataSource.loginWithMagicLink(email);
  }

  @override
  Future<AuthResponse> signupWithPhone(String phone, String password) async {
    return await remoteDataSource.signupWithPhone(phone, password);
  }

  @override
  Future<AuthResponse> loginWithSmsOtp(String phone) async {
    return await remoteDataSource.loginWithSmsOtp(phone);
  }

  @override
  Future<AuthResponse> verifySmsOtp(String phone, String token) async {
    return await remoteDataSource.verifySmsOtp(phone, token);
  }

  @override
  Future<AuthResponse> loginWithOAuth(String provider) async {
    return await remoteDataSource.loginWithOAuth(provider);
  }

  @override
  Future<User?> getUser() async {
    return await remoteDataSource.getUser();
  }

  @override
  Future<void> passwordRecovery(String email) async {
    await remoteDataSource.passwordRecovery(email);
  }

  @override
  Future<UserResponse> updateUser(Map<String, dynamic> attributes) async {
    return await remoteDataSource.updateUser(attributes);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}