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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['duration_in_hours'] = this.durationInHours;
    data['number_of_lessons'] = this.numberOfLessons;
    data['review'] = this.review;
    data['is_favorited'] = this.isFavorited;
    data['description'] = this.description;
    data['is_recommended'] = this.isRecommended;
    data['is_featured'] = this.isFeatured;
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
