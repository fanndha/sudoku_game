/// File: lib/features/settings/presentation/bloc/settings_state.dart
/// States untuk Settings Bloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_entity.dart';

/// Base State
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading State
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Loaded State
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];

  /// Copy with
  SettingsLoaded copyWith({SettingsEntity? settings}) {
    return SettingsLoaded(settings ?? this.settings);
  }
}

/// Error State
class SettingsError extends SettingsState {
  final String message;
  final String? code;

  const SettingsError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Update Success State
class SettingsUpdateSuccess extends SettingsState {
  final SettingsEntity settings;
  final String message;

  const SettingsUpdateSuccess({
    required this.settings,
    required this.message,
  });

  @override
  List<Object?> get props => [settings, message];
}