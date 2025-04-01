extension ListStringExtension on List<String?> {
  String get toInitial {
    var input = this;
    input.removeWhere((element) => (element?.isEmpty ?? false));
    return input.map((e) => e?.substring(0, 1)).join("");
  }
}

extension Unique<E, Id> on List<E> {
  List<E> distinct([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
