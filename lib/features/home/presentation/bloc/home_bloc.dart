import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_home_data.dart';
import '../../../../core/usecases/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      final failureOrHomeData = await getHomeData(NoParams());
      emit(failureOrHomeData.fold(
        (failure) => HomeError(message: 'Failed to load home data'),
        (homeData) => HomeLoaded(homeData: homeData),
      ));
    });
  }
}