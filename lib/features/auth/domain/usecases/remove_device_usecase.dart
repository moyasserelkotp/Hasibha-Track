import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for removing a device
class RemoveDeviceUseCase {
  final AuthRepository repository;

  RemoveDeviceUseCase({required this.repository});

  Future<Either<Failure, void>> call(String deviceId) async {
    return await repository.removeDevice(deviceId);
  }
}
