class QuizModel {
  String title;
  int numberOfQuestions;
  String imageUrl;
  int sectionId;
  int courseId;

  QuizModel(
      {required this.title,
      required this.numberOfQuestions,
      required this.imageUrl,
      required this.courseId,
      required this.sectionId});

  QuizModel.fromJson(Map<String, dynamic> json)
      : title = json['quiz_title'] as String,
        numberOfQuestions = json['number_of_questions'],
        imageUrl = json['image_url'],
        sectionId = json['section_id'],
        courseId = json['course_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quiz_title'] = this.title;
    data['number_of_questions'] = this.numberOfQuestions;
    data['image_url'] = this.imageUrl;
    data['section_id'] = this.sectionId;
    data['course_id'] = this.courseId;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "quiz_title": "$title",\n'
        '    "number_of_questions": "$numberOfQuestions",\n'
        '    "image_url": "$imageUrl",\n'
        '    "course_id": "$courseId",\n'
        '    "section_id": "$sectionId",\n'
        '}';
  }
}
