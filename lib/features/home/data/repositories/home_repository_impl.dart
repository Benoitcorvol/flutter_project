import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeEntity>> getHomeData() async {
    try {
      final remoteHomeData = await remoteDataSource.getHomeData();
      return Right(remoteHomeData);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}