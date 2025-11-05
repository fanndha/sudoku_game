/// File: lib/features/game/presentation/pages/game_page.dart
/// Main game screen dengan Sudoku board dan controls

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_header.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late TimerBloc _timerBloc;

  @override
  void initState() {
    super.initState();
    _timerBloc = TimerBloc();
    
    // Start timer jika game loaded
    final gameState = context.read<GameBloc>().state;
    if (gameState is GameLoaded) {
      _timerBloc.add(TimerStartEvent(
        initialTime: gameState.gameState.timeElapsed,
      ));
    }
  }

  @override
  void dispose() {
    _timerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _timerBloc,
      child: WillPopScope(
        onWillPop: () async {
          _handlePause();
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: SafeArea(
            child: MultiBlocListener(
              listeners: [
                // Listen to game state changes
                BlocListener<GameBloc, GameState>(
                  listener: (context, state) {
                    if (state is GameCompleted) {
                      // Stop timer
                      _timerBloc.add(const TimerStopEvent());
                      
                      // Navigate to completion page
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.gameComplete,
                      );
                    } else if (state is GamePaused) {
                      // Pause timer
                      _timerBloc.add(const TimerPauseEvent());
                      
                      // Show pause menu
                      Navigator.of(context).pushNamed(AppRoutes.pauseMenu);
                    } else if (state is GameNoHintsRemaining) {
                      // Show dialog untuk watch ad atau buy hints
                      _showNoHintsDialog(context);
                    } else if (state is GameHintShown) {
                      // Show hint feedback
                      Helpers.showSuccessSnackbar(
                        context,
                        'Hint: ${state.hintValue} di posisi [${state.row + 1}, ${state.col + 1}]',
                      );
                    }
                  },
                ),
                
                // Listen to timer ticks and update game
                BlocListener<TimerBloc, TimerState>(
                  listener: (context, state) {
                    if (state is TimerRunning) {
                      context.read<GameBloc>().add(
                        GameUpdateTimeEvent(seconds: state.elapsed),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  if (state is GameLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GameError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Kembali'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is! GameLoaded) {
                    return const Center(child: Text('Game not loaded'));
                  }

                  final gameState = state.gameState;

                  return Column(
                    children: [
                      // Header (difficulty, timer, progress)
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, timerState) {
                          return GameHeader(
                            difficulty: gameState.difficulty,
                            timeElapsed: timerState.elapsed,
                            progressPercentage: gameState.progressPercentage,
                            onPause: _handlePause,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Sudoku Grid
                      SudokuGrid(
                        board: gameState.board,
                        selectedCellIndex: gameState.selectedCellIndex,
                        onCellTap: (cellIndex) {
                          context.read<GameBloc>().add(
                            GameSelectCellEvent(cellIndex: cellIndex),
                          );
                        },
                      ),

                      const Spacer(),

                      // Game Controls
                      GameControls(
                        onUndo: () {
                          context.read<GameBloc>().add(const GameUndoEvent());
                        },
                        onRedo: () {
                          context.read<GameBloc>().add(const GameRedoEvent());
                        },
                        onErase: () {
                          context.read<GameBloc>().add(const GameEraseCellEvent());
                        },
                        onNote: () {
                          context.read<GameBloc>().add(const GameToggleNoteModeEvent());
                        },
                        onHint: () {
                          context.read<GameBloc>().add(const GameRequestHintEvent());
                        },
                        canUndo: state.canUndo,
                        canRedo: state.canRedo,
                        isNoteMode: state.isNoteMode,
                        hintsRemaining: state.hintsRemaining,
                      ),

                      const SizedBox(height: 8),

                      // Number Pad
                      NumberPad(
                        onNumberTap: (number) {
                          context.read<GameBloc>().add(
                            GameInputNumberEvent(number: number),
                          );
                        },
                        isNoteMode: state.isNoteMode,
                      ),

                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePause() {
    context.read<GameBloc>().add(const GamePauseEvent());
  }

  void _showNoHintsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hint Habis'),
        content: const Text(
          'Anda sudah menggunakan semua hint gratis. '
          'Tonton iklan untuk mendapatkan hint tambahan atau beli hint pack.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Show rewarded ad
              Helpers.showInfoSnackbar(
                context,
                'Fitur iklan akan segera hadir!',
              );
            },
            child: const Text('Tonton Iklan'),
          ),
        ],
      ),
    );
  }
}