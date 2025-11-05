/// File: lib/features/leaderboard/data/datasources/leaderboard_remote_datasource.dart
/// Remote data source untuk leaderboard (Firestore)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudoku_game/core/constants/firebase_constans.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/leaderboard_entry_model.dart';

/// Abstract class untuk Leaderboard Remote Data Source
abstract class LeaderboardRemoteDataSource {
  /// Get leaderboard
  Future<List<LeaderboardEntryModel>> getLeaderboard({
    required String difficulty,
    required String filter,
    int limit = 100,
  });

  /// Update leaderboard
  Future<void> updateLeaderboard({
    required String userId,
    required String username,
    required String? photoUrl,
    required String difficulty,
    required int bestTime,
    required int totalSolved,
    required bool isPremium,
  });

  /// Get user rank
  Future<LeaderboardEntryModel?> getUserRank({
    required String userId,
    required String difficulty,
    required String filter,
  });
}

/// Implementation
class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final FirebaseFirestore firestore;

  LeaderboardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard({
    required String difficulty,
    required String filter,
    int limit = 100,
  }) async {
    try {
      logger.firebase(
        'GET',
        '${FirebaseConstants.leaderboardCollection}/$difficulty',
      );

      Query query = firestore
          .collection(FirebaseConstants.leaderboardCollection)
          .doc(difficulty)
          .collection('entries');

      // Apply filter
      final now = DateTime.now();
      if (filter == 'daily') {
        final startOfDay = DateTime(now.year, now.month, now.day);
        query = query.where(
          'lastUpdated',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        );
      } else if (filter == 'weekly') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDay = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        query = query.where(
          'lastUpdated',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeekDay),
        );
      }

      // Order by best time and limit
      query = query.orderBy('bestTime').limit(limit);

      final snapshot = await query.get();

      final entries = <LeaderboardEntryModel>[];
      int rank = 1;

      for (final doc in snapshot.docs) {
        try {
          entries.add(LeaderboardEntryModel.fromFirestore(doc, rank));
          rank++;
        } catch (e) {
          logger.w('Error parsing leaderboard entry: $e', tag: 'Leaderboard');
        }
      }

      logger.i(
        'Loaded ${entries.length} leaderboard entries',
        tag: 'Leaderboard',
      );
      return entries;
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'Leaderboard');
      throw FirestoreException(
        message: e.message ?? 'Gagal memuat leaderboard',
        code: e.code,
      );
    } catch (e) {
      logger.e(
        'Unknown error getting leaderboard',
        error: e,
        tag: 'Leaderboard',
      );
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateLeaderboard({
    required String userId,
    required String username,
    required String? photoUrl,
    required String difficulty,
    required int bestTime,
    required int totalSolved,
    required bool isPremium,
  }) async {
    try {
      logger.firebase(
        'SET',
        '${FirebaseConstants.leaderboardCollection}/$difficulty/entries',
        documentId: userId,
      );

      final entry = LeaderboardEntryModel(
        userId: userId,
        username: username,
        photoUrl: photoUrl,
        rank: 0, // Will be calculated by query
        bestTime: bestTime,
        totalSolved: totalSolved,
        lastUpdated: DateTime.now(),
        isPremium: isPremium,
      );

      await firestore
          .collection(FirebaseConstants.leaderboardCollection)
          .doc(difficulty)
          .collection('entries')
          .doc(userId)
          .set(entry.toFirestore(), SetOptions(merge: true));

      logger.i('Leaderboard updated successfully', tag: 'Leaderboard');
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'Leaderboard');
      throw FirestoreException(
        message: e.message ?? 'Gagal update leaderboard',
        code: e.code,
      );
    } catch (e) {
      logger.e(
        'Unknown error updating leaderboard',
        error: e,
        tag: 'Leaderboard',
      );
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<LeaderboardEntryModel?> getUserRank({
    required String userId,
    required String difficulty,
    required String filter,
  }) async {
    try {
      logger.firebase(
        'GET',
        '${FirebaseConstants.leaderboardCollection}/$difficulty/entries',
        documentId: userId,
      );

      // Get user's entry
      final userDoc = await firestore
          .collection(FirebaseConstants.leaderboardCollection)
          .doc(difficulty)
          .collection('entries')
          .doc(userId)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        logger.d('User not found in leaderboard', tag: 'Leaderboard');
        return null;
      }

      final userData = userDoc.data()!;
      final userBestTime = userData['bestTime'] as int;

      // Count how many users have better time
      Query query = firestore
          .collection(FirebaseConstants.leaderboardCollection)
          .doc(difficulty)
          .collection('entries')
          .where('bestTime', isLessThan: userBestTime);

      // Apply filter
      final now = DateTime.now();
      if (filter == 'daily') {
        final startOfDay = DateTime(now.year, now.month, now.day);
        query = query.where(
          'lastUpdated',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        );
      } else if (filter == 'weekly') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDay = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        query = query.where(
          'lastUpdated',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeekDay),
        );
      }

      final betterCount = await query.count().get();
      final rank = betterCount.count! + 1;

      final entry = LeaderboardEntryModel.fromFirestore(userDoc, rank);

      logger.i('User rank: $rank', tag: 'Leaderboard');
      return entry;
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'Leaderboard');
      throw FirestoreException(
        message: e.message ?? 'Gagal mendapatkan rank',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error getting user rank', error: e, tag: 'Leaderboard');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }
}
