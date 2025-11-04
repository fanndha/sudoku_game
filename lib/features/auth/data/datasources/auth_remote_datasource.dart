/// File: lib/features/auth/data/datasources/auth_remote_datasource.dart
/// Remote data source untuk authentication (Firebase)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/firebase_constans.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

/// Abstract class untuk Auth Remote Data Source
abstract class AuthRemoteDataSource {
  /// Sign in dengan Google
  Future<UserModel> signInWithGoogle();
  
  /// Sign in sebagai anonymous
  Future<UserModel> signInAnonymous();
  
  /// Sign out
  Future<void> signOut();
  
  /// Get current user
  Future<UserModel?> getCurrentUser();
  
  /// Check apakah user sudah login
  Future<bool> isSignedIn();
  
  /// Update user data ke Firestore
  Future<void> updateUserData(UserModel user);
  
  /// Get user data dari Firestore
  Future<UserModel> getUserData(String uid);
}

/// Implementation dari AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      logger.i('Starting Google Sign In...', tag: 'Auth');

      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled sign in
        logger.w('User cancelled Google Sign In', tag: 'Auth');
        throw UserCancelledException(
          message: 'User membatalkan login dengan Google',
        );
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with credential
      final UserCredential userCredential = 
          await firebaseAuth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw AuthException(message: 'Failed to sign in with Google');
      }

      logger.i('Google Sign In successful: ${firebaseUser.uid}', tag: 'Auth');

      // Create user model
      final userModel = UserModel.fromFirebaseUser(firebaseUser);

      // Save/update user data to Firestore
      await updateUserData(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code}', error: e, tag: 'Auth');
      
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw AuthException(
            message: 'Akun sudah terdaftar dengan metode login lain',
            code: e.code,
          );
        case 'invalid-credential':
          throw InvalidCredentialsException(
            message: 'Kredensial tidak valid',
            code: e.code,
          );
        case 'operation-not-allowed':
          throw AuthException(
            message: 'Metode login ini tidak diaktifkan',
            code: e.code,
          );
        case 'user-disabled':
          throw AuthException(
            message: 'Akun ini telah dinonaktifkan',
            code: e.code,
          );
        case 'user-not-found':
          throw UserNotFoundException(code: e.code);
        default:
          throw AuthException(
            message: e.message ?? 'Terjadi kesalahan saat login',
            code: e.code,
          );
      }
    } catch (e) {
      logger.e('Unexpected error during Google Sign In', error: e, tag: 'Auth');
      
      if (e is UserCancelledException) {
        rethrow;
      }
      
      throw AuthException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> signInAnonymous() async {
    try {
      logger.i('Starting Anonymous Sign In...', tag: 'Auth');

      final UserCredential userCredential = 
          await firebaseAuth.signInAnonymously();

      final User? firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw AuthException(message: 'Failed to sign in anonymously');
      }

      logger.i('Anonymous Sign In successful: ${firebaseUser.uid}', tag: 'Auth');

      // Create user model
      final userModel = UserModel.fromFirebaseUser(firebaseUser);

      // Save user data to Firestore
      await updateUserData(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code}', error: e, tag: 'Auth');
      throw AuthException(
        message: e.message ?? 'Gagal login sebagai guest',
        code: e.code,
      );
    } catch (e) {
      logger.e('Unexpected error during Anonymous Sign In', error: e, tag: 'Auth');
      throw AuthException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      logger.i('Signing out...', tag: 'Auth');

      // Sign out dari Google jika ada
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Sign out dari Firebase
      await firebaseAuth.signOut();

      logger.i('Sign out successful', tag: 'Auth');
    } catch (e) {
      logger.e('Error during sign out', error: e, tag: 'Auth');
      throw AuthException(
        message: 'Gagal logout: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = firebaseAuth.currentUser;
      
      if (firebaseUser == null) {
        logger.d('No current user', tag: 'Auth');
        return null;
      }

      logger.d('Current user: ${firebaseUser.uid}', tag: 'Auth');

      // Try to get user data from Firestore
      try {
        return await getUserData(firebaseUser.uid);
      } catch (e) {
        // If Firestore data not found, create from Firebase user
        logger.w('User data not found in Firestore, creating from Firebase user', tag: 'Auth');
        final userModel = UserModel.fromFirebaseUser(firebaseUser);
        await updateUserData(userModel);
        return userModel;
      }
    } catch (e) {
      logger.e('Error getting current user', error: e, tag: 'Auth');
      return null;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final user = firebaseAuth.currentUser;
    final signedIn = user != null;
    logger.d('Is signed in: $signedIn', tag: 'Auth');
    return signedIn;
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    try {
      logger.firebase(
        'UPDATE',
        FirebaseConstants.usersCollection,
        documentId: user.uid,
        data: user.toFirestore(),
      );

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(
            user.toFirestore(),
            SetOptions(merge: true), // Merge untuk tidak overwrite data lain
          );

      logger.i('User data updated successfully', tag: 'Auth');
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'Auth');
      
      switch (e.code) {
        case 'permission-denied':
          throw PermissionDeniedException(code: e.code);
        case 'unavailable':
          throw NetworkException(
            message: 'Firestore tidak tersedia',
            code: e.code,
          );
        default:
          throw FirestoreException(
            message: e.message ?? 'Gagal menyimpan data user',
            code: e.code,
          );
      }
    } catch (e) {
      logger.e('Unexpected error updating user data', error: e, tag: 'Auth');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> getUserData(String uid) async {
    try {
      logger.firebase(
        'GET',
        FirebaseConstants.usersCollection,
        documentId: uid,
      );

      final DocumentSnapshot doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        logger.w('User document not found: $uid', tag: 'Auth');
        throw DocumentNotFoundException(
          message: 'Data user tidak ditemukan',
        );
      }

      final userModel = UserModel.fromFirestore(doc);
      logger.i('User data retrieved successfully', tag: 'Auth');
      
      return userModel;
    } on FirebaseException catch (e) {
      logger.e('Firestore error: ${e.code}', error: e, tag: 'Auth');
      
      switch (e.code) {
        case 'permission-denied':
          throw PermissionDeniedException(code: e.code);
        case 'unavailable':
          throw NetworkException(
            message: 'Firestore tidak tersedia',
            code: e.code,
          );
        default:
          throw FirestoreException(
            message: e.message ?? 'Gagal mengambil data user',
            code: e.code,
          );
      }
    } catch (e) {
      if (e is DocumentNotFoundException) {
        rethrow;
      }
      
      logger.e('Unexpected error getting user data', error: e, tag: 'Auth');
      throw FirestoreException(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }
}