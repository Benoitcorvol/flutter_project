import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeData implements UseCase<HomeEntity, NoParams> {
  final HomeRepository repository;

  GetHomeData(this.repository);

  @override
  Future<Either<Failure, HomeEntity>> call(NoParams params) async {
    return await repository.getHomeData();
  }
}