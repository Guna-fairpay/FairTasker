part of '../private_rental_customers.dart';

class TableChildRow extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const TableChildRow({this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    TableRowInkWell(onTap: onEdit, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text("${model?['first_name'] ?? ""} ${model?['last_name'] ?? ""}", maxLines: 1, overflow: TextOverflow.ellipsis))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text("${model?['phone'] ?? ""}", maxLines: 1, overflow: TextOverflow.ellipsis))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text("\$ ${model?['monthly_rental'] ?? "0"}", maxLines: 1, overflow: TextOverflow.ellipsis))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text(model?['rental_start_date'].toString().toFormat(format: "MM-dd-yy") ?? "", maxLines: 1, overflow: TextOverflow.ellipsis))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: FittedBox(
      child: Row(
        spacing: 5.spMin,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            child: SvgPicture.asset(Assets.penEditIcon, theme: const SvgTheme(currentColor: AppC.appColor)),
          ),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            child: SvgPicture.asset(Assets.trashIcon, theme: const SvgTheme(currentColor: AppC.redAccent)),
          ),
        ],
      ),
    ))),
  ];
}