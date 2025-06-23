part of 'segment_button.dart';

class ButtonSegments<T> {
  final T value;
  final String? title;
  final Widget? icon;

  const ButtonSegments({required this.value, this.title, this.icon});
}