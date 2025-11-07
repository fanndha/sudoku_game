/// File: lib/features/settings/domain/usecases/toggle_music.dart
/// UseCase untuk toggle music

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

/// UseCase untuk Toggle Music
class ToggleMusic implements UseCase<void, ToggleMusicParams> {
  final SettingsRepository repository;

  ToggleMusic(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleMusicParams params) async {
    return await repository.toggleMusic(params.enabled);
  }
}

/// Parameters untuk ToggleMusic
class ToggleMusicParams extends Params {
  final bool enabled;

  ToggleMusicParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];

  @override
  String? validate() => null; // No validation needed for boolean
}
