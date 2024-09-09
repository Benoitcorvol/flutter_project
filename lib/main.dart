import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		print('Building MyApp');
		return MultiBlocProvider(
			providers: [
				BlocProvider(create: (_) => di.sl<HomeBloc>()),
				BlocProvider(create: (_) => di.sl<AuthBloc>()),
			],
			child: MaterialApp(
				title: 'Collab App',
				theme: ThemeData(
					primarySwatch: Colors.blue,
				),
				home: const LoginPage(),
				routes: {
					'/home': (context) => const HomePage(),
				},
			),
		);
	}
}

const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() {
	runZonedGuarded(() async {
		WidgetsFlutterBinding.ensureInitialized();
		print('WidgetsFlutterBinding initialized');
		
		await dotenv.load(fileName: ".env");
		print('dotenv loaded');
		
		final supabaseUrl = dotenv.env['SUPABASE_URL'];
		final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
		
		print('SUPABASE_URL: $supabaseUrl');
		print('SUPABASE_ANON_KEY: $supabaseAnonKey');
		
		if (supabaseUrl == null || supabaseAnonKey == null) {
			throw Exception('Supabase credentials not found in .env file');
		}
		
		await Supabase.initialize(
			url: supabaseUrl,
			anonKey: supabaseAnonKey,
		);
		print('Supabase initialized');
		
		await di.init();
		print('Dependency injection initialized');

		if (!isProduction) {
			// Create real users for testing in development mode
			final authRemoteDataSource = AuthRemoteDataSourceImpl(supabaseClient: Supabase.instance.client);
			try {
				await authRemoteDataSource.createFakeUsers();
				print('Real test users created');
			} catch (e) {
				print('Error creating real test users: $e');
			}
		}
		
		runApp(const MyApp());
		print('MyApp running');
	}, (error, stack) {
		print('Error caught by runZonedGuarded:');
		print(error);
		print(stack);
	});
}
