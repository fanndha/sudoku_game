/// File: lib/features/tutorial/presentation/widgets/tutorial_overlay.dart
/// Widget untuk tutorial overlay (coach marks style)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Tutorial Overlay - untuk menampilkan tutorial di atas widget tertentu
class TutorialOverlay extends StatefulWidget {
  final List<TutorialTarget> targets;
  final VoidCallback onComplete;

  const TutorialOverlay({
    Key? key,
    required this.targets,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();

  /// Show tutorial overlay
  static void show(
    BuildContext context, {
    required List<TutorialTarget> targets,
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => TutorialOverlay(
        targets: targets,
        onComplete: onComplete ?? () => Navigator.pop(context),
      ),
    );
  }
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _currentIndex = 0;

  void _next() {
    if (_currentIndex < widget.targets.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.targets[_currentIndex];

    return Stack(
      children: [
        // Touch to continue
        GestureDetector(
          onTap: _next,
          child: Container(
            color: Colors.transparent,
          ),
        ),

        // Highlight area (if target has position)
        if (target.targetKey != null) _buildHighlight(target),

        // Tutorial content
        _buildContent(target),

        // Skip button
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: TextButton(
            onPressed: _skip,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Lewati',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Progress indicator
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: _buildProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildHighlight(TutorialTarget target) {
    // Get target widget position
    final RenderBox? renderBox =
        target.targetKey?.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return const SizedBox.shrink();

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Positioned(
      left: position.dx - 8,
      top: position.dy - 8,
      child: Container(
        width: size.width + 16,
        height: size.height + 16,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TutorialTarget target) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 100,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              if (target.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    target.icon,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Title
              if (target.title != null) ...[
                Text(
                  target.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
              ],

              // Description
              Text(
                target.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentIndex == widget.targets.length - 1
                        ? 'Selesai'
                        : 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Tap anywhere hint
              const SizedBox(height: 12),
              Text(
                'Atau ketuk di mana saja untuk lanjut',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${_currentIndex + 1}/${widget.targets.length}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Tutorial Target - data untuk setiap step
class TutorialTarget {
  final GlobalKey? targetKey; // Key dari widget yang ingin di-highlight
  final String? title;
  final String description;
  final IconData? icon;

  TutorialTarget({
    this.targetKey,
    this.title,
    required this.description,
    this.icon,
  });
}

/// Quick Tutorial Dialog - simple dialog style
class QuickTutorialDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onConfirm;

  const QuickTutorialDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.onConfirm,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => QuickTutorialDialog(
        title: title,
        message: message,
        icon: icon,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.info,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: const Text(
            'Mengerti',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// First Time Tutorial - untuk first time users
class FirstTimeTutorial {
  /// Show first time tutorial sequence
  static void show(BuildContext context, {VoidCallback? onComplete}) {
    final targets = [
      TutorialTarget(
        title: 'Selamat Datang!',
        description: 'Mari kita pelajari cara bermain Sudoku dengan cepat',
        icon: Icons.waving_hand,
      ),
      TutorialTarget(
        title: 'Pilih Angka',
        description: 'Ketuk sel kosong, lalu pilih angka dari 1-9',
        icon: Icons.touch_app,
      ),
      TutorialTarget(
        title: 'Mode Catatan',
        description: 'Aktifkan mode catatan untuk menandai kemungkinan angka',
        icon: Icons.edit_note,
      ),
      TutorialTarget(
        title: 'Gunakan Petunjuk',
        description: 'Jika stuck, gunakan tombol petunjuk untuk bantuan',
        icon: Icons.lightbulb,
      ),
      TutorialTarget(
        title: 'Siap Bermain!',
        description: 'Sekarang kamu siap! Selamat bermain Sudoku!',
        icon: Icons.celebration,
      ),
    ];

    TutorialOverlay.show(
      context,
      targets: targets,
      onComplete: onComplete ?? () {},
    );
  }
}