import 'package:example/model/snap.dart';
import 'package:example/view/snap_view.dart';
import 'package:flutter/material.dart';
import 'package:stories_page_view/stories_page_view.dart';

class WidgetSnap extends StatelessWidget implements SnapView {
  @override
  final StoryController controller;
  @override
  final Snap snap;

  const WidgetSnap({
    super.key,
    required this.controller,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Story Widget can pause and play, ${snap.data}",
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.pause();
                  },
                  child: const Icon(Icons.pause),
                ),
                IconButton(
                  onPressed: () {
                    controller.play();
                  },
                  icon: const Icon(Icons.play_arrow),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
