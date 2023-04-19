class CompletedSectionModel {
  int userId;
  int courseId;
  int sectionId;

  CompletedSectionModel(
      {required this.userId, required this.courseId, required this.sectionId});

  factory CompletedSectionModel.fromJson(Map<String, dynamic> json) {
    return CompletedSectionModel(
        userId: json['user_id'],
        courseId: json['course_id'],
        sectionId: json['section_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['course_id'] = courseId;
    data['section_id'] = sectionId;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "userId": $userId,\n'
        '    "courseId": "$courseId",\n'
        '    "sectionId": "$sectionId",\n'
        '}';
  }
}
