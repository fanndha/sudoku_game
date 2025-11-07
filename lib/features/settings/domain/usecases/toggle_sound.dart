/// File: lib/features/settings/domain/usecases/toggle_sound.dart
/// UseCase untuk toggle sound

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

/// UseCase untuk Toggle Sound
class ToggleSound implements UseCase<void, ToggleSoundParams> {
  final SettingsRepository repository;

  ToggleSound(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleSoundParams params) async {
    return await repository.toggleSound(params.enabled);
  }
}

/// Parameters untuk ToggleSound
class ToggleSoundParams extends Params {
  final bool enabled;

  ToggleSoundParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];

  @override
  String? validate() => null; // No validation needed for boolean
}