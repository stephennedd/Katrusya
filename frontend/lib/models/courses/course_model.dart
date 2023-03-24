class CourseModel {
  int id;
  String name;
  String image;
  String price;
  String duration;
  String session;
  String review;
  int isFavorited;
  String description;

  CourseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.duration,
    required this.session,
    required this.review,
    required this.isFavorited,
    required this.description,
  });

  CourseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] as String,
        image = json['image'] as String,
        price = json['price'] as String,
        duration = json['duration'] as String,
        session = json['session'] as String,
        review = json['review'] as String,
        isFavorited = json['is_favorited'] as int,
        description = json['description'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['session'] = this.session;
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
        '    "duration": "$duration",\n'
        '    "session": "$session",\n'
        '    "review": "$review",\n'
        '    "is_favorited": $isFavorited,\n'
        '    "description": "$description"\n'
        '}';
  }
}