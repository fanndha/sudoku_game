/// File: lib/features/daily_challenge/data/datasources/daily_challenge_remote_datasource.dart
/// Remote data source untuk daily challenge (Firebase)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudoku_game/core/constants/firebase_constans.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/daily_challenge_model.dart';

/// Abstract class untuk Daily Challenge Remote Data Source
abstract class DailyChallengeRemoteDataSource {
  /// Get today's challenge from Firebase
  Future<DailyChallengeModel> getTodayChallenge(String userId);

  /// Get challenge by date
  Future<DailyChallengeModel> getChallengeByDate(String date, String userId);

  /// Submit challenge completion
  Future<void> submitCompletion({
    required String challengeId,
    required String userId,
    required int timeSpent,
    required int hintsUsed,
    required int moves,
  });

  /// Get user's completion history
  Future<List<DailyChallengeModel>> getCompletionHistory(String userId);

  /// Check if user completed today's challenge
  Future<bool> hasCompletedToday(String userId);
}

/// Implementation
class DailyChallengeRemoteDataSourceImpl
    implements DailyChallengeRemoteDataSource {
  final FirebaseFirestore firestore;

  DailyChallengeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<DailyChallengeModel> getTodayChallenge(String userId) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      logger.firebase(
        'GET',
        FirebaseConstants.dailyChallengesCollection,
        documentId: dateStr,
      );

      final doc = await firestore
          .collection(FirebaseConstants.dailyChallengesCollection)
          .doc(dateStr)
          .get();

      if (!doc.exists) {
        throw DocumentNotFoundException(
          message: 'Daily challenge not found for date: $dateStr',
        );
      }

      final challenge = DailyChallengeModel.fromFirestore(doc);

      // Check if user completed this challenge
      final userCompletion = await _getUserCompletion(userId, dateStr);

      if (userCompletion != null) {
        return challenge.copyWith(
          isCompleted: true,
          userBestTime: userCompletion['userBestTime'] as String?,
          completedAt: userCompletion['completedAt'] != null
              ? (userCompletion['completedAt'] as Timestamp).toDate()
              : null,
          userScore: userCompletion['userScore'] as int?,
        );
      }

      logger.i('Loaded today\'s challenge: $dateStr', tag: 'DailyChallengeRemote');
      return challenge;
    } on FirebaseException catch (e) {
      logger.e('Firebase error: ${e.message}', tag: 'DailyChallengeRemote');
      throw FirestoreException(
        message: e.message ?? 'Failed to get daily challenge',
        code: e.code,
      );
    } catch (e) {
      logger.e('Error getting daily challenge', error: e, tag: 'DailyChallengeRemote');
      rethrow;
    }
  }

  @override
  Future<DailyChallengeModel> getChallengeByDate(
    String date,
    String userId,
  ) async {
    try {
      logger.firebase(
        'GET',
        FirebaseConstants.dailyChallengesCollection,
        documentId: date,
      );

      final doc = await firestore
          .collection(FirebaseConstants.dailyChallengesCollection)
          .doc(date)
          .get();

      if (!doc.exists) {
        throw DocumentNotFoundException(
          message: 'Daily challenge not found for date: $date',
        );
      }

      final challenge = DailyChallengeModel.fromFirestore(doc);

      // Check if user completed this challenge
      final userCompletion = await _getUserCompletion(userId, date);

      if (userCompletion != null) {
        return challenge.copyWith(
          isCompleted: true,
          userBestTime: userCompletion['userBestTime'] as String?,
          completedAt: userCompletion['completedAt'] != null
              ? (userCompletion['completedAt'] as Timestamp).toDate()
              : null,
          userScore: userCompletion['userScore'] as int?,
        );
      }

      return challenge;
    } on FirebaseException catch (e) {
      logger.e('Firebase error: ${e.message}', tag: 'DailyChallengeRemote');
      throw FirestoreException(
        message: e.message ?? 'Failed to get challenge',
        code: e.code,
      );
    } catch (e) {
      logger.e('Error getting challenge', error: e, tag: 'DailyChallengeRemote');
      rethrow;
    }
  }

  @override
  Future<void> submitCompletion({
    required String challengeId,
    required String userId,
    required int timeSpent,
    required int hintsUsed,
    required int moves,
  }) async {
    try {
      logger.firebase(
        'SET',
        'users/$userId/daily_completions',
        documentId: challengeId,
      );

      final batch = firestore.batch();

      // Calculate score (example formula)
      final score = _calculateScore(timeSpent, hintsUsed, moves);

      // Save user completion
      final completionRef = firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection('daily_completions')
          .doc(challengeId);

      batch.set(completionRef, {
        'challengeId': challengeId,
        'completedAt': FieldValue.serverTimestamp(),
        'timeSpent': timeSpent,
        'hintsUsed': hintsUsed,
        'moves': moves,
        'userScore': score,
        'userBestTime': _formatTime(timeSpent),
      });

      // Update challenge stats
      final challengeRef = firestore
          .collection(FirebaseConstants.dailyChallengesCollection)
          .doc(challengeId);

      batch.update(challengeRef, {
        'completionsCount': FieldValue.increment(1),
      });

      await batch.commit();

      logger.i('Challenge completion submitted', tag: 'DailyChallengeRemote');
    } on FirebaseException catch (e) {
      logger.e('Firebase error: ${e.message}', tag: 'DailyChallengeRemote');
      throw FirestoreException(
        message: e.message ?? 'Failed to submit completion',
        code: e.code,
      );
    } catch (e) {
      logger.e('Error submitting completion', error: e, tag: 'DailyChallengeRemote');
      throw ServerException(
        message: 'Failed to submit completion: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DailyChallengeModel>> getCompletionHistory(String userId) async {
    try {
      logger.firebase(
        'GET',
        'users/$userId/daily_completions',
      );

      final snapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection('daily_completions')
          .orderBy('completedAt', descending: true)
          .limit(30)
          .get();

      final completions = <DailyChallengeModel>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final challengeId = data['challengeId'] as String;

        // Get challenge data
        final challengeDoc = await firestore
            .collection(FirebaseConstants.dailyChallengesCollection)
            .doc(challengeId)
            .get();

        if (challengeDoc.exists) {
          final challenge = DailyChallengeModel.fromFirestore(challengeDoc);
          completions.add(
            challenge.copyWith(
              isCompleted: true,
              userBestTime: data['userBestTime'] as String?,
              completedAt: data['completedAt'] != null
                  ? (data['completedAt'] as Timestamp).toDate()
                  : null,
              userScore: data['userScore'] as int?,
            ),
          );
        }
      }

      logger.i('Loaded ${completions.length} completions', tag: 'DailyChallengeRemote');
      return completions;
    } on FirebaseException catch (e) {
      logger.e('Firebase error: ${e.message}', tag: 'DailyChallengeRemote');
      throw FirestoreException(
        message: e.message ?? 'Failed to get history',
        code: e.code,
      );
    } catch (e) {
      logger.e('Error getting history', error: e, tag: 'DailyChallengeRemote');
      throw ServerException(
        message: 'Failed to get history: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> hasCompletedToday(String userId) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final completion = await _getUserCompletion(userId, dateStr);
      return completion != null;
    } catch (e) {
      logger.e('Error checking completion', error: e, tag: 'DailyChallengeRemote');
      return false;
    }
  }

  /// Helper: Get user completion for a challenge
  Future<Map<String, dynamic>?> _getUserCompletion(
    String userId,
    String challengeId,
  ) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection('daily_completions')
          .doc(challengeId)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Helper: Calculate score
  int _calculateScore(int timeSpent, int hintsUsed, int moves) {
    // Example scoring formula:
    // Base score: 1000
    // -1 point per second
    // -50 points per hint
    // -2 points per move over 81

    int score = 1000;
    score -= timeSpent; // Time penalty
    score -= hintsUsed * 50; // Hint penalty
    score -= (moves - 81) * 2; // Extra moves penalty

    return score < 0 ? 0 : score;
  }

  /// Helper: Format time
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}