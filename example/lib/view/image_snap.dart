import 'package:example/model/snap.dart';
import 'package:example/view/snap_view.dart';
import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

class ImageSnap extends StatelessWidget implements SnapView {
  @override
  final StoryController controller;
  @override
  final Snap snap;

  const ImageSnap({
    super.key,
    required this.controller,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      snap.data,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) {
          print('frame: $frame');
          controller.play();
        }
        return child;
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          print('loadingProgress: $loadingProgress');
          controller.pause();
        }

        if (loadingProgress == null) {
          return child;
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
