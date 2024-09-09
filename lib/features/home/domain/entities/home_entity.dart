import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  final String title;

  const HomeEntity({required this.title});

  @override
  List<Object> get props => [title];
}