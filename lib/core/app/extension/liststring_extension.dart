extension ListStringExtension on List<String?> {
  String get toInitial {
    var input = this;
    input.removeWhere((element) => (element?.isEmpty ?? false));
    return input.map((e) => e?.substring(0, 1)).join("");
  }
}

List<T> paginateList<T>({
  required List<T> data,
  required int currentPage,
  required int itemsPerPage,
}) {
  final pageIndex = currentPage - 1; // 👈 Adjust here
  final start = pageIndex * itemsPerPage;
  final end = start + itemsPerPage;

  if (start >= data.length) return [];

  return data.sublist(start, end > data.length ? data.length : end);
}

extension Unique<E, Id> on List<E> {
  List<E> distinct([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

String getInitials(dynamic name) {
  if (name == null) return '';
  return name.toString().trim().split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase())
      .join();
}
