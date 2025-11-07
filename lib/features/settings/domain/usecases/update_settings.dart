/// File: lib/features/settings/domain/usecases/update_settings.dart
/// UseCase untuk update settings

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// UseCase untuk Update Settings
class UpdateSettings implements UseCase<void, UpdateSettingsParams> {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSettingsParams params) async {
    return await repository.updateSettings(params.settings);
  }
}

/// Parameters untuk UpdateSettings
class UpdateSettingsParams extends Params {
  final SettingsEntity settings;

  UpdateSettingsParams({required this.settings});

  @override
  List<Object?> get props => [settings];

  @override
  String? validate() {
    // Settings entity validation
    if (settings.soundVolume < 0.0 || settings.soundVolume > 1.0) {
      return 'Sound volume must be between 0.0 and 1.0';
    }
    if (settings.musicVolume < 0.0 || settings.musicVolume > 1.0) {
      return 'Music volume must be between 0.0 and 1.0';
    }
    return null;
  }
}