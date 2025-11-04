/// File: lib/core/constants/firebase_constants.dart
/// Konstanta untuk Firebase Collections dan Fields

class FirebaseConstants {
  // Prevent instantiation
  FirebaseConstants._();

  // ========== COLLECTIONS ==========
  static const String usersCollection = 'users';
  static const String gamesCollection = 'games';
  static const String leaderboardCollection = 'leaderboard';
  static const String dailyChallengesCollection = 'daily_challenges';
  static const String achievementsCollection = 'achievements';
  static const String statsCollection = 'stats';
  
  // ========== USER FIELDS ==========
  static const String userId = 'userId';
  static const String username = 'username';
  static const String email = 'email';
  static const String photoUrl = 'photoUrl';
  static const String isPremium = 'isPremium';
  static const String createdAt = 'createdAt';
  static const String lastLoginAt = 'lastLoginAt';
  static const String isAnonymous = 'isAnonymous';
  static const String displayName = 'displayName';
  
  // ========== STATS FIELDS ==========
  static const String totalGamesPlayed = 'totalGamesPlayed';
  static const String totalGamesCompleted = 'totalGamesCompleted';
  static const String totalHintsUsed = 'totalHintsUsed';
  static const String winStreak = 'winStreak';
  static const String bestStreak = 'bestStreak';
  static const String lastPlayedDate = 'lastPlayedDate';
  static const String achievementsList = 'achievements';
  static const String bestTimes = 'bestTimes';
  static const String easyBestTime = 'easy';
  static const String mediumBestTime = 'medium';
  static const String hardBestTime = 'hard';
  static const String expertBestTime = 'expert';
  static const String totalPlayTime = 'totalPlayTime';
  static const String perfectGames = 'perfectGames';
  
  // ========== GAME FIELDS ==========
  static const String gameId = 'gameId';
  static const String puzzle = 'puzzle';
  static const String solution = 'solution';
  static const String userInput = 'userInput';
  static const String difficulty = 'difficulty';
  static const String startTime = 'startTime';
  static const String lastPlayedTime = 'lastPlayedTime';
  static const String isCompleted = 'isCompleted';
  static const String hintsUsed = 'hintsUsed';
  static const String timeSpent = 'timeSpent';
  static const String moves = 'moves';
  static const String notes = 'notes';
  static const String errorsMade = 'errorsMade';
  
  // ========== LEADERBOARD FIELDS ==========
  static const String rank = 'rank';
  static const String bestTime = 'bestTime';
  static const String totalSolved = 'totalSolved';
  static const String lastUpdated = 'lastUpdated';
  static const String score = 'score';
  
  // ========== DAILY CHALLENGE FIELDS ==========
  static const String date = 'date';
  static const String participants = 'participants';
  static const String completions = 'completions';
  static const String challengeId = 'challengeId';
  
  // ========== ACHIEVEMENT FIELDS ==========
  static const String achievementId = 'achievementId';
  static const String achievementName = 'name';
  static const String achievementDescription = 'description';
  static const String achievementIcon = 'icon';
  static const String unlockedAt = 'unlockedAt';
  static const String isUnlocked = 'isUnlocked';
  static const String progress = 'progress';
  static const String target = 'target';
  
  // ========== SUBCOLLECTIONS ==========
  static const String statsSubcollection = 'stats';
  static const String gamesSubcollection = 'games';
  static const String achievementsSubcollection = 'achievements';
  
  // ========== DIFFICULTY LEVELS ==========
  static const String difficultyEasy = 'easy';
  static const String difficultyMedium = 'medium';
  static const String difficultyHard = 'hard';
  static const String difficultyExpert = 'expert';
  
  // ========== ACHIEVEMENT IDS ==========
  static const String achievementFirstWin = 'first_win';
  static const String achievementSpeedDemon = 'speed_demon';
  static const String achievementPuzzleMaster = 'puzzle_master';
  static const String achievementStreakMaster = 'streak_master';
  static const String achievementNoHints = 'no_hints';
  static const String achievementDailyChampion = 'daily_champion';
  static const String achievementPerfectGame = 'perfect_game';
  static const String achievementMarathon = 'marathon';
  static const String achievementMaster100 = 'master_100';
  static const String achievementLightningFast = 'lightning_fast';
  
  // ========== LEADERBOARD FILTERS ==========
  static const String filterDaily = 'daily';
  static const String filterWeekly = 'weekly';
  static const String filterAllTime = 'all_time';
  
  // ========== HELPER METHODS ==========
  
  /// Get user document path
  static String getUserPath(String uid) {
    return '$usersCollection/$uid';
  }
  
  /// Get user stats path
  static String getUserStatsPath(String uid) {
    return '$usersCollection/$uid/$statsSubcollection';
  }
  
  /// Get user game path
  static String getUserGamePath(String uid, String gameId) {
    return '$usersCollection/$uid/$gamesSubcollection/$gameId';
  }
  
  /// Get leaderboard path by difficulty
  static String getLeaderboardPath(String difficulty) {
    return '$leaderboardCollection/$difficulty';
  }
  
  /// Get daily challenge path by date
  static String getDailyChallengePathByDate(String date) {
    return '$dailyChallengesCollection/$date';
  }
  
  /// Get all difficulty levels
  static List<String> getAllDifficulties() {
    return [
      difficultyEasy,
      difficultyMedium,
      difficultyHard,
      difficultyExpert,
    ];
  }
  
  /// Validate difficulty string
  static bool isValidDifficulty(String difficulty) {
    return getAllDifficulties().contains(difficulty.toLowerCase());
  }
  
  /// Get all achievement IDs
  static List<String> getAllAchievementIds() {
    return [
      achievementFirstWin,
      achievementSpeedDemon,
      achievementPuzzleMaster,
      achievementStreakMaster,
      achievementNoHints,
      achievementDailyChampion,
      achievementPerfectGame,
      achievementMarathon,
      achievementMaster100,
      achievementLightningFast,
    ];
  }
}