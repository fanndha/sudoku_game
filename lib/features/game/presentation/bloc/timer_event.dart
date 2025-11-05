/// File: lib/features/game/presentation/bloc/timer_event.dart
/// Events untuk TimerBloc

import 'package:equatable/equatable.dart';

/// Base class untuk semua Timer Events
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk start timer
class TimerStartEvent extends TimerEvent {
  final int initialTime;

  const TimerStartEvent({this.initialTime = 0});

  @override
  List<Object?> get props => [initialTime];
}

/// Event untuk pause timer
class TimerPauseEvent extends TimerEvent {
  const TimerPauseEvent();
}

/// Event untuk resume timer
class TimerResumeEvent extends TimerEvent {
  const TimerResumeEvent();
}

/// Event untuk stop/reset timer
class TimerStopEvent extends TimerEvent {
  const TimerStopEvent();
}

/// Event untuk timer tick (internal)
class TimerTickEvent extends TimerEvent {
  final int elapsed;

  const TimerTickEvent({required this.elapsed});

  @override
  List<Object?> get props => [elapsed];
}