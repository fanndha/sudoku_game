/// File: lib/features/game/data/models/cell_model.dart
/// Cell model untuk data layer (extends CellEntity)

import '../../domain/entities/cell_entity.dart';

/// Cell Model - Data Transfer Object
class CellModel extends CellEntity {
  const CellModel({
    required super.row,
    required super.column,
    super.value,
    super.isFixed,
    super.isError,
    super.notes,
  });

  /// Create CellModel from CellEntity
  factory CellModel.fromEntity(CellEntity entity) {
    return CellModel(
      row: entity.row,
      column: entity.column,
      value: entity.value,
      isFixed: entity.isFixed,
      isError: entity.isError,
      notes: entity.notes,
    );
  }

  /// Create CellModel from JSON
  factory CellModel.fromJson(Map<String, dynamic> json) {
    return CellModel(
      row: json['row'] as int,
      column: json['column'] as int,
      value: json['value'] as int?,
      isFixed: json['isFixed'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  /// Convert CellModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'column': column,
      'value': value,
      'isFixed': isFixed,
      'isError': isError,
      'notes': notes,
    };
  }

  /// Create empty cell
  factory CellModel.empty(int row, int column) {
    return CellModel(
      row: row,
      column: column,
      value: null,
      isFixed: false,
      isError: false,
      notes: [],
    );
  }

  /// Create fixed cell (initial puzzle cell)
  factory CellModel.fixed(int row, int column, int value) {
    return CellModel(
      row: row,
      column: column,
      value: value,
      isFixed: true,
      isError: false,
      notes: [],
    );
  }

  /// Copy with method
  CellModel copyWith({
    int? row,
    int? column,
    int? value,
    bool? isFixed,
    bool? isError,
    List<int>? notes,
  }) {
    return CellModel(
      row: row ?? this.row,
      column: column ?? this.column,
      value: value ?? this.value,
      isFixed: isFixed ?? this.isFixed,
      isError: isError ?? this.isError,
      notes: notes ?? this.notes,
    );
  }

  /// Clear value (set to null)
  CellModel clearValue() {
    return copyWith(value: null, isError: false);
  }

  /// Set value
  CellModel setValue(int newValue) {
    return copyWith(value: newValue, notes: []);
  }

  /// Set error state
  CellModel setError(bool hasError) {
    return copyWith(isError: hasError);
  }

  /// Add note
  CellModel addNote(int note) {
    if (notes.contains(note)) return this;
    final newNotes = List<int>.from(notes)..add(note);
    newNotes.sort();
    return copyWith(notes: newNotes, value: null);
  }

  /// Remove note
  CellModel removeNote(int note) {
    if (!notes.contains(note)) return this;
    final newNotes = List<int>.from(notes)..remove(note);
    return copyWith(notes: newNotes);
  }

  /// Toggle note
  CellModel toggleNote(int note) {
    return notes.contains(note) ? removeNote(note) : addNote(note);
  }

  /// Clear notes
  CellModel clearNotes() {
    return copyWith(notes: []);
  }
}