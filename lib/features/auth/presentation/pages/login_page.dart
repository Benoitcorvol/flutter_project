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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up' : 'Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
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
                                  final name = nameController.text.trim();
                                  final age = int.tryParse(ageController.text.trim());
                                  context.read<AuthBloc>().add(SignupRequested(
                                    email,
                                    password,
                                    {'name': name, 'age': age},
                                  ));
                                } else {
                                  context.read<AuthBloc>().add(LoginRequested(email, password));
                                }
                              } else {
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
                        onPressed: () {
                          // Navigate to PasswordRecoveryPage
                        },
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