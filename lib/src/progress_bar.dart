import 'package:flutter/widgets.dart';

/// Handles the animation of the progressable widgets
/// For example, the progress bar
///
/// ```dart
/// StoryProgressBars(
///   snapCount: 5,
///   snapIndex: 0,
///   animation: animation,
///   builder: (progress) {
///     return Expanded(
///       child: Padding(
///         padding: const EdgeInsets.symmetric(
///           horizontal: 4,
///           vertical: 8,
///         ),
///         child: LinearProgressIndicator(
///           value: progress,
///           valueColor: const AlwaysStoppedAnimation<Color>(
///             Colors.white,
///           ),
///           backgroundColor: Colors.grey,
///         ),
///       ),
///     );
///   },
/// );
/// ```
class StoryProgressBars extends StatefulWidget {
  const StoryProgressBars({
    Key? key,
    required this.snapCount,
    required this.snapIndex,
    required this.animation,
    required this.builder,
  }) : super(key: key);

  /// The total number of snaps in the story
  final int snapCount;

  /// The current snap index
  final int snapIndex;

  /// The animation that controls the progress bar
  /// It is a tween from 0.0 to 1.0
  /// animation is passed by the [StoryPageView.builder]
  final Animation<double> animation;

  /// The builder that builds the progressable widget
  final Widget Function(double progress) builder;

  @override
  State<StoryProgressBars> createState() => _StoryProgressBarsState();
}

class _StoryProgressBarsState extends State<StoryProgressBars> {
  @override
  void initState() {
    super.initState();
    widget.animation.addListener(animationListener);
  }

  void animationListener() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.animation.removeListener(animationListener);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double _getProgress(int index) {
    if (index < widget.snapIndex) {
      return 1;
    } else if (index == widget.snapIndex) {
      return widget.animation.value;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.snapCount; i++)
          widget.builder(_getProgress(i)),
      ],
    );
  }
}
