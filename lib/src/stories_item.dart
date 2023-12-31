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
        widget.controller.playBackStateStream.listen(onPlayBackStateChanged);
  }

  @override
  void dispose() {
    _animation.removeListener(_handleAnimation);
    _animationController.dispose();
    _playBackStateSubscription.cancel();
    super.dispose();
  }

  void onPlayBackStateChanged(PlayBackState playBackState) {
    switch (playBackState) {
      case PlayBackState.notStarted:
        break;
      case PlayBackState.playing:
        _animationController.forward();
        break;
      case PlayBackState.paused:
        _animationController.stop();
        break;
      case PlayBackState.completed:
        _animationController.value = _animationController.upperBound;
    }
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
    movePrevious();
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

  void movePrevious() {
    if (widget.controller.currentIndex == 0) {
      storyPageController?.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.controller.jumpToPrevious();
    }
  }

  void onTapRelease(TapUpDetails details) {
    final tapOffset = details.globalPosition;
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
  }

  void onHoldRelease(TapUpDetails details) {
    if (widget.controller.playBackState == PlayBackState.paused) {
      widget.controller.play();
    }
  }

  // to figure out if the gesture is for tap or to hold
  Timer? _debouncer;

  @override
  Widget build(BuildContext context) {
    // https://www.youtube.com/watch?v=zEoASR7DTIw
    // https://medium.com/koahealth/combining-multiple-gesturedetectors-in-flutter-26d899d008b2
    return GestureDetector(
      onTapCancel: () {
        if (widget.controller.playBackState.isPaused) {
          widget.controller.play();
        }
      },
      onTapDown: (_) {
        if (widget.controller.playBackState.isPlaying) {
          widget.controller.pause();
          _debouncer = Timer(const Duration(milliseconds: 500), () {});
        }
      },
      onTapUp: (_) {
        if (_debouncer == null) {
          onTapRelease(_);
        } else if (_debouncer!.isActive) {
          onTapRelease(_);
        } else {
          onHoldRelease(_);
        }
        _debouncer?.cancel();
        _debouncer = null;
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
    );
  }
}
