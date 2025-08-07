part of '../todo_task_item_card.dart';

class BookingInfoView extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? info;
  const BookingInfoView({super.key, required this.model, this.info});

  @override
  Widget build(BuildContext context) {
    final hasBookingId = model['rental_booking_id'] != null;
    Widget? child;
    if (hasBookingId) {
      child = GestureDetector(
        onTap: info,
        child: Icon(
          RemixIcons.information_line,
          size: 16.spMin,
          color: AppC.appColor,
        ),
      );
    }
    return child ?? const SizedBox.shrink();
  }
}
