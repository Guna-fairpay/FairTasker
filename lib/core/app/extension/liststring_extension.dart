extension ListStringExtension on List<String?> {
  String get toInitial {
    var input = this;
    input.removeWhere((element) => (element?.isEmpty ?? false));
    return input.map((e) => e?.substring(0, 1)).join("");
  }
}