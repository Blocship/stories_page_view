import 'package:example/model/snap.dart';

class Story {
  String data;
  List<Snap> snaps;

  Story({
    required this.data,
    required this.snaps,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      data: json['data'],
      snaps: List<Snap>.from(
        json['snaps'].map(
          (snap) => Snap.fromJson(snap),
        ),
      ),
    );
  }
}
