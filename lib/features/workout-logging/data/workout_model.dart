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
      type: map['type'],
    );
  }
}