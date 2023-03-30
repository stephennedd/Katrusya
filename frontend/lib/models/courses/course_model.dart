class CourseModel {
  final int id;
  String name;
  String image;
  String price;
  int durationInHours;
  int numberOfLessons;
  String review;
  bool isFavorited;
  String description;

  CourseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.durationInHours,
    required this.numberOfLessons,
    required this.review,
    required this.isFavorited,
    required this.description,
  });

  /* CourseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] as String,
        image = json['image'] as String,
        price = json['price'] as String,
        duration = json['duration'] as String,
        session = json['session'] as String,
        review = json['review'] as String,
        isFavorited = json['is_favorited'] as bool,
        description = json['description'] as String;*/

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
        description: json['description'] as String);
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
        '}';
  }
}
