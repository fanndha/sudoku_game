/// File: lib/features/tutorial/presentation/pages/tutorial_page.dart
/// Main tutorial page dengan PageView

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/tutorial_step.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialStepData> _steps = [
    TutorialStepData(
      title: 'Selamat Datang!',
      description: 'Sudoku adalah permainan puzzle logika yang sangat populer. '
          'Mari pelajari cara bermainnya!',
      icon: Icons.emoji_events,
      color: AppColors.primary,
      illustration: TutorialIllustration.welcome,
    ),
    TutorialStepData(
      title: 'Aturan Baris',
      description: AppStrings.tutorialStep1,
      icon: Icons.view_week,
      color: AppColors.success,
      illustration: TutorialIllustration.rows,
      detailText: 'Setiap baris harus berisi angka 1-9 tanpa pengulangan',
    ),
    TutorialStepData(
      title: 'Aturan Kolom',
      description: AppStrings.tutorialStep2,
      icon: Icons.view_column,
      color: AppColors.info,
      illustration: TutorialIllustration.columns,
      detailText: 'Setiap kolom harus berisi angka 1-9 tanpa pengulangan',
    ),
    TutorialStepData(
      title: 'Aturan Kotak 3x3',
      description: AppStrings.tutorialStep3,
      icon: Icons.grid_on,
      color: AppColors.warning,
      illustration: TutorialIllustration.boxes,
      detailText: 'Setiap kotak 3x3 harus berisi angka 1-9 tanpa pengulangan',
    ),
    TutorialStepData(
      title: 'Tidak Boleh Duplikat',
      description: AppStrings.tutorialStep4,
      icon: Icons.block,
      color: AppColors.error,
      illustration: TutorialIllustration.rules,
      detailText: 'Angka yang sama tidak boleh muncul di baris, kolom, atau kotak yang sama',
    ),
    TutorialStepData(
      title: 'Mode Catatan',
      description: AppStrings.tutorialStep5,
      icon: Icons.edit_note,
      color: AppColors.secondary,
      illustration: TutorialIllustration.notes,
      detailText: 'Gunakan mode catatan untuk menandai kemungkinan angka di sebuah sel',
    ),
    TutorialStepData(
      title: 'Siap Bermain!',
      description: 'Sekarang kamu sudah siap untuk bermain Sudoku! '
          'Mulai dengan level mudah dan tingkatkan kemampuanmu.',
      icon: Icons.play_arrow,
      color: AppColors.premiumGold,
      illustration: TutorialIllustration.ready,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Finish tutorial
      Navigator.pop(context);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.tutorial,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _skipTutorial,
                    child: const Text('Lewati'),
                  ),
                ],
              ),
            ),

            // Page Indicator
            _buildPageIndicator(),

            // Tutorial Steps
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return TutorialStep(data: _steps[index]);
                },
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _steps.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? _steps[_currentPage].color
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back Button
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _steps[_currentPage].color),
                ),
                child: Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _steps[_currentPage].color,
                  ),
                ),
              ),
            ),

          if (_currentPage > 0) const SizedBox(width: 16),

          // Next/Finish Button
          Expanded(
            flex: _currentPage > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _steps[_currentPage].color,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _steps.length - 1
                        ? 'Mulai Bermain'
                        : 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentPage == _steps.length - 1
                        ? Icons.play_arrow
                        : Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tutorial Step Data
class TutorialStepData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final TutorialIllustration illustration;
  final String? detailText;

  TutorialStepData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.illustration,
    this.detailText,
  });
}

/// Tutorial Illustration Type
enum TutorialIllustration {
  welcome,
  rows,
  columns,
  boxes,
  rules,
  notes,
  ready,
}