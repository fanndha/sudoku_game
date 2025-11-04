/// File: lib/core/utils/validators.dart
/// Validation utilities untuk form dan input
library;

class Validators {
  // Prevent instantiation
  Validators._();

  // ========== EMAIL VALIDATION ==========
  
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Check if email is valid
  static bool isValidEmail(String email) {
    return validateEmail(email) == null;
  }

  // ========== USERNAME VALIDATION ==========

  /// Validate username (3-20 characters, alphanumeric)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }

    if (value.length < 3) {
      return 'Username minimal 3 karakter';
    }

    if (value.length > 20) {
      return 'Username maksimal 20 karakter';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username hanya boleh mengandung huruf, angka, dan underscore';
    }

    return null;
  }

  /// Check if username is valid
  static bool isValidUsername(String username) {
    return validateUsername(username) == null;
  }

  // ========== PASSWORD VALIDATION ==========

  /// Validate password (minimal 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Validate strong password (8+ chars, uppercase, lowercase, number)
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Check if password is valid
  static bool isValidPassword(String password) {
    return validatePassword(password) == null;
  }

  // ========== CONFIRM PASSWORD VALIDATION ==========

  /// Validate confirm password matches password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  // ========== PHONE NUMBER VALIDATION ==========

  /// Validate Indonesian phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Indonesian phone number: 08xx, +628xx, 628xx
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');

    if (!phoneRegex.hasMatch(cleanNumber)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  /// Check if phone number is valid
  static bool isValidPhoneNumber(String phone) {
    return validatePhoneNumber(phone) == null;
  }

  // ========== GENERAL VALIDATIONS ==========

  /// Validate required field (not empty)
  static String? validateRequired(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.isEmpty) {
      return null; // Empty is valid for max length
    }

    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }

  /// Validate range length
  static String? validateRangeLength(
    String? value,
    int minLength,
    int maxLength, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }

  // ========== NUMBER VALIDATIONS ==========

  /// Validate number (integer or decimal)
  static String? validateNumber(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }

    return null;
  }

  /// Validate integer
  static String? validateInteger(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka bulat';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(
    String? value, [
    String fieldName = 'Field',
  ]) {
    final error = validateNumber(value, fieldName);
    if (error != null) return error;

    final number = num.parse(value!);
    if (number <= 0) {
      return '$fieldName harus lebih besar dari 0';
    }

    return null;
  }

  /// Validate number range
  static String? validateNumberRange(
    String? value,
    num min,
    num max, [
    String fieldName = 'Field',
  ]) {
    final error = validateNumber(value, fieldName);
    if (error != null) return error;

    final number = num.parse(value!);
    if (number < min || number > max) {
      return '$fieldName harus antara $min dan $max';
    }

    return null;
  }

  // ========== URL VALIDATION ==========

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Format URL tidak valid';
    }

    return null;
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    return validateUrl(url) == null;
  }

  // ========== DATE VALIDATION ==========

  /// Validate date format (yyyy-mm-dd)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak boleh kosong';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (yyyy-mm-dd)';
    }
  }

  /// Validate date is not in the past
  static String? validateFutureDate(String? value) {
    final error = validateDate(value);
    if (error != null) return error;

    final date = DateTime.parse(value!);
    final now = DateTime.now();

    if (date.isBefore(now)) {
      return 'Tanggal tidak boleh di masa lalu';
    }

    return null;
  }

  // ========== SUDOKU SPECIFIC VALIDATIONS ==========

  /// Validate sudoku cell value (1-9 or empty)
  static String? validateSudokuCell(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Empty is valid
    }

    final number = int.tryParse(value);
    if (number == null || number < 1 || number > 9) {
      return 'Hanya angka 1-9 yang valid';
    }

    return null;
  }

  /// Check if sudoku cell value is valid
  static bool isValidSudokuCell(String value) {
    if (value.isEmpty) return true;
    final number = int.tryParse(value);
    return number != null && number >= 1 && number <= 9;
  }
}