import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:frontend/screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class WatchCourse extends StatefulWidget {
  const WatchCourse({super.key});
  static const String routeName = "/watchCourse";

  @override
  State<WatchCourse> createState() => _WatchCourseState();
}

class _WatchCourseState extends State<WatchCourse> {
  QuestionsController controller = Get.put(QuestionsController());
  @override
  void initState() {
    super.initState();
    _initData();
  }

  List videoInfo = [];
  bool _disposed = false;
  bool _playArea = false;
  bool _isPlaying = false;
  int _isPlayingIndex = -1;
  VideoPlayerController? _controller;

  _initData() {
    DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      // setState(() {
      videoInfo = json.decode(value);
      //});
    });
  }

  Future<List<dynamic>> _loadVideoInfo() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString('json/videoinfo.json');
    return json.decode(jsonString);
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Details",
      ),
      body: Container(
          decoration: _playArea == false
              ? const BoxDecoration(
                  gradient: LinearGradient(
                  colors: [
                    Color(0xff0f17ad), //gradientFirst,
                    Color(0xff6985e8)
                  ],
                  begin: FractionalOffset(0.0, 0.4),
                  end: Alignment.topRight,
                ))
              : const BoxDecoration(color: Color(0xff6985e8)),
          child: Column(
            children: [
              _playArea == false
                  ? Container(
                      padding:
                          const EdgeInsets.only(top: 70, left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const MyCourses(),
                                        type: PageTransitionType
                                            .leftToRightWithFade),
                                  );
                                },
                                child: const Icon(Icons.arrow_back_ios,
                                    size: 20, color: Color(0xfffafafe)),
                              ),
                              Expanded(child: Container()),
                              const Icon(Icons.info_outline,
                                  size: 20, color: Color(0xfffafafe))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Legs Toning",
                            style: TextStyle(
                              fontSize: 25,
                              color: Color(0xfff4f5fd),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "and Glutes Workout",
                            style: TextStyle(
                                fontSize: 25, color: Color(0xfff4f5fd)),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 90,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff0f17ad), //gradientFirst,
                                          Color(0xff6985e8)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.timer,
                                        size: 20,
                                        color: Color(0xfff4f5fd),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "68 min",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xfff4f5fd)),
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  width: 245,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff0f17ad), //gradientFirst,
                                          Color(0xff6985e8)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.handyman_outlined,
                                        size: 20,
                                        color: Color(0xfff4f5fd),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Resistent band",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xfff4f5fd)),
                                      )
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ))
                  : SizedBox(
                      width: 300,
                      height: 380,
                      child: Column(
                        children: [
                          Container(
                              height: 75,
                              padding: const EdgeInsets.only(
                                  top: 50, left: 30, right: 30),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _playArea = false;
                                        });
                                      },
                                      child: const Icon(Icons.arrow_back_ios,
                                          size: 20, color: Colors.white)),
                                  Expanded(child: Container()),
                                  const Icon(Icons.info_outline,
                                      size: 20, color: Colors.white)
                                ],
                              )),
                          _playView(context),
                          _controlView(context),
                        ],
                      ),
                    ),
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(70))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 30,
                              ),
                              const Text(
                                "Circuit 1: Legs Toning",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0f17ad)),
                              ),
                              Expanded(child: Container()),
                              Row(
                                children: const [
                                  Icon(Icons.loop,
                                      size: 30, color: Color(0xff0f17ad)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "3 sets",
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xff0f17ad)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<List<dynamic>>(
                            future: _loadVideoInfo(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.hasData) {
                                List<dynamic> videoInfo = snapshot.data!;
                                return Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 8),
                                    itemCount: videoInfo.length,
                                    itemBuilder: (_, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (!videoInfo[index]["isQuiz"]) {
                                            _onTapVideo(index);
                                            setState(() {
                                              if (_playArea == false) {
                                                _playArea = true;
                                              }
                                            });
                                          } else {
                                            _onTapQuiz();
                                          }
                                        },
                                        child: SizedBox(
                                          height: 135,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                            videoInfo[index]
                                                                ["thumbnail"],
                                                          ),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        videoInfo[index]
                                                            ["title"],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 3),
                                                        child: Text(
                                                          videoInfo[index]
                                                              ["time"],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[500]),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 18,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            const Color(0xffeaeefc),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "15s rest",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff839fed)),
                                                        ),
                                                      )),
                                                  Row(
                                                    children: [
                                                      for (int i = 0;
                                                          i < 70;
                                                          i++)
                                                        i.isEven
                                                            ? Container(
                                                                width: 3,
                                                                height: 1,
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xff839fed),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            2)),
                                                              )
                                                            : Container(
                                                                width: 3,
                                                                height: 1,
                                                                color: Colors
                                                                    .white)
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ],
                      ))),
            ],
          )),
    );
  }

  var _onUpdateControllerTime;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;
  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }
    _onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }
    _onUpdateControllerTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller can not be initialized");
      return;
    }
    _duration ??= _controller?.value.duration;
    var duration = _duration;
    if (duration == null) return;

    var position = controller.value.position;
    _position = position;
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  _onTapVideo(int index) {
    final controller =
        VideoPlayerController.network(videoInfo[index]["videoUrl"]);
    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    setState(() {});
    controller
      ..initialize().then((_) {
        old?.dispose();
        _isPlayingIndex = index;
        controller.addListener(_onControllerUpdate);
        controller.play();
      });
  }

  _onTapQuiz() {
    final old = _controller;
    if (old != null) {
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    Get.toNamed(TestScreen.routeName, arguments: controller.questionPaperModel);
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _controlView(BuildContext context) {
    final noMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.red[700],
          inactiveTrackColor: Colors.red[100],
          trackShape: const RoundedRectSliderTrackShape(),
          trackHeight: 2.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
          thumbColor: Colors.redAccent,
          overlayColor: Colors.red.withAlpha(32),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
          tickMarkShape: const RoundSliderTickMarkShape(),
          activeTickMarkColor: Colors.red[700],
          inactiveTickMarkColor: Colors.red[100],
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.redAccent,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        child: Slider(
          value: max(0, min(_progress * 100, 100)),
          min: 0,
          max: 100,
          divisions: 100,
          label: _position?.toString().split(".")[0],
          onChanged: (value) {
            setState(() {
              _progress = value * 0.01;
            });
          },
          onChangeStart: (value) {
            _controller?.pause();
          },
          onChangeEnd: (value) {
            final duration = _controller?.value.duration;
            if (duration != null) {
              var newValue = max(0, min(value, 99)) * 0.01;
              var millis = (duration.inMilliseconds * newValue).toInt();
              _controller?.seekTo(Duration(milliseconds: millis));
              _controller?.play();
            }
          },
        ),
      ),
      Container(
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        color: const Color(0xff6985e8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration:
                        const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(50, 0, 0, 0),
                      )
                    ]),
                    child: Icon(noMute ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white),
                  )),
              onTap: () {
                if (noMute) {
                  _controller?.setVolume(0);
                } else {
                  _controller?.setVolume(1.0);
                }
                setState(() {});
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  final index = _isPlayingIndex - 1;
                  if (index >= 0 && videoInfo.isNotEmpty) {
                    _onTapVideo(index);
                  } else {
                    Get.snackbar("Video list", "",
                        snackPosition: SnackPosition.BOTTOM,
                        icon: const Icon(
                          Icons.face,
                          size: 30,
                          color: Colors.white,
                        ),
                        backgroundColor: const Color(0xff6985e8),
                        colorText: Colors.white,
                        messageText: const Text(
                          "No more videos in the list",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ));
                  }
                },
                child: const Icon(
                  Icons.fast_rewind,
                  size: 36,
                  color: Colors.white,
                )),
            ElevatedButton(
                onPressed: () async {
                  if (_isPlaying) {
                    setState(() {
                      _isPlaying = false;
                    });
                    _controller?.pause();
                  } else {
                    setState(() {
                      _isPlaying = true;
                    });
                    _controller?.play();
                  }
                },
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 36,
                  color: Colors.white,
                )),
            ElevatedButton(
                onPressed: () async {
                  final index = _isPlayingIndex + 1;
                  if (index <= videoInfo.length - 1) {
                    _onTapVideo(index);
                  } else {
                    Get.snackbar("Video list", "",
                        snackPosition: SnackPosition.BOTTOM,
                        icon: const Icon(
                          Icons.face,
                          size: 30,
                          color: Colors.white,
                        ),
                        backgroundColor: const Color(0xff6985e8),
                        colorText: Colors.white,
                        messageText: const Text(
                          "No more videos in the list",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ));
                  }
                },
                child: const Icon(
                  Icons.fast_forward,
                  size: 36,
                  color: Colors.white,
                )),
            Text("$mins:$secs",
                style: const TextStyle(color: Colors.white, shadows: <Shadow>[
                  Shadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(150, 0, 0, 0))
                ]))
          ],
        ),
      )
    ]);
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
            child: Text("Preparing...",
                style: TextStyle(fontSize: 20, color: Colors.white60))),
      );
    }
  }
}
