import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/models/quizzes/quiz_model.dart';
import 'package:frontend/screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/widgets/lesson_item.dart';
import 'package:frontend/widgets/quiz_item.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../controllers/marketplace/courses/course_controller.dart';
import '../controllers/question_paper/questions_controller.dart';
import '../controllers/users/user_controller.dart';
import '../models/courses/course_details_model.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({Key? key, this.data}) : super(key: key);
  static const String routeName = "/section";
  final data;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isPlaying = false;
  late VideoPlayerController _controller;
  late TabController _tabController;
  late ChewieController chewieController;
  CourseController courseController = Get.put(CourseController());
  UsersController usersController = Get.put(UsersController());
  QuestionsController questionsController = Get.put(QuestionsController());
  final GetStorage _getStorage = GetStorage();
  double _videoProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _controller = VideoPlayerController.network(
        // todo update based on selected video
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        final position = _controller.value.position.inSeconds.toDouble();
        final duration = _controller.value.duration.inSeconds.toDouble();
        if (isPlaying != _isPlaying) {
          setState(() {
            _videoProgress = position / duration;
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
        );
        // Ensure the first frame is shown after the video is initialized, even before the play button is pressed.
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: appBarColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Text(
              "Section",
              style: TextStyle(
                  fontFamily: 'Nexa-Trial',
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                  color: textColor,
                  tooltip: 'Go to leaderboard',
                  onPressed: () {
                    print("downloads");
                  })
            ]),
        body: buildBody());
  }

  Widget buildBody() {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Column(
          children: [
            Stack(children: <Widget>[
              _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        //child: VideoPlayer(_controller),
                        child: Chewie(
                          controller: chewieController,
                        ),
                      ),
                    )
                  : _isLoading
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primary,
                            ),
                          ))
                      : Container(),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: getInfo(),
            ),
            const Divider(),
            getTabBar(),
            getTabBarPages(),
          ],
        ));
  }

  Widget getInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Done get section from course in database
                // widget.data["name"],
                widget.data.title,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Done lesson data from database
              getAttribute(Icons.play_circle_outline,
                  "${widget.data.numberOfLessons} lessons", labelColor),
              const SizedBox(
                width: 10,
              ),
              getAttribute(Icons.schedule_outlined,
                  "${widget.data.sectionDurationInHours} hours", labelColor),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getAttribute(IconData icon, String info, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(info,
            style: const TextStyle(fontFamily: 'Poppins', color: labelColor)),
      ],
    );
  }

  Widget getTabBar() {
    return Container(
      child: TabBar(
        indicatorWeight: 0.1,
        indicatorColor: primary,
        controller: _tabController,
        tabs: const [
          Tab(
            child: Text(
              "Lessons",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor),
            ),
          )
        ],
      ),
    );
  }

  Widget getTabBarPages() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 360,
      width: double.infinity,
      child: TabBarView(
        controller: _tabController,
        children: [
          //getLessons(),
          getSectionItems()
        ],
      ),
    );
  }

  // return a list of all lessons and quiz items that a section has in the form of a list of widgets
  Widget getSectionItems() {
    final items = <dynamic>[];
    items.addAll(widget.data.lessons);

    items.addAll(courseController.sectionQuizzes);
    // //DEBUG
    // items.addAll(courseController.sectionQuizzes);
    // items.addAll(courseController.sectionQuizzes);
    // items.addAll(courseController.sectionQuizzes);
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is QuizModel) {
            return QuizItem(
              data: item,
              onTap: () async {
                questionsController.reset();
                await questionsController.startUpQuiz();
                // TODO properly navigate to quiz page.
                Navigator.pushReplacementNamed(context, TestScreen.routeName);
              },
            );
          }

          if (item is Lesson) {
            return LessonItem(
              isPlaying: item.videoUrl == _controller.dataSource,
              data: item,
              // TODO get the isComplete for this course/user from backend and
              isComplete: usersController.hasUserCompletedLesson(item.sectionId,
                  item.lessonId, courseController.currentCourseId.value),
              onTap: () {
                //  widget.data.lessons[index].videoUrl - to get the url of video that was clicked
                // Done change currently playing video-url to new
                if (courseController.isCurrentCoursePurchased.value) {
                  setState(() {
                    _isLoading = true;
                    _controller.pause();
                    _controller = VideoPlayerController.network(item.videoUrl);
                    _controller.initialize().then((_) {
                      chewieController = ChewieController(
                        videoPlayerController: _controller,
                        autoPlay: false,
                        looping: false,
                      );
                      setState(() {
                        _isLoading = false;
                        _controller.play();
                      });
                    });
                  });
                } else {
                  showAlertDialog(context, "No Access",
                      "Please purchase the course to access this content");
                }
              },
              onComplete: () async {
                if (!usersController.hasUserCompletedLesson(item.sectionId,
                    item.lessonId, courseController.currentCourseId.value)) {
                  await usersController.addCompletedLessonByUser(
                      _getStorage.read('userId'),
                      item.lessonId,
                      item.sectionId,
                      courseController.currentCourseId.value);
                  await usersController
                      .getUserCourses(_getStorage.read('userId'));
                  // await usersController
                  //     .getUserCompletedSections(_getStorage.read('userId'));
                } else {
                  await usersController.deleteCompletedLessonByUser(
                      _getStorage.read('userId'),
                      item.lessonId,
                      item.sectionId,
                      courseController.currentCourseId.value);
                  await usersController
                      .getUserCourses(_getStorage.read('userId'));
                  // await usersController
                  //     .getUserCompletedSections(_getStorage.read('userId'));
                }
                // TODO add completion in backend
              },
              progressValue: _videoProgress,
            );
          }
          return null;
        });
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
