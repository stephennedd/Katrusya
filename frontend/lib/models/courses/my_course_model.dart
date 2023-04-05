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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['course_image'] = this.courseImage;
    data['course_name'] = this.courseName;
    data['is_completed'] = this.isComplete;
    data['number_of_lessons'] = this.numberOfLessons;
    data['number_of_sections'] = this.numberOfSections;
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
