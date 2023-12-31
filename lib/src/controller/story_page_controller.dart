import 'package:flutter/widgets.dart';

/// Page controller for StoryPageView
class StoryPageController extends PageController {
  final void Function(int page)? onPageChange;
  StoryPageController({
    super.initialPage,
    this.onPageChange,
  });
}

class StoryPageControllerProvider extends InheritedWidget {
  final StoryPageController controller;

  const StoryPageControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant StoryPageControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }

  static StoryPageControllerProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoryPageControllerProvider>();
}
