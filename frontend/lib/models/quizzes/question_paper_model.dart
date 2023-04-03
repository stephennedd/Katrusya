class QuestionPaperModel {
  int id;
  String title;
  String? imageUrl;
  String description;
  int timeSeconds;
  List<Questions>? questions;

  QuestionPaperModel(
      {required this.id,
      required this.title,
      this.imageUrl,
      required this.description,
      required this.timeSeconds,
      this.questions});

  QuestionPaperModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] as String,
        imageUrl = json['image_url'],
        description = json['description'] as String,
        timeSeconds = json['time_seconds'],
        questions = (json['questions'] as List)
            .map((dynamic e) => Questions.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['description'] = this.description;
    data['time_seconds'] = this.timeSeconds;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "title": "$id",\n'
        '    "title": "$title",\n'
        '    "image_url": "$imageUrl",\n'
        '    "Description": "$description",\n'
        '    "time_seconds": $timeSeconds,\n'
        '    "questions": [\n${questions?.map((q) => q.toString()).join(",\n")}\n    ]\n'
        '}';
  }
}

class Questions {
  int id;
  String question;
  List<Answers> answers;
  String? correctAnswer;
  String? selectedAnswer;

  Questions(
      {required this.id,
      required this.question,
      required this.answers,
      required this.correctAnswer});

  Questions.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        question = json['question'],
        answers =
            (json['answers'] as List).map((e) => Answers.fromJson(e)).toList(),
        correctAnswer = json['correct_answer'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    data['correct_answer'] = this.correctAnswer;
    return data;
  }

  @override
  String toString() {
    return '        {\n'
        '            "id": "$id",\n'
        '            "question": "$question",\n'
        '            "answers": [\n${answers.map((a) => a.toString()).join(",\n")}\n            ],\n'
        '            "correct_answer": "$correctAnswer"\n'
        '        }';
  }
}

class Answers {
  String? identifier;
  String? answer;

  Answers({this.identifier, this.answer});

  Answers.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        answer = json['answer'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['answer'] = this.answer;
    return data;
  }

  @override
  String toString() {
    return '        {\n'
        '            "identifier": "$identifier",\n'
        '            "answer": "$answer"\n'
        '        }';
  }
}
