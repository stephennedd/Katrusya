import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool isLoop;
  const VideoPlayer(
      {super.key, required this.isLoop, required this.videoPlayerController});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late ChewieController chewieController;
  @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      looping: widget.isLoop,
      aspectRatio: 16 / 9,
      autoInitialize: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Chewie(controller: chewieController),
    );
  }
}

class VideoDisplay extends StatefulWidget {
  final String videoUrl;
  const VideoDisplay({super.key, required this.videoUrl});
  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      isLoop: true,
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
    );
  }
}
