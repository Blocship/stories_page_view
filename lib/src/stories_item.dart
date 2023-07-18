import 'dart:async';

import 'package:flutter/material.dart';

import 'controller/story_controller.dart';
import 'controller/story_page_controller.dart';

typedef SnapBuilder = Widget Function(
  BuildContext context,
  int index,
  Animation<double> animation,
);

class StoryPageItem extends StatefulWidget {
  final int snapCount;
  final StoryControllerImpl controller;
  final SnapBuilder itemBuilder;
  final Duration Function(int index) durationBuilder;

  const StoryPageItem({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.snapCount,
    required this.durationBuilder,
  });

  @override
  State<StoryPageItem> createState() => _StoryPageItemState();
}

class _StoryPageItemState extends State<StoryPageItem>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final StreamSubscription<PlayBackState> _playBackStateSubscription;

  StoryPageController? get storyPageController {
    return StoryPageControllerProvider.of(context)?.controller;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.durationBuilder(widget.controller.currentIndex),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController
      ..duration = widget.durationBuilder(
        widget.controller.currentIndex,
      )
      ..addListener(_handleAnimation);
    // ..forward();
    _playBackStateSubscription =
        widget.controller.playBackStateStream.listen((playBackState) {
      if (playBackState == PlayBackState.playing) {
        _animationController.forward();
      } else {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animation.removeListener(_handleAnimation);
    _animationController.dispose();
    _playBackStateSubscription.cancel();
    super.dispose();
  }

  void _handleAnimation() {
    if (_animation.isCompleted) {
      // todo: check if correct.
      moveNext();
      _animationController
        ..reset()
        ..duration = widget.durationBuilder(
          widget.controller.currentIndex,
        );
      // ..forward();
    }
  }

  void onTapNext() {
    _animationController.stop();
    moveNext();
    _animationController
      ..reset()
      ..duration = widget.durationBuilder(
        widget.controller.currentIndex,
      );
    // ..forward();
  }

  void onTapPrevious() {
    _animationController.stop();
    widget.controller.jumpToPrevious();
    _animationController
      ..reset()
      ..duration = widget.durationBuilder(
        widget.controller.currentIndex,
      );
    // ..forward();
  }

  void moveNext() {
    if (widget.snapCount - 1 == widget.controller.currentIndex) {
      storyPageController?.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.controller.jumpToNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    Offset tapOffset = Offset.zero;
    // https://www.youtube.com/watch?v=zEoASR7DTIw
    // https://medium.com/koahealth/combining-multiple-gesturedetectors-in-flutter-26d899d008b2
    return Listener(
      onPointerUp: (event) {
        tapOffset = event.position;
      },
      // by default GestureDetector gives precedences to the child
      // So, all the gestures beneath the child will work
      // like you can pause and play the video in itemBuilder
      child: GestureDetector(
        // todo: hold to pause

        onTap: () {
          // 20% of the screen width from the left
          // like instagram
          final TextDirection currentDirection =
              Directionality.maybeOf(context) ?? TextDirection.ltr;

          final screenWidth20 = MediaQuery.of(context).size.width / 5;
          final isTappedOnStart = (currentDirection == TextDirection.ltr)
              ? tapOffset.dx < screenWidth20
              : tapOffset.dx > (screenWidth20 * 4);

          if (isTappedOnStart) {
            onTapPrevious();
          } else {
            onTapNext();
          }
        },
        child: StreamBuilder(
          stream: widget.controller.indexStream,
          builder: (context, _) {
            return widget.itemBuilder(
              context,
              widget.controller.currentIndex,
              _animation,
            );
          },
        ),
      ),
    );
  }
}
