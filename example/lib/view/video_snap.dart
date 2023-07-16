import 'package:example/model/snap.dart';
import 'package:example/view/snap_view.dart';
import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';
import 'package:video_player/video_player.dart';

class VideoSnap extends StatefulWidget implements SnapView {
  @override
  final StoryController controller;
  @override
  final Snap snap;

  const VideoSnap({
    super.key,
    required this.controller,
    required this.snap,
  });

  @override
  State<VideoSnap> createState() => _VideoSnapState();
}

class _VideoSnapState extends State<VideoSnap> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(
      widget.snap.data,
    ));
    _videoController.initialize().then((value) {
      widget.controller.play();
    });
    _videoController.addListener(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_videoController);
  }
}
