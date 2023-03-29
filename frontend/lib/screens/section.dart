import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/widgets/lesson_item.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../utils/data.dart';
import '../widgets/app_bar_box.dart';

class SectionPage extends StatefulWidget {
  SectionPage({Key? key, this.data}) : super(key: key);
  static const String routeName = "/section";
  final data;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> with SingleTickerProviderStateMixin{
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  late VideoPlayerController _controller;
  late TabController tabController;
  late ChewieController chewieController;



  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
    _controller = VideoPlayerController.network(
        // todo update based on selected video
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
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
    tabController.dispose();
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: MyAppBar(
        title: "Sections",
        hasAction: true,
        icon:Icon(
          Icons.download_outlined,
          color: Colors.black,
          size: 25,
        ),
        onTap: () {
          print("downloads");
        },
      ),
      body: buildBody()
    );
  }

  Widget buildBody() {

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
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
                      controller:  chewieController,

                    ),
                  ),
                ) :
                _isLoading ? Container(
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  )
                ) : Container(),
        ]
      ),

          getInfo(),
          const SizedBox(
            height: 1,
          ),
          const Divider(),
          getTabBar(),
          getTabBarPages(),

        ],
      )
    );
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
                // TODO get section from course in database
                widget.data["name"],
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TODO lesson data from database
              getAttribute(Icons.play_circle_outline, "4 lessons", labelColor),
              const SizedBox(width: 10,),
              getAttribute(Icons.schedule_outlined, "2 hours", labelColor),
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
        Text(
            info,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: labelColor
            )),
      ],
    );
  }

  Widget getTabBar() {
    return Container(
      child: TabBar(
        indicatorColor: primaryDark,
        controller: tabController,
        tabs: const [
          Tab(
            child: Text(
              "Lessons",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: textColor
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTabBarPages() {
    return Container(
      height: 360,
      width: double.infinity,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          getLessons(),
          Container(
            child: const Text("Milestones"),
          ),
        ],
      ),
    );
  }

  Widget getLessons() {
    return ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) => LessonItem(
          data: lessons[index],
          onTap: () {
            // TODO change currently playing video-url to new video
          },
        )
    );
  }
}