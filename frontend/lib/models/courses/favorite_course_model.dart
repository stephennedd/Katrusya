class FavoriteCourseModel {
  int courseId;

  FavoriteCourseModel({
    required this.courseId,
  });

  factory FavoriteCourseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCourseModel(courseId: json['course_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "courseId": "$courseId",\n'
        '}';
  }
}
