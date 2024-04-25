import 'package:fpdart/fpdart.dart';
import 'package:view_share/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParms {}
