import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
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
  Future<void> createFakeUsers();
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<AuthResponse> login(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<AuthResponse> signup(String email, String password, Map<String, dynamic> additionalInfo) async {
    try {
      final authResponse = await supabaseClient.auth.signUp(
        email: email, 
        password: password,
        data: additionalInfo,
      );

      if (authResponse.user != null) {
        try {
          // Update the user's metadata in the auth.users table
          await supabaseClient.auth.updateUser(UserAttributes(
            data: additionalInfo,
          ));
          
          // If you need to store additional data in a separate table, use this:
          // await supabaseClient.from('user_profiles').upsert({
          //   'id': authResponse.user!.id,
          //   ...additionalInfo,
          // }, onConflict: 'id');
        } catch (e) {
          print('Error updating user data: $e');
          // Continue with the sign-up process even if updating user data fails
        }
      }

      return authResponse;
    } catch (e) {
      if (e.toString().contains('429')) {
        throw Exception('Too many sign-up attempts. Please try again later.');
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponse> loginWithMagicLink(String email) async {
    await supabaseClient.auth.signInWithOtp(email: email);
    // Since signInWithOtp doesn't return AuthResponse, we'll create a dummy one
    return AuthResponse(session: null, user: null);
  }

  @override
  Future<AuthResponse> signupWithPhone(String phone, String password) async {
    return await supabaseClient.auth.signUp(phone: phone, password: password);
  }

  @override
  Future<AuthResponse> loginWithSmsOtp(String phone) async {
    await supabaseClient.auth.signInWithOtp(phone: phone);
    // Since signInWithOtp doesn't return AuthResponse, we'll create a dummy one
    return AuthResponse(session: null, user: null);
  }

  @override
  Future<AuthResponse> verifySmsOtp(String phone, String token) async {
    return await supabaseClient.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  @override
  Future<AuthResponse> loginWithOAuth(String provider) async {
    final providerEnum = Provider.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == provider.toLowerCase(),
      orElse: () => throw Exception('Invalid provider'),
    );
    final response = await supabaseClient.auth.signInWithOAuth(providerEnum);
    if (response) {
      final session = supabaseClient.auth.currentSession;
      final user = supabaseClient.auth.currentUser;
      return AuthResponse(session: session, user: user);
    } else {
      throw Exception('OAuth sign-in failed');
    }
  }

  @override
  Future<User?> getUser() async {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> passwordRecovery(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserResponse> updateUser(Map<String, dynamic> attributes) async {
    return await supabaseClient.auth.updateUser(UserAttributes(
      email: attributes['email'],
      password: attributes['password'],
      data: attributes['data'],
    ));
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<void> createFakeUsers() async {
    final fakeUsers = [
      {
        'email': 'user1@example.com',
        'password': 'password123',
        'user_metadata': {
          'full_name': 'User One',
          'age': 25,
        },
      },
      {
        'email': 'user2@example.com',
        'password': 'password456',
        'user_metadata': {
          'full_name': 'User Two',
          'age': 30,
        },
      },
      {
        'email': 'user3@example.com',
        'password': 'password789',
        'user_metadata': {
          'full_name': 'User Three',
          'age': 35,
        },
      },
    ];

    for (var user in fakeUsers) {
      try {
        final authResponse = await supabaseClient.auth.signUp(
          email: user['email'] as String,
          password: user['password'] as String,
          data: user['user_metadata'] as Map<String, dynamic>,
        );

        if (authResponse.user != null) {
          print('Created real user: ${user['email']}');
          // Sign out immediately after creating the user
          await supabaseClient.auth.signOut();
        } else {
          print('Failed to create user: ${user['email']}');
        }
      } catch (e) {
        print('Error creating user ${user['email']}: $e');
      }
      // Add a delay between sign-up attempts to avoid rate limiting
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    print('Calling Supabase resetPasswordForEmail for email: $email'); // Debug print
    await supabaseClient.auth.resetPasswordForEmail(email);
    print('Supabase resetPasswordForEmail call completed'); // Debug print
  }
}