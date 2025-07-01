part of '../todo_task_item_card.dart';

class ResourceExtras extends StatelessWidget {
  final Map<String, dynamic> model;
  final bool? showCheckbox, value;
  final GestureTapDownCallback? onResource;
  final ValueChanged<bool?>? onChecked;
  const ResourceExtras({super.key, required this.model, this.showCheckbox, this.value, this.onResource, this.onChecked});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final resourceName = display['resource_name'] ?? "";
    final resources = List.from(display['resources'] ?? []);
    final hasResources = (resourceName.toString().isNotNullOrEmpty || resources.isNotEmpty);
    final moreResources = resources.length > 1;
    String resourcesName = "";
    if (resourceName.toString().isNotNullOrEmpty) resourcesName = resourceName;
    if (resources.isNotEmpty) {
      final singleResource = resources.firstOrNull;
      final initialNames = <String>[(singleResource?['first_name'] ?? ""), (singleResource?['last_name'] ?? "")].toInitial;
      resourcesName = initialNames;
      if (moreResources) resourcesName = "$resourcesName...";
    }
    Widget? child;
    if (hasResources) {
      child = Row(
        spacing: (showCheckbox ?? false) ? 10 : 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(onTapDown: onResource, child: Utils.getText(resourcesName, weight: FontWeight.w900, size: 13.sp, color: AppC().base)),
          if (showCheckbox ?? false) SizedBox.fromSize(
              size: const Size.fromRadius(0.8),
              child: Checkbox(value: value,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  tristate: false,
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadius)),
                  side: const BorderSide(color: AppC.borderColor, width: Num.borderWidthField),
                  onChanged: onChecked)
          ),
          const SizedBox.shrink(),
        ],
      );
    }
    return child ?? const SizedBox.shrink();
  }
}
