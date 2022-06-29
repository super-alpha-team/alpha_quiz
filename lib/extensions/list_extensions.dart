
extension ListExtension<T> on List<T> {
  T? get(int index) {
    if (index < 0) {
      return null;
    }
    if (index >= length) {
      return null;
    }

    return this[index];
  }
}