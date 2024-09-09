import '../../domain/entities/home_entity.dart';

class HomeModel extends HomeEntity {
  const HomeModel({required String title}) : super(title: title);

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}