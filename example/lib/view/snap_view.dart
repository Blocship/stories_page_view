import 'package:example/model/snap.dart';
import 'package:example/view/image_snap.dart';
import 'package:example/view/video_snap.dart';
import 'package:example/view/widget_snap.dart';
import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

abstract class SnapView extends Widget {
  const SnapView({
    Key? key,
    required this.controller,
    required this.snap,
  }) : super(key: key);

  final StoryController controller;
  final Snap snap;

  factory SnapView.fromSnap({
    required StoryController controller,
    required Snap snap,
  }) {
    return switch (snap.type) {
      SnapType.image => ImageSnap(
          controller: controller,
          snap: snap,
        ),
      SnapType.video => VideoSnap(
          controller: controller,
          snap: snap,
        ),
      SnapType.text => WidgetSnap(
          controller: controller,
          snap: snap,
        )
    };
  }
}
