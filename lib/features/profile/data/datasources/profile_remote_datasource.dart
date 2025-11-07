/// File: lib/features/profile/data/datasources/profile_remote_datasource.dart
/// Remote data source untuk profile (Firestore)

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constans.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/achievement_model.dart';
import '../models/stats_model.dart';

/// Abstract class untuk Profile Remote Data Source
abstract class ProfileRemoteDataSource {
  /// Get user stats
  Future<StatsModel> getUserStats(String userId);

  /// Update user stats
  Future<void> updateUserStats(String userId, Map<String, dynamic> stats);

  /// Get achievements
  Future<List<AchievementModel>> getAchievements(String userId);

  /// Unlock achievement
  Future<AchievementModel> unlockAchievement(String userId, String achievementId);

  /// Update achievement progress
  Future<void> updateAchievementProgress(
    String userId,
    String achievementId,
    int progress,
  );
}

/// Implementation
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<StatsModel> getUserStats(String userId) async {
    try {
      logger.firebase(
        'GET',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.statsSubcollection}',
      );

      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.statsSubcollection)
          .doc('stats')
          .get();

      if (!doc.exists || doc.data() == null) {
        logger.w('Stats not found, creating default', tag: 'ProfileRemote');
        return _createDefaultStats(userId);
      }

      logger.i('Stats loaded successfully', tag: 'ProfileRemote');
      return StatsModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: e.message ?? 'Gagal memuat statistik',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error getting stats', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateUserStats(
    String userId,
    Map<String, dynamic> stats,
  ) async {
    try {
      logger.firebase(
        'UPDATE',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.statsSubcollection}',
        data: stats,
      );

      // Add lastUpdated timestamp
      stats['lastUpdated'] = Timestamp.now();

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.statsSubcollection)
          .doc('stats')
          .set(stats, SetOptions(merge: true));

      logger.i('Stats updated successfully', tag: 'ProfileRemote');
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: e.message ?? 'Gagal memperbarui statistik',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error updating stats', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<AchievementModel>> getAchievements(String userId) async {
    try {
      logger.firebase(
        'GET',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.achievementsSubcollection}',
      );

      final snapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.achievementsSubcollection)
          .get();

      final achievements = <AchievementModel>[];
      for (final doc in snapshot.docs) {
        try {
          achievements.add(AchievementModel.fromFirestore(doc));
        } catch (e) {
          logger.w('Error parsing achievement: $e', tag: 'ProfileRemote');
        }
      }

      logger.i('Loaded ${achievements.length} achievements', tag: 'ProfileRemote');
      return achievements;
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: e.message ?? 'Gagal memuat pencapaian',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error getting achievements', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<AchievementModel> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      logger.firebase(
        'UPDATE',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.achievementsSubcollection}/$achievementId',
      );

      final now = Timestamp.now();
      final data = {
        'isUnlocked': true,
        'unlockedAt': now,
      };

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.achievementsSubcollection)
          .doc(achievementId)
          .set(data, SetOptions(merge: true));

      // Get updated achievement
      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.achievementsSubcollection)
          .doc(achievementId)
          .get();

      logger.i('Achievement unlocked: $achievementId', tag: 'ProfileRemote');
      return AchievementModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: e.message ?? 'Gagal membuka pencapaian',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error unlocking achievement', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateAchievementProgress(
    String userId,
    String achievementId,
    int progress,
  ) async {
    try {
      logger.firebase(
        'UPDATE',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.achievementsSubcollection}/$achievementId',
        data: {'progress': progress},
      );

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.achievementsSubcollection)
          .doc(achievementId)
          .set({'progress': progress}, SetOptions(merge: true));

      logger.i('Achievement progress updated: $achievementId = $progress', tag: 'ProfileRemote');
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: e.message ?? 'Gagal memperbarui progress',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unknown error updating progress', error: e, tag: 'ProfileRemote');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  /// Create default stats for new user
  StatsModel _createDefaultStats(String userId) {
    return StatsModel(
      userId: userId,
      username: 'Player',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }
}