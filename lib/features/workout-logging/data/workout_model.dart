class Exercise {
  final int id;
  final int typeId;
  final String name;
  final String? about;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? iconPath;
  final bool isCustom;
  final bool isFavourite;
  final String? type;

  Exercise({
    required this.id,
    required this.typeId,
    required this.name,
    this.about,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.iconPath,
    required this.isCustom,
    required this.isFavourite,
    this.type,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(map['created_at'] * 1000);
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(map['updated_at'] * 1000);
    
    return Exercise(
      id: map['pk_exercise_id'],
      typeId: map['fk_type_id'],
      name: map['name'],
      about: map['about'],
      notes: map['notes'],
      createdAt: createdAt,
      updatedAt: updatedAt,
      iconPath: map['icon_path'],
      isCustom: map['is_custom'] == 1,
      isFavourite: map['is_favourite'] == 1,
      type: map['type'],
    );
  }
}

class Variation {
  final int id;
  final int exerciseId;
  final String name;
  final bool isDefault;
  final String? about;
  final String? notes;
  final String? weightUnit;
  final double? maxWeight;
  final bool isBilateral;

  Variation({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.isDefault,
    this.about,
    this.notes,
    this.weightUnit,
    this.maxWeight,
    required this.isBilateral,
  });

  factory Variation.fromMap(Map<String, dynamic> map) {
    return Variation(
      id: map['pk_variant_id'],
      exerciseId: map['fk_exercise_id'],
      name: map['name'],
      isDefault: map['is_default'] == 1,
      about: map['about'],
      notes: map['notes'],
      weightUnit: map['weight_unit'],
      maxWeight: map['max_weight'] != null ? map['max_weight'].toDouble() : null,
      isBilateral: map['is_bilateral'] == 1,
    );
  }
}

class MuscleGroup {
  final String role;
  final String group;
  final String name;

  MuscleGroup({
    required this.role,
    required this.group,
    required this.name,
  });

  factory MuscleGroup.fromMap(Map<String, dynamic> map) {
    return MuscleGroup(
      role: map['role'],
      group: map['group'],
      name: map['name'],
    );
  }
}