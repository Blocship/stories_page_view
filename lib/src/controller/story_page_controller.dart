import 'package:flutter/widgets.dart';

class StoryPageController extends PageController {}

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
