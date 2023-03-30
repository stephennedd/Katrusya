class QuizModel {
  String title;
  int numberOfQuestions;

  QuizModel({required this.title, required this.numberOfQuestions});

  QuizModel.fromJson(Map<String, dynamic> json)
      : title = json['quiz_title'] as String,
        numberOfQuestions = json['number_of_questions'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['numberOfQuestions'] = this.numberOfQuestions;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "quiz_title": "$title",\n'
        '    "number_of_questions": "$numberOfQuestions",\n'
        '}';
  }
}
