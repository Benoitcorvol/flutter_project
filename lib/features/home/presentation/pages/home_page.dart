import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            BlocProvider.of<HomeBloc>(context).add(LoadHomeData());
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return Center(child: Text(state.homeData.title));
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}