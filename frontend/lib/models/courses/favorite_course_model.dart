class FavoriteCourseModel {
  int courseId;
  String courseName;
  String courseImage;
  String coursePrice;
  int numberOfLessons;
  int durationInHours;
  String courseReview;

  FavoriteCourseModel(
      {required this.courseId,
      required this.courseName,
      required this.courseImage,
      required this.coursePrice,
      required this.numberOfLessons,
      required this.durationInHours,
      required this.courseReview});

  factory FavoriteCourseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCourseModel(
        courseId: json['course_id'],
        courseName: json['course_name'],
        courseImage: json['course_image'] as String,
        coursePrice: json['course_price'] as String,
        durationInHours: json['duration_in_hours'] as int,
        numberOfLessons: json['number_of_lessons'] as int,
        courseReview: json['course_review'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['course_name'] = this.courseName;
    data['course_image'] = this.courseImage;
    data['course_price'] = this.coursePrice;
    data['duration_in_hours'] = this.durationInHours;
    data['number_of_lessons'] = this.numberOfLessons;
    data['course_review'] = this.courseReview;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "courseId": "$courseId",\n'
        '    "name": "$courseName",\n'
        '    "image": "$courseImage",\n'
        '    "price": "$coursePrice",\n'
        '    "duration": "$durationInHours",\n'
        '    "session": "$numberOfLessons",\n'
        '    "review": "$courseReview",\n'
        '}';
  }
}
