import 'helper.dart';

/// Shows the state of the snap.
enum PlayBackState {
  notStarted,
  playing,
  paused,
  completed,
}

extension XPlayBackState on PlayBackState {
  bool get isPlaying => this == PlayBackState.playing;
  bool get isPaused => this == PlayBackState.paused;
  bool get isCompleted => this == PlayBackState.completed;
}

abstract class StoryController {
  void play();
  void pause();
  void complete();
  Stream<PlayBackState> get playBackStateStream;
}

class StoryControllerImpl implements StoryController {
  late final StreamSubject<int> _indexSubject;
  late final StreamSubject<PlayBackState> _playBackStateSubject;

  StoryControllerImpl({
    required int index,
  })  : _indexSubject = StreamSubject.seeded(index),
        _playBackStateSubject = StreamSubject.seeded(PlayBackState.notStarted);

  int get currentIndex => _indexSubject.value;
  PlayBackState get playBackState => _playBackStateSubject.value;
  Stream<int> get indexStream => _indexSubject.stream;
  @override
  Stream<PlayBackState> get playBackStateStream => _playBackStateSubject.stream;

  void jumpToNext() {
    _indexSubject.add(_indexSubject.value + 1);
  }

  void jumpToPrevious() {
    _indexSubject.add(_indexSubject.value - 1);
  }

  @override
  void play() {
    _playBackStateSubject.add(PlayBackState.playing);
  }

  @override
  void pause() {
    _playBackStateSubject.add(PlayBackState.paused);
  }

  @override
  void complete() {
    _playBackStateSubject.add(PlayBackState.completed);
  }

  void dispose() {
    _indexSubject.close();
    _playBackStateSubject.close();
  }
}
