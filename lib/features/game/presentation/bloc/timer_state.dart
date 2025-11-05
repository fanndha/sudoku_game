/// File: lib/features/game/presentation/bloc/timer_state.dart
/// States untuk TimerBloc

import 'package:equatable/equatable.dart';

/// Base class untuk semua Timer States
abstract class TimerState extends Equatable {
  final int elapsed;

  const TimerState({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}

/// Timer initial state
class TimerInitial extends TimerState {
  const TimerInitial() : super(elapsed: 0);
}

/// Timer running state
class TimerRunning extends TimerState {
  const TimerRunning({required super.elapsed});
}

/// Timer paused state
class TimerPaused extends TimerState {
  const TimerPaused({required super.elapsed});
}

/// Timer stopped state
class TimerStopped extends TimerState {
  const TimerStopped({required super.elapsed});
}