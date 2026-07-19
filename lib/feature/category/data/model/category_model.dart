class CategoryModel {
  final int? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  // تحويل الـ Map اللي راجعة من الـ Database لـ Object نفهمه في فلاتر
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
    );
  }

  // تحويل الـ Object لـ Map عشان نبعته للداتا بيز عند الإضافة أو التعديل
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }
}