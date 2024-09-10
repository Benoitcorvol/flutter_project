import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> signup(String email, String password, Map<String, dynamic> additionalInfo);
  Future<AuthResponse> loginWithMagicLink(String email);
  Future<AuthResponse> signupWithPhone(String phone, String password);
  Future<AuthResponse> loginWithSmsOtp(String phone);
  Future<AuthResponse> verifySmsOtp(String phone, String token);
  Future<AuthResponse> loginWithOAuth(String provider);
  Future<User?> getUser();
  Future<void> passwordRecovery(String email);
  Future<UserResponse> updateUser(Map<String, dynamic> attributes);
  Future<void> logout();
  Future<void> forgotPassword(String email);
}