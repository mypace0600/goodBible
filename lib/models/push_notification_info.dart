class PushInfoFields {
  static const String id = '_id';
  static const String userId = '_userId';
  static const String token = "_token";
}

class PushInfo {
  static String tableName = 'PushInfo';
  final int? id;
  String? userId;
  String? token;

  PushInfo({
    this.id,
    this.userId,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      PushInfoFields.id: id,
      PushInfoFields.userId: userId,
      PushInfoFields.token: token,
    };
  }

  PushInfo clone({
    int? id,
    String? userId,
    String? token,
  }) {
    return PushInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }

  factory PushInfo.fromJson(Map<String, dynamic> json) {
    return PushInfo(
      id: json[PushInfoFields.id] as int,
      userId: json[PushInfoFields.userId],
      token: json[PushInfoFields.token],
    );
  }
}
