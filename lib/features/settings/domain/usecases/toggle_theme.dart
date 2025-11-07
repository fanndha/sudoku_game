/// File: lib/features/settings/domain/usecases/toggle_theme.dart
/// UseCase untuk toggle theme

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

/// UseCase untuk Toggle Theme
class ToggleTheme implements UseCase<void, ToggleThemeParams> {
  final SettingsRepository repository;

  ToggleTheme(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleThemeParams params) async {
    return await repository.toggleTheme(params.themeMode);
  }
}

/// Parameters untuk ToggleTheme
class ToggleThemeParams extends Params {
  final String themeMode; // 'light', 'dark', 'system'

  ToggleThemeParams({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];

  @override
  String? validate() {
    const validThemes = ['light', 'dark', 'system'];
    if (!validThemes.contains(themeMode.toLowerCase())) {
      return 'Invalid theme mode. Must be: light, dark, or system';
    }
    return null;
  }
}