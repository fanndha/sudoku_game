/// File: lib/core/utils/time_formatter.dart
/// Time formatting utilities khusus untuk game timer dan duration

class TimeFormatter {
  // Prevent instantiation
  TimeFormatter._();

  // ========== DURATION FORMATTING ==========

  /// Format duration dalam seconds ke format HH:MM:SS
  /// Example: 3665 seconds -> "01:01:05"
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(secs)}';
  }

  /// Format duration dalam seconds ke format MM:SS (tanpa hours)
  /// Example: 125 seconds -> "02:05"
  static String formatDurationShort(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return '${_twoDigits(minutes)}:${_twoDigits(secs)}';
  }

  /// Format duration dalam seconds ke format MM:SS dengan conditional hours
  /// Hanya tampilkan hours jika > 0
  /// Example: 65 -> "01:05", 3665 -> "01:01:05"
  static String formatDurationSmart(int seconds) {
    final hours = seconds ~/ 3600;
    
    if (hours > 0) {
      return formatDuration(seconds);
    } else {
      return formatDurationShort(seconds);
    }
  }

  /// Format duration ke human readable string
  /// Example: 3665 -> "1 jam 1 menit", 125 -> "2 menit 5 detik"
  static String formatDurationHuman(int seconds, {bool showSeconds = true}) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final parts = <String>[];

    if (hours > 0) {
      parts.add('$hours jam');
    }
    if (minutes > 0) {
      parts.add('$minutes menit');
    }
    if (showSeconds && secs > 0 && hours == 0) {
      parts.add('$secs detik');
    }

    if (parts.isEmpty) {
      return '0 detik';
    }

    return parts.join(' ');
  }

  /// Format duration ke compact string
  /// Example: 3665 -> "1h 1m", 125 -> "2m 5s"
  static String formatDurationCompact(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final parts = <String>[];

    if (hours > 0) {
      parts.add('${hours}h');
    }
    if (minutes > 0) {
      parts.add('${minutes}m');
    }
    if (secs > 0 && hours == 0) {
      parts.add('${secs}s');
    }

    if (parts.isEmpty) {
      return '0s';
    }

    return parts.join(' ');
  }

  // ========== GAME TIME SPECIFIC FORMATTING ==========

  /// Format best time untuk leaderboard
  /// Always show in MM:SS format for consistency
  static String formatBestTime(int seconds) {
    if (seconds < 3600) {
      // Under 1 hour: show MM:SS
      return formatDurationShort(seconds);
    } else {
      // Over 1 hour: show HH:MM:SS
      return formatDuration(seconds);
    }
  }

  /// Format average time
  static String formatAverageTime(double seconds) {
    return formatBestTime(seconds.round());
  }

  /// Format time difference (untuk comparison)
  /// Example: +5 seconds -> "+00:05", -3 seconds -> "-00:03"
  static String formatTimeDifference(int seconds) {
    final sign = seconds >= 0 ? '+' : '';
    return '$sign${formatDurationShort(seconds.abs())}';
  }

  // ========== MILLISECONDS FORMATTING ==========

  /// Format milliseconds ke format MM:SS.mmm
  /// Example: 125530 ms -> "02:05.530"
  static String formatMilliseconds(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final ms = milliseconds % 1000;
    
    return '${formatDurationShort(seconds)}.${_threeDigits(ms)}';
  }

  /// Format milliseconds ke format HH:MM:SS.mmm
  static String formatMillisecondsFull(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final ms = milliseconds % 1000;
    
    return '${formatDuration(seconds)}.${_threeDigits(ms)}';
  }

  // ========== COUNTDOWN FORMATTING ==========

  /// Format countdown timer (emphasize when < 10 seconds)
  /// Returns formatted string with warning flag
  static CountdownFormat formatCountdown(int seconds) {
    final formatted = formatDurationShort(seconds);
    final isWarning = seconds <= 10 && seconds > 0;
    final isCritical = seconds <= 3 && seconds > 0;
    
    return CountdownFormat(
      formatted: formatted,
      isWarning: isWarning,
      isCritical: isCritical,
    );
  }

  // ========== HELPER METHODS ==========

  /// Format number dengan leading zero (2 digits)
  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  /// Format number dengan leading zero (3 digits)
  static String _threeDigits(int n) {
    return n.toString().padLeft(3, '0');
  }

  // ========== PARSING ==========

  /// Parse formatted time string (MM:SS) ke seconds
  /// Example: "02:05" -> 125
  static int? parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      
      if (parts.length == 2) {
        // MM:SS format
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return minutes * 60 + seconds;
      } else if (parts.length == 3) {
        // HH:MM:SS format
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return hours * 3600 + minutes * 60 + seconds;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== COMPARISON ==========

  /// Compare two times and return formatted difference
  /// Example: compareTime(125, 120) -> "+00:05 (lebih lambat)"
  static String compareTime(int currentSeconds, int bestSeconds) {
    final diff = currentSeconds - bestSeconds;
    
    if (diff == 0) {
      return 'Sama dengan best time';
    } else if (diff > 0) {
      return '${formatDurationShort(diff)} lebih lambat';
    } else {
      return '${formatDurationShort(diff.abs())} lebih cepat';
    }
  }

  // ========== SPEED CALCULATION ==========

  /// Calculate speed (cells per minute)
  static String formatSpeed(int cellsSolved, int seconds) {
    if (seconds == 0) return '0.0';
    
    final minutes = seconds / 60;
    final speed = cellsSolved / minutes;
    
    return speed.toStringAsFixed(1);
  }
}

/// Class untuk countdown format dengan warning flags
class CountdownFormat {
  final String formatted;
  final bool isWarning;
  final bool isCritical;

  CountdownFormat({
    required this.formatted,
    required this.isWarning,
    required this.isCritical,
  });
}