extension IntExtension on int {
  int get toPositive {
    return this < 0 ? 0 : this;
  }
}