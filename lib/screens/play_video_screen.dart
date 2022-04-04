import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  static const routeName = '/zoom-image';

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  VideoPlayerController videoPlayerController;

  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/tadweer-alkheer.appspot.com/o/donation_video%2FoZvyud9LQqaHktCJpLLg9eQrvbD2350962.mp4?alt=media&token=77fbb1cd-b18e-48b7-89c0-90fa121c807f');
    await Future.wait([
      videoPlayerController.initialize()
    ]);

    setState(() {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video player"),
      ),
      body: Container(
        child: Center(
          child: chewieController != null &&
              chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
            controller: chewieController,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          ),
        ),
      )
    );
  }
}