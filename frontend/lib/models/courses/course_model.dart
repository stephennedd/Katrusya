class CourseModel {
  final int id;
  String name;
  String image;
  String price;
  int durationInHours;
  int numberOfLessons;
  String review;
  bool isFavorited;
  bool isRecommended;
  bool isFeatured;
  String description;

  CourseModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.durationInHours,
      required this.numberOfLessons,
      required this.review,
      required this.isFavorited,
      required this.description,
      required this.isFeatured,
      required this.isRecommended});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
        id: json['id'],
        name: json['name'] as String,
        image: json['image'] as String,
        price: json['price'] as String,
        durationInHours: json['duration_in_hours'] as int,
        numberOfLessons: json['number_of_lessons'] as int,
        review: json['review'] as String,
        isFavorited: json['is_favorited'] as bool,
        description: json['description'] as String,
        isRecommended: json['is_recommended'] as bool,
        isFeatured: json['is_featured'] as bool);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['duration_in_hours'] = durationInHours;
    data['number_of_lessons'] = numberOfLessons;
    data['review'] = review;
    data['is_favorited'] = isFavorited;
    data['description'] = description;
    data['is_recommended'] = isRecommended;
    data['is_featured'] = isFeatured;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "id": $id,\n'
        '    "name": "$name",\n'
        '    "image": "$image",\n'
        '    "price": "$price",\n'
        '    "duration": "$durationInHours",\n'
        '    "session": "$numberOfLessons",\n'
        '    "review": "$review",\n'
        '    "is_favorited": $isFavorited,\n'
        '    "description": "$description"\n'
        '    "is_recommended": "$isRecommended"\n'
        '    "is_featured": "$isFeatured"\n'
        '}';
  }
}
