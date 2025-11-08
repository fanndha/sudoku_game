/// File: lib/features/settings/presentation/widgets/error_highlight_toggle.dart
/// Widget untuk toggle error highlight

import 'package:flutter/material.dart';

class ErrorHighlightToggle extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const ErrorHighlightToggle({
    Key? key,
    required this.isEnabled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Highlight Error'),
      subtitle: const Text('Tandai kesalahan saat input'),
      value: isEnabled,
      onChanged: onToggle,
      secondary: const Icon(Icons.error_outline),
    );
  }
}