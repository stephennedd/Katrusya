class MyCourseModel {
  int courseId;
  String courseImage;
  String courseName;
  bool isComplete;
  int numberOfLessons;
  int numberOfSections;

  MyCourseModel(
      {required this.courseId,
      required this.courseImage,
      required this.courseName,
      required this.isComplete,
      required this.numberOfLessons,
      required this.numberOfSections});

  factory MyCourseModel.fromJson(Map<String, dynamic> json) {
    return MyCourseModel(
        courseId: json['course_id'],
        courseImage: json['course_image'],
        courseName: json['course_name'],
        isComplete: json['is_completed'],
        numberOfLessons: json['number_of_lessons'],
        numberOfSections: json['number_of_sections']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_id'] = courseId;
    data['course_image'] = courseImage;
    data['course_name'] = courseName;
    data['is_completed'] = isComplete;
    data['number_of_lessons'] = numberOfLessons;
    data['number_of_sections'] = numberOfSections;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "courseId": "$courseId",\n'
        '    "courseImage": "$courseImage",\n'
        '    "courseName": "$courseName",\n'
        '    "courseName": "$isComplete",\n'
        '    "numberOfLessons": "$numberOfLessons",\n'
        '}';
  }
}
