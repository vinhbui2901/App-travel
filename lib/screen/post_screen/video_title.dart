import 'package:flutter/material.dart';
import 'package:flutter_app_chat/data/video.dart';
import 'package:video_player/video_player.dart';

class VideoTitle extends StatefulWidget {
  const VideoTitle(
      {Key? key,
      required this.video,
      required this.currentIndex,
      required this.snappedPageIndex})
      : super(key: key);
  final Video video;
  final int currentIndex;
  final int snappedPageIndex;
  @override
  _VideoTitleState createState() => _VideoTitleState();
}

class _VideoTitleState extends State<VideoTitle> {
  late VideoPlayerController _controller;
  late Future _initializeVideoPlayer;
  bool _isplaying = true;
  @override
  void initState() {
    // runYoutube();
    _controller = VideoPlayerController.asset(
      'assets/videos/${widget.video.urlVideo}',
    );
    _initializeVideoPlayer = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playPauseVideo() {
    _isplaying ? _controller.play() : _controller.pause();
    setState(() {
      _isplaying = !_isplaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    (widget.snappedPageIndex == widget.currentIndex && _isplaying)
        ? _controller.play()
        : _controller.pause();
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                playPauseVideo();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      playPauseVideo();
                    },
                    icon: Icon(Icons.play_arrow,
                        color: Colors.white.withOpacity(_isplaying ? 0 : 0.5),
                        size: 40),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
