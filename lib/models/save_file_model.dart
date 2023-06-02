class SaveFileFields {
  static const String fileId = '_fileId';
  static const String fileName = '_fileName';
}

class SaveFile {
  static String tableName = 'saveFile';
  final int? fileId;
  final String? fileName;

  const SaveFile({
    this.fileId,
    this.fileName,
  });

  Map<String, dynamic> toJson() {
    return {
      SaveFileFields.fileId: fileId,
      SaveFileFields.fileName: fileName,
    };
  }

  SaveFile clone({
    int? fileId,
    String? fileName,
  }) {
    return SaveFile(
      fileId: fileId ?? this.fileId,
      fileName: fileName ?? this.fileName,
    );
  }

  factory SaveFile.fromJson(Map<dynamic, dynamic> json) {
    return SaveFile(
      fileId: json[SaveFileFields.fileId] as int,
      fileName: json[SaveFileFields.fileName],
    );
  }
}
