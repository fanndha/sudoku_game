/// File: lib/core/constants/app_strings.dart
/// Konstanta string untuk aplikasi Sudoku

class AppStrings {
  // Prevent instantiation
  AppStrings._();

  // App Info
  static const String appName = 'Sudoku Master';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Classic Sudoku Game with Online Leaderboard';
  
  // Authentication
  static const String signIn = 'Masuk';
  static const String signInWithGoogle = 'Masuk dengan Google';
  static const String signInAsGuest = 'Masuk sebagai Tamu';
  static const String signOut = 'Keluar';
  static const String signOutConfirm = 'Yakin ingin keluar?';
  static const String welcomeBack = 'Selamat Datang Kembali!';
  static const String welcome = 'Selamat Datang!';
  
  // Home
  static const String home = 'Beranda';
  static const String newGame = 'Permainan Baru';
  static const String continueGame = 'Lanjutkan Permainan';
  static const String noSavedGame = 'Tidak ada permainan tersimpan';
  static const String dailyChallenge = 'Tantangan Harian';
  static const String completeDailyChallenge = 'Selesaikan tantangan hari ini!';
  
  // Difficulty
  static const String selectDifficulty = 'Pilih Tingkat Kesulitan';
  static const String easy = 'Mudah';
  static const String medium = 'Sedang';
  static const String hard = 'Sulit';
  static const String expert = 'Ahli';
  static const String easyDescription = '35-40 angka terisi';
  static const String mediumDescription = '30-35 angka terisi';
  static const String hardDescription = '25-30 angka terisi';
  static const String expertDescription = '20-25 angka terisi';
  
  // Game
  static const String pause = 'Jeda';
  static const String resume = 'Lanjutkan';
  static const String restart = 'Mulai Ulang';
  static const String restartConfirm = 'Yakin ingin memulai ulang?';
  static const String hint = 'Petunjuk';
  static const String hintsRemaining = 'Petunjuk Tersisa';
  static const String watchAdForHint = 'Tonton iklan untuk petunjuk';
  static const String undo = 'Urungkan';
  static const String redo = 'Ulangi';
  static const String notes = 'Catatan';
  static const String erase = 'Hapus';
  static const String validate = 'Validasi';
  static const String solve = 'Selesaikan';
  static const String errorHighlight = 'Highlight Error';
  static const String autoValidate = 'Validasi Otomatis';
  
  // Game Status
  static const String gameComplete = 'Selamat! Puzzle Selesai!';
  static const String gameCompleteDescription = 'Kamu berhasil menyelesaikan puzzle!';
  static const String yourTime = 'Waktu Kamu';
  static const String newBestTime = 'Rekor Baru!';
  static const String hintsUsed = 'Petunjuk Digunakan';
  static const String moves = 'Langkah';
  static const String accuracy = 'Akurasi';
  static const String gamePaused = 'Permainan Dijeda';
  static const String gameOver = 'Permainan Selesai';
  
  // Timer
  static const String timer = 'Timer';
  static const String time = 'Waktu';
  static const String bestTime = 'Waktu Terbaik';
  static const String averageTime = 'Rata-rata Waktu';
  
  // Leaderboard
  static const String leaderboard = 'Papan Peringkat';
  static const String globalLeaderboard = 'Peringkat Global';
  static const String rank = 'Peringkat';
  static const String player = 'Pemain';
  static const String score = 'Skor';
  static const String solved = 'Diselesaikan';
  static const String daily = 'Harian';
  static const String weekly = 'Mingguan';
  static const String allTime = 'Sepanjang Masa';
  static const String yourRank = 'Peringkat Kamu';
  static const String notRanked = 'Belum Masuk Peringkat';
  static const String loadingLeaderboard = 'Memuat peringkat...';
  
  // Profile
  static const String profile = 'Profil';
  static const String statistics = 'Statistik';
  static const String achievements = 'Pencapaian';
  static const String gamesPlayed = 'Permainan Dimainkan';
  static const String gamesCompleted = 'Permainan Diselesaikan';
  static const String totalTime = 'Total Waktu';
  static const String winRate = 'Tingkat Kemenangan';
  static const String currentStreak = 'Streak Saat Ini';
  static const String bestStreak = 'Streak Terbaik';
  static const String totalHints = 'Total Petunjuk';
  static const String perfectGames = 'Permainan Sempurna';
  
  // Achievements
  static const String achievementUnlocked = 'Pencapaian Terbuka!';
  static const String firstWin = 'Kemenangan Pertama';
  static const String firstWinDesc = 'Selesaikan puzzle pertama kamu';
  static const String speedDemon = 'Speed Demon';
  static const String speedDemonDesc = 'Selesaikan puzzle dalam waktu kurang dari 5 menit';
  static const String puzzleMaster = 'Puzzle Master';
  static const String puzzleMasterDesc = 'Selesaikan 100 puzzle';
  static const String streakMaster = 'Streak Master';
  static const String streakMasterDesc = 'Raih streak 7 hari berturut-turut';
  static const String noHints = 'Tanpa Petunjuk';
  static const String noHintsDesc = 'Selesaikan puzzle tanpa menggunakan petunjuk';
  static const String dailyChampion = 'Daily Champion';
  static const String dailyChampionDesc = 'Selesaikan 30 tantangan harian';
  
