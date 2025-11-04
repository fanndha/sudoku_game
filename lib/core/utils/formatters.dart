/// File: lib/core/utils/formatters.dart
/// Formatting utilities untuk display data

import 'package:intl/intl.dart';

class Formatters {
  // Prevent instantiation
  Formatters._();

  // ========== NUMBER FORMATTING ==========

  /// Format number dengan thousand separator
  /// Example: 1000 -> 1,000
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number);
  }

  /// Format number dengan decimal
  /// Example: 1000.5 -> 1,000.5
  static String formatNumberWithDecimal(num number, [int decimalDigits = 2]) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}', 'id_ID');
    return formatter.format(number);
  }

  /// Format currency (Indonesian Rupiah)
  /// Example: 10000 -> Rp 10.000
  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format currency (US Dollar)
  /// Example: 10000 -> $10,000
  static String formatCurrencyUSD(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format percentage
  /// Example: 0.755 -> 75.5%
  static String formatPercentage(double value, [int decimalDigits = 1]) {
    return '${(value * 100).toStringAsFixed(decimalDigits)}%';
  }

  /// Format compact number (K, M, B)
  /// Example: 1500 -> 1.5K, 1500000 -> 1.5M
  static String formatCompactNumber(num number) {
    final formatter = NumberFormat.compact(locale: 'id_ID');
    return formatter.format(number);
  }

  // ========== DATE & TIME FORMATTING ==========

  /// Format date (dd MMM yyyy)
  /// Example: 2024-01-15 -> 15 Jan 2024
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format date with full month name
  /// Example: 2024-01-15 -> 15 Januari 2024
  static String formatDateFull(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format date short (dd/MM/yyyy)
  /// Example: 2024-01-15 -> 15/01/2024
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Format time (HH:mm)
  /// Example: 14:30
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  /// Format time with seconds (HH:mm:ss)
  /// Example: 14:30:45
  static String formatTimeWithSeconds(DateTime dateTime) {
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  /// Format date and time
  /// Example: 15 Jan 2024, 14:30
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  /// Format relative time (e.g., "2 hours ago", "yesterday")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes menit yang lalu';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours jam yang lalu';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? 'Kemarin' : '$days hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  // ========== PHONE NUMBER FORMATTING ==========

  /// Format Indonesian phone number
  /// Example: 081234567890 -> 0812-3456-7890
  static String formatPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    if (cleanPhone.startsWith('0') && cleanPhone.length >= 11) {
      // Format: 0812-3456-7890
      return '${cleanPhone.substring(0, 4)}-${cleanPhone.substring(4, 8)}-${cleanPhone.substring(8)}';
    } else if (cleanPhone.startsWith('62') && cleanPhone.length >= 12) {
      // Format: +62-812-3456-7890
      return '+62-${cleanPhone.substring(2, 5)}-${cleanPhone.substring(5, 9)}-${cleanPhone.substring(9)}';
    }
    
    return phone; // Return original if doesn't match pattern
  }

  // ========== TEXT FORMATTING ==========

  /// Capitalize first letter
  /// Example: "hello world" -> "Hello world"
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize each word
  /// Example: "hello world" -> "Hello World"
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Truncate text with ellipsis
  /// Example: "Hello World" (maxLength: 8) -> "Hello..."
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  /// Remove extra whitespaces
  static String removeExtraSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // ========== FILE SIZE FORMATTING ==========

  /// Format file size (bytes to human readable)
  /// Example: 1536 -> 1.5 KB
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // ========== DIFFICULTY FORMATTING ==========

  /// Format difficulty level
  static String formatDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Mudah';
      case 'medium':
        return 'Sedang';
      case 'hard':
        return 'Sulit';
      case 'expert':
        return 'Ahli';
      default:
        return capitalizeFirst(difficulty);
    }
  }

  // ========== RANK FORMATTING ==========

  /// Format rank with ordinal suffix
  /// Example: 1 -> "1st", 2 -> "2nd", 3 -> "3rd", 4 -> "4th"
  static String formatRank(int rank) {
    if (rank <= 0) return rank.toString();

    final lastDigit = rank % 10;
    final lastTwoDigits = rank % 100;

    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      return '${rank}th';
    }

    switch (lastDigit) {
      case 1:
        return '${rank}st';
      case 2:
        return '${rank}nd';
      case 3:
        return '${rank}rd';
      default:
        return '${rank}th';
    }
  }

  /// Format rank in Indonesian
  /// Example: 1 -> "Peringkat 1"
  static String formatRankID(int rank) {
    return 'Peringkat $rank';
  }

  // ========== SCORE FORMATTING ==========

  /// Format score with leading zeros
  /// Example: 42 -> "0042"
  static String formatScore(int score, [int totalDigits = 4]) {
    return score.toString().padLeft(totalDigits, '0');
  }
}