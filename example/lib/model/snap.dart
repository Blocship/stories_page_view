class Snap {
  SnapType type;
  String data;
  Duration duration;

  Snap({
    required this.type,
    required this.data,
    required this.duration,
  });

  factory Snap.fromJson(Map<String, dynamic> json) {
    return Snap(
      type: SnapType.fromJson(json['type'] as String),
      data: json['data'],
      duration: Duration(seconds: int.parse(json['duration'])),
    );
  }
}

enum SnapType {
  image,
  video,
  text;

  factory SnapType.fromJson(String json) {
    return SnapType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw UnimplementedError('SnapType $json not implemented'),
    );
  }
}