  // Settings
  static const String settings = 'Pengaturan';
  static const String general = 'Umum';
  static const String gameplay = 'Permainan';
  static const String audio = 'Audio';
  static const String theme = 'Tema';
  static const String lightMode = 'Mode Terang';
  static const String darkMode = 'Mode Gelap';
  static const String systemDefault = 'Ikuti Sistem';
  static const String sound = 'Suara';
  static const String music = 'Musik';
  static const String vibration = 'Getaran';
  static const String notifications = 'Notifikasi';
  static const String language = 'Bahasa';
  
  // Store / IAP
  static const String store = 'Toko';
  static const String premium = 'Premium';
  static const String buyPremium = 'Beli Premium';
  static const String premiumFeatures = 'Fitur Premium';
  static const String unlimitedHints = 'Petunjuk Tanpa Batas';
  static const String removeAds = 'Hapus Semua Iklan';
  static const String exclusiveThemes = 'Tema Eksklusif';
  static const String prioritySupport = 'Dukungan Prioritas';
  static const String hintPack = 'Paket Petunjuk';
  static const String buyHintPack = 'Beli 20 Petunjuk';
  static const String restorePurchases = 'Pulihkan Pembelian';
  static const String purchaseSuccess = 'Pembelian Berhasil!';
  static const String purchaseFailed = 'Pembelian Gagal';
  static const String purchaseRestored = 'Pembelian Dipulihkan';
  
  // Ads
  static const String watchAd = 'Tonton Iklan';
  static const String adLoading = 'Memuat iklan...';
  static const String adNotAvailable = 'Iklan tidak tersedia';
  static const String adWatched = 'Terima kasih telah menonton!';
  
  // Errors
  static const String error = 'Error';
  static const String errorOccurred = 'Terjadi kesalahan';
  static const String tryAgain = 'Coba Lagi';
  static const String noInternet = 'Tidak ada koneksi internet';
  static const String serverError = 'Error server';
  static const String unknownError = 'Error tidak diketahui';
  static const String authError = 'Error autentikasi';
  static const String invalidInput = 'Input tidak valid';
  static const String gameNotFound = 'Permainan tidak ditemukan';
  static const String userNotFound = 'User tidak ditemukan';
  
  // Dialogs
  static const String confirm = 'Konfirmasi';
  static const String cancel = 'Batal';
  static const String ok = 'OK';
  static const String yes = 'Ya';
  static const String no = 'Tidak';
  static const String save = 'Simpan';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String done = 'Selesai';
  static const String close = 'Tutup';
  static const String skip = 'Lewati';
  static const String next = 'Selanjutnya';
  static const String previous = 'Sebelumnya';
  static const String finish = 'Selesai';
  
  // Loading
  static const String loading = 'Memuat...';
  static const String loadingGame = 'Memuat permainan...';
  static const String generatingPuzzle = 'Membuat puzzle...';
  static const String savingProgress = 'Menyimpan progres...';
  static const String syncing = 'Sinkronisasi...';
  
  // Empty States
  static const String noData = 'Tidak ada data';
  static const String noGames = 'Belum ada permainan';
  static const String noAchievements = 'Belum ada pencapaian';
  static const String noStats = 'Belum ada statistik';
  
  // Tutorial
  static const String tutorial = 'Tutorial';
  static const String howToPlay = 'Cara Bermain';
  static const String tutorialStep1 = 'Isi setiap baris dengan angka 1-9';
  static const String tutorialStep2 = 'Isi setiap kolom dengan angka 1-9';
  static const String tutorialStep3 = 'Isi setiap kotak 3x3 dengan angka 1-9';
  static const String tutorialStep4 = 'Tidak boleh ada angka yang sama dalam baris, kolom, atau kotak';
  static const String tutorialStep5 = 'Gunakan mode catatan untuk menandai kemungkinan angka';
  
  // Notifications
  static const String dailyChallengeAvailable = 'Tantangan harian tersedia!';
  static const String comeBackTomorrow = 'Kembali besok untuk tantangan baru';
  static const String streakAlert = 'Jangan putus streak kamu!';
  
  // Sync
  static const String syncSuccess = 'Sinkronisasi berhasil';
  static const String syncFailed = 'Sinkronisasi gagal';
  static const String offlineMode = 'Mode Offline';
  static const String onlineMode = 'Mode Online';
  static const String syncingData = 'Menyinkronkan data...';
  
  // Misc
  static const String about = 'Tentang';
  static const String version = 'Versi';
  static const String developer = 'Pengembang';
  static const String rateApp = 'Beri Rating';
  static const String shareApp = 'Bagikan Aplikasi';
  static const String privacyPolicy = 'Kebijakan Privasi';
  static const String termsOfService = 'Syarat Layanan';
  static const String feedback = 'Kirim Feedback';
  static const String support = 'Dukungan';
  static const String help = 'Bantuan';
  static const String logout = 'Logout';
}