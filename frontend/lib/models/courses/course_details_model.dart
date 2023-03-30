class CourseDetailsModel {
  String courseName;
  String courseDescription;
  List<Section> sections;
  int numberOfLessons;
  int courseDurationInHours;
  bool? isFavorited;

  CourseDetailsModel({
    required this.isFavorited,
    required this.courseName,
    required this.courseDescription,
    required this.sections,
    required this.numberOfLessons,
    required this.courseDurationInHours,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> sectionsJson = json['sections'];
    List<Section> sections = sectionsJson.map((sectionJson) {
      List<dynamic> lessonsJson = sectionJson['lessons'];
      List<Lesson> lessons = lessonsJson.map((lessonJson) {
        return Lesson(
            lessonName: lessonJson['lesson_name'],
            lessonDurationInHours: lessonJson['lesson_duration_in_hours'],
            videoUrl: lessonJson['video_url'],
            image: lessonJson['image']);
      }).toList();
      return Section(
        title: sectionJson['title'],
        image: sectionJson['image'],
        lessons: lessons,
        numberOfLessons: sectionJson['number_of_lessons'],
        sectionDurationInHours: sectionJson['section_duration_in_hours'],
      );
    }).toList();
    return CourseDetailsModel(
      isFavorited: json['is_favorited'],
      courseName: json['course_name'],
      courseDescription: json['course_description'],
      sections: sections,
      numberOfLessons: json['number_of_lessons'],
      courseDurationInHours: json['course_duration_in_hours'],
    );
  }

  @override
  String toString() {
    return 'CourseDetailsModel{courseName: $courseName, courseDescription: $courseDescription, isFavorited:$isFavorited, sections: $sections, numberOfLessons: $numberOfLessons, courseDurationInHours: $courseDurationInHours}';
  }
}

class Section {
  String title;
  String image;
  List<Lesson> lessons;
  int numberOfLessons;
  int sectionDurationInHours;

  Section({
    required this.title,
    required this.image,
    required this.lessons,
    required this.numberOfLessons,
    required this.sectionDurationInHours,
  });

  @override
  String toString() {
    return 'Section{title: $title, image: $image, lessons: $lessons, numberOfLessons: $numberOfLessons, sectionDurationInHours: $sectionDurationInHours}';
  }
}

class Lesson {
  String lessonName;
  int lessonDurationInHours;
  String videoUrl;
  String image;

  Lesson(
      {required this.lessonName,
      required this.lessonDurationInHours,
      required this.videoUrl,
      required this.image});

  @override
  String toString() {
    return 'Lesson{lessonName: $lessonName, lessonDurationInHours: $lessonDurationInHours, videoUrl: $videoUrl, image: $image}';
  }
}
