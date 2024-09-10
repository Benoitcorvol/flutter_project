import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import 'signup_page.dart';
import 'password_recovery_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  bool isSignUp = false;

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final forgotPasswordEmailController = TextEditingController();
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your email address to reset your password.'),
              SizedBox(height: 16),
              TextField(
                controller: forgotPasswordEmailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = forgotPasswordEmailController.text.trim();
                if (email.isNotEmpty) {
                  print('Forgot password button clicked for email: $email'); // Debug print
                  context.read<AuthBloc>().add(ForgotPasswordRequested(email));
                  Navigator.pop(dialogContext);
                } else {
                  print('Forgot password attempted with empty email'); // Debug print
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your email'), backgroundColor: Colors.red),
                  );
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up' : 'Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Current AuthState: $state'); // Debug print
          if (state is AuthSuccess) {
            if (state.user != null) {
              print('Login/Signup successful. Navigating to HomePage.'); // Debug print
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
            } else {
              print('Password reset email sent successfully.'); // Debug print
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password reset email sent. Please check your inbox.'), backgroundColor: Colors.green),
              );
            }
          } else if (state is AuthFailure) {
            print('Authentication failed: ${state.error}'); // Debug print
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red, duration: Duration(seconds: 5)),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    if (isSignUp) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              if (email.isNotEmpty && password.isNotEmpty) {
                                if (isSignUp) {
                                  print('Sign up button clicked'); // Debug print
                                  final name = nameController.text.trim();
                                  final age = int.tryParse(ageController.text.trim());
                                  context.read<AuthBloc>().add(SignupRequested(
                                    email,
                                    password,
                                    {'name': name, 'age': age},
                                  ));
                                } else {
                                  print('Login button clicked'); // Debug print
                                  context.read<AuthBloc>().add(LoginRequested(email, password));
                                }
                              } else {
                                print('Login/Signup attempted with empty fields'); // Debug print
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.orange),
                                );
                              }
                            },
                      child: state is AuthLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(isSignUp ? 'Sign Up' : 'Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = !isSignUp;
                          print('isSignUp: $isSignUp'); // Debug print
                        });
                      },
                      child: Text(isSignUp ? 'Already have an account? Login' : 'Don\'t have an account? Sign up'),
                    ),
                    if (!isSignUp)
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: Text('Forgot password?'),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}