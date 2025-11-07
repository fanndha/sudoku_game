/// File: lib/features/settings/domain/usecases/get_settings.dart
/// UseCase untuk get settings

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// UseCase untuk Get Settings
class GetSettings implements UseCaseNoParams<SettingsEntity> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call() async {
    return await repository.getSettings();
  }
}