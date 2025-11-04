/// File: lib/features/game/data/datasources/game_local_datasource.dart
/// Local data source untuk game (Hive/SharedPreferences)

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/game_state_model.dart';

/// Abstract class untuk Game Local Data Source
abstract class GameLocalDataSource {
  /// Save game state
  Future<void> saveGame(GameStateModel gameState);
  
  /// Load game state
  Future<GameStateModel?> loadGame(String gameId);
  
  /// Get all saved games
  Future<List<GameStateModel>> getAllSavedGames();
  
  /// Delete game
  Future<void> deleteGame(String gameId);
  
  /// Clear all games
  Future<void> clearAllGames();
}

/// Implementation menggunakan SharedPreferences
class GameLocalDataSourceImpl implements GameLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Keys
  static const String gameKeyPrefix = 'GAME_';
  static const String gameListKey = 'GAME_LIST';

  GameLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveGame(GameStateModel gameState) async {
    try {
      logger.hive(
        'WRITE',
        'SharedPreferences',
        key: '$gameKeyPrefix${gameState.gameId}',
      );

      final jsonString = json.encode(gameState.toJson());
      final key = '$gameKeyPrefix${gameState.gameId}';
      
      final success = await sharedPreferences.setString(key, jsonString);

      if (!success) {
        throw CacheException(message: 'Failed to save game');
      }

      // Update game list
      await _addToGameList(gameState.gameId);

      logger.i('Game saved successfully: ${gameState.gameId}', tag: 'GameLocal');
    } catch (e) {
      logger.e('Error saving game', error: e, tag: 'GameLocal');
      throw CacheException(
        message: 'Gagal menyimpan game: ${e.toString()}',
      );
    }
  }

  @override
  Future<GameStateModel?> loadGame(String gameId) async {
    try {
      logger.hive('READ', 'SharedPreferences', key: '$gameKeyPrefix$gameId');

      final key = '$gameKeyPrefix$gameId';
      final jsonString = sharedPreferences.getString(key);

      if (jsonString == null) {
        logger.d('Game not found: $gameId', tag: 'GameLocal');
        return null;
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final gameState = GameStateModel.fromJson(jsonMap);

      logger.i('Game loaded successfully: $gameId', tag: 'GameLocal');
      return gameState;
    } catch (e) {
      logger.e('Error loading game', error: e, tag: 'GameLocal');
      throw CacheException(
        message: 'Gagal memuat game: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<GameStateModel>> getAllSavedGames() async {
    try {
      logger.hive('READ', 'SharedPreferences', key: gameListKey);

      final gameIds = await _getGameList();
      final games = <GameStateModel>[];

      for (final gameId in gameIds) {
        try {
          final game = await loadGame(gameId);
          if (game != null) {
            games.add(game);
          }
        } catch (e) {
          logger.w('Error loading game $gameId: $e', tag: 'GameLocal');
          // Continue with other games
        }
      }

      logger.i('Loaded ${games.length} games', tag: 'GameLocal');
      return games;
    } catch (e) {
      logger.e('Error getting all games', error: e, tag: 'GameLocal');
      throw CacheException(
        message: 'Gagal memuat daftar game: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteGame(String gameId) async {
    try {
      logger.hive('DELETE', 'SharedPreferences', key: '$gameKeyPrefix$gameId');

      final key = '$gameKeyPrefix$gameId';
      final success = await sharedPreferences.remove(key);

      if (!success) {
        throw CacheException(message: 'Failed to delete game');
      }

      // Remove from game list
      await _removeFromGameList(gameId);

      logger.i('Game deleted successfully: $gameId', tag: 'GameLocal');
    } catch (e) {
      logger.e('Error deleting game', error: e, tag: 'GameLocal');
      throw CacheException(
        message: 'Gagal menghapus game: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearAllGames() async {
    try {
      final gameIds = await _getGameList();

      for (final gameId in gameIds) {
        await deleteGame(gameId);
      }

      await sharedPreferences.remove(gameListKey);

      logger.i('All games cleared', tag: 'GameLocal');
    } catch (e) {
      logger.e('Error clearing all games', error: e, tag: 'GameLocal');
      throw CacheException(
        message: 'Gagal menghapus semua game: ${e.toString()}',
      );
    }
  }

  // ========== HELPER METHODS ==========

  /// Get list of saved game IDs
  Future<List<String>> _getGameList() async {
    try {
      final jsonString = sharedPreferences.getString(gameListKey);
      
      if (jsonString == null) {
        return [];
      }

      final list = json.decode(jsonString) as List<dynamic>;
      return list.map((e) => e as String).toList();
    } catch (e) {
      logger.w('Error getting game list: $e', tag: 'GameLocal');
      return [];
    }
  }

  /// Add game ID to list
  Future<void> _addToGameList(String gameId) async {
    try {
      final gameIds = await _getGameList();
      
      if (!gameIds.contains(gameId)) {
        gameIds.add(gameId);
        final jsonString = json.encode(gameIds);
        await sharedPreferences.setString(gameListKey, jsonString);
      }
    } catch (e) {
      logger.w('Error adding to game list: $e', tag: 'GameLocal');
    }
  }

  /// Remove game ID from list
  Future<void> _removeFromGameList(String gameId) async {
    try {
      final gameIds = await _getGameList();
      
      if (gameIds.contains(gameId)) {
        gameIds.remove(gameId);
        final jsonString = json.encode(gameIds);
        await sharedPreferences.setString(gameListKey, jsonString);
      }
    } catch (e) {
      logger.w('Error removing from game list: $e', tag: 'GameLocal');
    }
  }
}