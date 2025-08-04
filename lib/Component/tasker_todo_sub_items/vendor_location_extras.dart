part of '../todo_task_item_card.dart';

class VendorLocationExtras extends StatelessWidget {
  final Map<String, dynamic> model;
  final GestureTapDownCallback? onVendorOrLocation, onNotes, onAddress, onLead;
  final VoidCallback? onVendorInfo;
  final void Function(String? value)? onMore; // SHOW MORE TEXT WITH THIS FUNCTION
  const VendorLocationExtras({super.key, required this.model, this.onVendorOrLocation, this.onVendorInfo, this.onNotes, this.onMore, this.onAddress, this.onLead});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final vendorLocation = display['vendor_location'] ?? "";
    final notes = display['notes'] ?? "";
    final timeChangeReason = (display['timeChangeReason'] ?? "").toString().toTitleCase();
    final hasVendorInfo = display['hasVendorInfo'] ?? false;
    final hasTimeChangeReason = display['hasTimeChangeReason'] ?? false;
    final hasAddress = display['hasAddress'] ?? false;
    final hasVendorLocation = vendorLocation.toString().isNotNullOrEmpty;
    final hasNotes = notes.toString().isNotNullOrEmpty;
    final parsedNotes = parse(notes.toString().removeNextLines).body?.text;
    final hasEllipsis = timeChangeReason.length > 10;
    final hasLead = model['lead_id'].toString().isNotNullOrEmpty;
    final hasChannel = model['channel_id'].toString().isNotNullOrEmpty;
    final leadName = model['lead']?['customer_name'] ?? "";
    final channelName = model['channel']?['channel_name'] ?? (getIt<CommonService>().channels.firstWhereOrNull((element) => element['id'] == model['channel_id'])?['channel_name'] ?? "");
    final String? leadChannelName = hasLead ? leadName : hasChannel ? channelName : null;
    return Expanded(child: Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasVendorLocation) Flexible(child: GestureDetector(onTapDown: onVendorOrLocation, child: Utils.getText(vendorLocation, size: 12.spMin, overFlow: TextOverflow.ellipsis))),
            if (leadChannelName.isNotNullOrEmpty) Flexible(child: GestureDetector(onTapDown: onLead, child: Utils.getText(leadChannelName ?? "", size: 12.spMin, overFlow: TextOverflow.ellipsis))),
            if (hasVendorInfo) GestureDetector(onTap: onVendorInfo, child: Icon(Icons.info, size: 16.spMin, color: Colors.blue)),
            if (hasNotes && !hasLead) Flexible(
              child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      children: [
                        TextSpan(text: "($parsedNotes)", recognizer: TapGestureRecognizer()..onTapDown = onNotes),
                        if (hasTimeChangeReason) TextSpan(text: "\t$timeChangeReason", style: context.textTheme.labelMedium?.copyWith(color: null), recognizer: hasEllipsis ? (TapGestureRecognizer()..onTap = ()=> onMore?.call(timeChangeReason)) : null)
                      ], style: context.textTheme.labelMedium?.copyWith(fontSize: 11.spMin, overflow: TextOverflow.ellipsis, color: AppC.appColor))),
            ),
            if (hasAddress) Flexible(child: GestureDetector(onTapDown: onAddress, child: Utils.getText("A", weight: FontWeight.bold, size: 14.spMin))),
            const SizedBox.shrink(),
          ],
        ),
        if(hasNotes && hasLead)
          RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  children: [
                    TextSpan(text: "($parsedNotes)", recognizer: TapGestureRecognizer()..onTapDown = onNotes),
                    if (hasTimeChangeReason) TextSpan(text: "\t$timeChangeReason", style: context.textTheme.labelMedium?.copyWith(color: null), recognizer: hasEllipsis ? (TapGestureRecognizer()..onTap = ()=> onMore?.call(timeChangeReason)) : null)
                  ], style: context.textTheme.labelMedium?.copyWith(fontSize: 11.spMin, overflow: TextOverflow.ellipsis, color: AppC.appColor))),
      ],
    ));
  }
}
