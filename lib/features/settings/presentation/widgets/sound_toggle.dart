/// File: lib/features/settings/presentation/widgets/sound_toggle.dart
/// Widget untuk toggle sound dengan volume slider

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SoundToggle extends StatelessWidget {
  final bool isEnabled;
  final double volume;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onVolumeChanged;

  const SoundToggle({
    Key? key,
    required this.isEnabled,
    required this.volume,
    required this.onToggle,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Efek Suara'),
          subtitle: const Text('Suara tombol dan interaksi'),
          value: isEnabled,
          onChanged: onToggle,
          secondary: Icon(
            isEnabled ? Icons.volume_up : Icons.volume_off,
            color: isEnabled ? AppColors.primary : Colors.grey,
          ),
        ),
        if (isEnabled) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.volume_down, size: 20),
                Expanded(
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(volume * 100).round()}%',
                    onChanged: onVolumeChanged,
                    activeColor: AppColors.primary,
                  ),
                ),
                const Icon(Icons.volume_up, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${(volume * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}