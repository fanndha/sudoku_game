/// File: lib/core/constants/app_routes.dart
/// Konstanta routes untuk navigasi aplikasi Sudoku

class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // ========== AUTH ROUTES ==========
  static const String splash = '/';
  static const String login = '/login';
  
  // ========== HOME ROUTES ==========
  static const String home = '/home';
  
  // ========== GAME ROUTES ==========
  static const String difficultySelection = '/difficulty-selection';
  static const String game = '/game';
  static const String pauseMenu = '/pause-menu';
  static const String gameComplete = '/game-complete';
  
  // ========== LEADERBOARD ROUTES ==========
  static const String leaderboard = '/leaderboard';
  
  // ========== PROFILE ROUTES ==========
  static const String profile = '/profile';
  static const String achievements = '/achievements';
  
  // ========== SETTINGS ROUTES ==========
  static const String settings = '/settings';
  
  // ========== STORE ROUTES ==========
  static const String store = '/store';
  
  // ========== TUTORIAL ROUTES ==========
  static const String tutorial = '/tutorial';
  
  // ========== DAILY CHALLENGE ROUTES ==========
  static const String dailyChallenge = '/daily-challenge';
  
  // ========== HELPER METHODS ==========
  
  /// Get all routes sebagai list
  static List<String> getAllRoutes() {
    return [
      splash,
      login,
      home,
      difficultySelection,
      game,
      pauseMenu,
      gameComplete,
      leaderboard,
      profile,
      achievements,
      settings,
      store,
      tutorial,
      dailyChallenge,
    ];
  }
  
  /// Check apakah route valid
  static bool isValidRoute(String route) {
    return getAllRoutes().contains(route);
  }
}