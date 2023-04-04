class CompletedLessonModel {
  int userId;
  int courseId;
  int sectionId;
  int lessonId;

  CompletedLessonModel({
    required this.userId,
    required this.courseId,
    required this.sectionId,
    required this.lessonId,
  });

  factory CompletedLessonModel.fromJson(Map<String, dynamic> json) {
    return CompletedLessonModel(
        userId: json['user_id'],
        courseId: json['course_id'],
        sectionId: json['section_id'],
        lessonId: json['lesson_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['course_id'] = this.courseId;
    data['section_id'] = this.sectionId;
    data['lesson_id'] = this.lessonId;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "userId": $userId,\n'
        '    "courseId": "$courseId",\n'
        '    "sectionId": "$sectionId",\n'
        '    "lessonId": "$lessonId",\n'
        '}';
  }
}
