part of '../private_rental_customers.dart';

class AttachmentLister extends StatelessWidget {
  final List<dynamic> attachments;
  final ValueChanged<dynamic>? onTap;
  final ValueChanged<dynamic>? onDelete;
  const AttachmentLister({super.key, this.attachments = const [], this.onDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.spMin,
      runSpacing: 10.spMin,
      children: attachments.map((e) => switch(e){
        Map() => SuccessButton(text: "Preview ${(e['document_type'] ?? "").toString().toTitleCase()}", isOutline: true, backgroundColor: AppC.white, foregroundColor: AppC.appColor, onPressed: () => onTap?.call(e)),
        _ => SizedBox.fromSize(
          size: Size(100.spMin, 100.spMin),
          child: CloseBadge(child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: AppC.lightGray,
              borderRadius: BorderRadius.circular(10.spMin)
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ImageViewer(imageInput: e, fit: BoxFit.cover)
          ), onTapDelete: () => onDelete?.call(e)),
        )
      }).toList()
    );
  }
}
