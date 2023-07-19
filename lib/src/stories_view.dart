import 'package:flutter/material.dart';

import 'controller/helper.dart';
import 'controller/story_controller.dart';
import 'controller/story_page_controller.dart';
import 'stories_item.dart';

typedef StoryItemBuilder = Widget Function(
  BuildContext context,
  int pageIndex,
  int snapIndex,
  Animation<double> animation,
  StoryController controller,
);

typedef DurationBuilder = Duration Function(
  int pageIndex,
  int snapIndex,
);

typedef SnapCountBuilder = int Function(int pageIndex);

/// Story page view widget that takes the list of story items (stories) and
/// each story item (story) has a list of snaps.
class StoryPageView extends StatefulWidget {
  /// The total number of Story items (stories)
  final int pageCount;

  /// The controller that controls the page view
  final StoryPageController? controller;

  /// The builder that builds each story item (story)
  final StoryItemBuilder itemBuilder;

  /// The initial snap index for each story item (story)
  final SnapCountBuilder snapInitialIndexBuilder;

  /// The total number of snaps for each story item (story)
  final SnapCountBuilder snapCountBuilder;

  /// The duration of each snap
  final DurationBuilder durationBuilder;

  /// The callback that is called when the user tries to go out of range,
  /// i.e. when the user tries to go to the next story item (story) when the
  /// current story item (story) is the last one or when the user tries to go
  /// to the previous story item (story) when the current story item (story) is
  /// the first one.
  final void Function()? outOfRangeCompleted;

  const StoryPageView({
    super.key,
    this.controller,
    required this.pageCount,
    required this.itemBuilder,
    required this.snapInitialIndexBuilder,
    required this.snapCountBuilder,
    required this.durationBuilder,
    this.outOfRangeCompleted,
  });

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final ObservableObject<bool> _outOfRange = false.asObservable();
  late final StoryPageController controller;

  final List<StoryControllerImpl> storyControllers = [];

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? StoryPageController(initialPage: 0);
    _outOfRange.attachListener(_onOutOfRangeChanged);
    storyControllers.addAll(
      List.generate(
        widget.pageCount,
        (index) => StoryControllerImpl(
          index: widget.snapInitialIndexBuilder(index),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant StoryPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageCount < widget.pageCount) {
      final newControllers = List.generate(
        widget.pageCount - oldWidget.pageCount,
        (index) => StoryControllerImpl(
          index: widget.snapInitialIndexBuilder(index),
        ),
      );
      storyControllers.addAll(newControllers);
    } else if (oldWidget.pageCount > widget.pageCount) {
      final extraControllers = List.generate(
        oldWidget.pageCount - widget.pageCount,
        (index) => storyControllers.removeLast(),
      );
      for (var element in extraControllers) {
        element.dispose();
      }
    }
  }

  @override
  void dispose() {
    _outOfRange.detachListener();
    controller.dispose();
    for (var element in storyControllers) {
      element.dispose();
    }
    super.dispose();
  }

  void _onOutOfRangeChanged(bool oldValue, bool newValue) {
    final isOutofRangeCompleted = oldValue == true && newValue == false;
    if (isOutofRangeCompleted) {
      widget.outOfRangeCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoryPageControllerProvider(
      controller: controller,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _outOfRange.value = notification.metrics.outOfRange;
          return false;
        },
        child: PageView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.pageCount,
          itemBuilder: (context, pageIndex) {
            return StoryPageItem(
              controller: storyControllers[pageIndex],
              snapCount: widget.snapCountBuilder(pageIndex),
              durationBuilder: (snapIndex) {
                return widget.durationBuilder(pageIndex, snapIndex);
              },
              itemBuilder: (context, snapIndex, animation) {
                return widget.itemBuilder(
                  context,
                  pageIndex,
                  snapIndex,
                  animation,
                  storyControllers[pageIndex],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
