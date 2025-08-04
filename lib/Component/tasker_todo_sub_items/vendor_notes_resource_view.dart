part of '../todo_task_item_card.dart';

class VendorNotesResourceView extends StatelessWidget {
  final Map<String, dynamic> model;
  final bool? showCheckbox, value;
  final VoidCallback? onVendorInfo;
  final ValueChanged<bool?>? onChecked;
  final void Function(String? value)?
      onMore; // SHOW MORE TEXT WITH THIS FUNCTION
  final GestureTapDownCallback? onVendorOrLocation,
      onNotes,
      onLead,
      onAddress,
      onResource;

  const VendorNotesResourceView(
      {super.key,
      required this.model,
      this.onVendorOrLocation,
      this.onVendorInfo,
      this.onNotes,
      this.onLead,
      this.onMore,
      this.onAddress,
      this.onResource,
      this.showCheckbox,
      this.value,
      this.onChecked});

  @override
  Widget build(BuildContext context) {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VendorLocationExtras(
            model: model,
            onAddress: onAddress,
            onNotes: onNotes,
            onVendorInfo: onVendorInfo,
            onVendorOrLocation: onVendorOrLocation,
            onLead: onLead,
            onMore: onMore),
        ResourceExtras(
            model: model,
            showCheckbox: showCheckbox,
            value: value,
            onChecked: onChecked,
            onResource: onResource),
      ],
    );
  }
}
