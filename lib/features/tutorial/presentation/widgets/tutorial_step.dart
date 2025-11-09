/// File: lib/features/tutorial/presentation/widgets/tutorial_step.dart
/// Widget untuk setiap step tutorial

import 'package:flutter/material.dart';
import '../pages/tutorial_page.dart';
import 'tutorial_overlay.dart';

class TutorialStep extends StatelessWidget {
  final TutorialStepData data;

  const TutorialStep({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon with animated container
          _buildIcon(),

          const SizedBox(height: 32),

          // Title
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: data.color,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Illustration
          _buildIllustration(context),

          // Detail Text (if available)
          if (data.detailText != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: data.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: data.color,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data.detailText!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: data.color.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Icon(
              data.icon,
              size: 64,
              color: data.color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildIllustration(BuildContext context) {
    switch (data.illustration) {
      case TutorialIllustration.welcome:
        return _buildWelcomeIllustration();
      case TutorialIllustration.rows:
        return _buildRowsIllustration();
      case TutorialIllustration.columns:
        return _buildColumnsIllustration();
      case TutorialIllustration.boxes:
        return _buildBoxesIllustration();
      case TutorialIllustration.rules:
        return _buildRulesIllustration();
      case TutorialIllustration.notes:
        return _buildNotesIllustration();
      case TutorialIllustration.ready:
        return _buildReadyIllustration();
    }
  }

  // Welcome Illustration
  Widget _buildWelcomeIllustration() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.grid_4x4, size: 80, color: data.color),
          const SizedBox(height: 16),
          Text(
            'SUDOKU',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: data.color,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  // Rows Illustration - Simple 3x3 grid showing row
  Widget _buildRowsIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildSudokuRow([1, 2, 3, 4, 5, 6, 7, 8, 9], highlight: true),
          const SizedBox(height: 8),
          _buildSudokuRow([4, 5, 6, 7, 8, 9, 1, 2, 3]),
          const SizedBox(height: 8),
          _buildSudokuRow([7, 8, 9, 1, 2, 3, 4, 5, 6]),
        ],
      ),
    );
  }

  // Columns Illustration
  Widget _buildColumnsIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSudokuColumn([1, 2, 3], highlight: true),
          _buildSudokuColumn([4, 5, 6]),
          _buildSudokuColumn([7, 8, 9]),
        ],
      ),
    );
  }

  // Boxes Illustration - 3x3 box
  Widget _buildBoxesIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: data.color, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSudokuRow([1, 2, 3], small: true),
            _buildSudokuRow([4, 5, 6], small: true),
            _buildSudokuRow([7, 8, 9], small: true),
          ],
        ),
      ),
    );
  }

  // Rules Illustration - showing conflict
  Widget _buildRulesIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCell(5, error: true),
              _buildCell(2),
              _buildCell(5, error: true),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.close, color: data.color, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Angka 5 tidak boleh muncul dua kali!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Notes Illustration
  Widget _buildNotesIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCell(5),
          _buildCell(null, notes: [1, 2, 3]),
          _buildCell(7),
        ],
      ),
    );
  }

  // Ready Illustration
  Widget _buildReadyIllustration() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            data.color.withOpacity(0.1),
            data.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.celebration, size: 80, color: data.color),
          const SizedBox(height: 16),
          Text(
            'Siap!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSudokuRow(List<int> numbers, {bool highlight = false, bool small = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: numbers.map((num) {
        return Container(
          margin: const EdgeInsets.all(1),
          width: small ? 30 : 32,
          height: small ? 30 : 32,
          decoration: BoxDecoration(
            color: highlight ? data.color.withOpacity(0.2) : Colors.grey[100],
            border: Border.all(
              color: highlight ? data.color : Colors.grey[400]!,
              width: highlight ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            num.toString(),
            style: TextStyle(
              fontSize: small ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: highlight ? data.color : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSudokuColumn(List<int> numbers, {bool highlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: numbers.map((num) {
        return Container(
          margin: const EdgeInsets.all(1),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: highlight ? data.color.withOpacity(0.2) : Colors.grey[100],
            border: Border.all(
              color: highlight ? data.color : Colors.grey[400]!,
              width: highlight ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            num.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? data.color : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCell(int? value, {bool error = false, List<int>? notes}) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: error ? data.color.withOpacity(0.2) : Colors.grey[100],
        border: Border.all(
          color: error ? data.color : Colors.grey[400]!,
          width: error ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: notes != null
          ? _buildNotes(notes)
          : Center(
              child: value != null
                  ? Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: error ? data.color : Colors.black87,
                      ),
                    )
                  : null,
            ),
    );
  }

  Widget _buildNotes(List<int> notes) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: notes.map((note) {
          return Text(
            note.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: data.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}