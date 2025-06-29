class UpdaterResult {
  final bool needUpdate;
  final bool isOptional;

  UpdaterResult({required this.needUpdate, required this.isOptional});

  @override
  String toString() {
    return "UpdaterResult(needUpdate: $needUpdate, isOptional: $isOptional)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdaterResult &&
        other.needUpdate == needUpdate &&
        other.isOptional == isOptional;
  }
}
