/// File: lib/core/usecases/usecase.dart
/// Base class untuk semua use cases
/// Menggunakan Either dari dartz untuk functional error handling

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base UseCase dengan parameter dan return type generic
///
/// Type adalah return type dari use case
/// Params adalah parameter type yang dibutuhkan
///
/// Return Either<Failure, Type>:
/// - Left untuk Failure (error case)
/// - Right untuk Type (success case)
abstract class UseCase<Type, Params> {
  /// Execute use case dengan parameter
  Future<Either<Failure, Type>> call(Params params);
}

/// UseCase tanpa parameter
/// Gunakan NoParams sebagai Params type
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Class untuk use case yang tidak membutuhkan parameter
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Base class untuk Params dengan validasi
abstract class Params extends Equatable {
  /// Validate params sebelum digunakan
  /// Return null jika valid, return error message jika invalid
  String? validate() => null;

  /// Check apakah params valid
  bool get isValid => validate() == null;
}

/// Example Params implementation
/// Gunakan ini sebagai template untuk params lainnya
class ExampleParams extends Params {
  final String id;
  final String? name;

  ExampleParams({required this.id, this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String? validate() {
    if (id.isEmpty) {
      return 'ID cannot be empty';
    }
    return null;
  }
}
