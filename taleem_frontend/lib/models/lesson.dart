class Lesson {
  final int id;
  final String moduleType;
  final String displayText;
  final String? translation;
  final String? imageUrl;
  final String? audioUrl;
  final int sortOrder;

  Lesson({
    required this.id,
    required this.moduleType,
    required this.displayText,
    this.translation,
    this.imageUrl,
    this.audioUrl,
    required this.sortOrder,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      moduleType: json['module_type'] as String,
      displayText: json['display_text'] as String,
      translation: json['translation'] as String?,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}
