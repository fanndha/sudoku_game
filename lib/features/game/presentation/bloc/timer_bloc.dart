/// File: lib/features/game/presentation/bloc/timer_bloc.dart
/// Bloc untuk manage game timer

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// TimerBloc - Manage game timer
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  int _elapsed = 0;

  TimerBloc() : super(const TimerInitial()) {
    on<TimerStartEvent>(_onStart);
    on<TimerPauseEvent>(_onPause);
    on<TimerResumeEvent>(_onResume);
    on<TimerStopEvent>(_onStop);
    on<TimerTickEvent>(_onTick);
  }

  /// Start timer
  Future<void> _onStart(
    TimerStartEvent event,
    Emitter<TimerState> emit,
  ) async {
    logger.blocEvent('TimerBloc', event);
    
    _elapsed = event.initialTime;
    _startTimer();
    emit(TimerRunning(elapsed: _elapsed));
  }

  /// Pause timer
  Future<void> _onPause(
    TimerPauseEvent event,
    Emitter<TimerState> emit,
  ) async {
    logger.blocEvent('TimerBloc', event);
    
    _stopTimer();
    emit(TimerPaused(elapsed: _elapsed));
  }

  /// Resume timer
  Future<void> _onResume(
    TimerResumeEvent event,
    Emitter<TimerState> emit,
  ) async {
    logger.blocEvent('TimerBloc', event);
    
    _startTimer();
    emit(TimerRunning(elapsed: _elapsed));
  }

  /// Stop timer
  Future<void> _onStop(
    TimerStopEvent event,
    Emitter<TimerState> emit,
  ) async {
    logger.blocEvent('TimerBloc', event);
    
    _stopTimer();
    _elapsed = 0;
    emit(TimerStopped(elapsed: _elapsed));
  }

  /// Timer tick
  Future<void> _onTick(
    TimerTickEvent event,
    Emitter<TimerState> emit,
  ) async {
    _elapsed = event.elapsed;
    emit(TimerRunning(elapsed: _elapsed));
  }

  /// Start internal timer
  void _startTimer() {
    _stopTimer(); // Stop existing timer if any
    
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!isClosed) {
          add(TimerTickEvent(elapsed: _elapsed + 1));
        }
      },
    );
  }

  /// Stop internal timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }

  @override
  void onEvent(TimerEvent event) {
    super.onEvent(event);
    if (event is! TimerTickEvent) {
      logger.blocEvent('TimerBloc', event);
    }
  }

  @override
  void onChange(Change<TimerState> change) {
    super.onChange(change);
    if (change.nextState is! TimerRunning || _elapsed % 10 == 0) {
      logger.blocState('TimerBloc', change.nextState);
    }
  }
}