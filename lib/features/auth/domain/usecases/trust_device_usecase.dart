import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/device.dart';
import '../repositories/auth_repository.dart';

/// Use case for trusting a device
class TrustDeviceUseCase {
  final AuthRepository repository;

  TrustDeviceUseCase({required this.repository});

  Future<Either<Failure, Device>> call(String deviceId) async {
    return await repository.trustDevice(deviceId);
  }
}
