import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/device.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting trusted devices
class GetDevicesUseCase {
  final AuthRepository repository;

  GetDevicesUseCase({required this.repository});

  Future<Either<Failure, List<Device>>> call() async {
    return await repository.getDevices();
  }
}
