import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeModel> getHomeData() {
    // TODO: implement the actual API call
    return Future.value(const HomeModel(title: 'Welcome to Collab App'));
  }
}