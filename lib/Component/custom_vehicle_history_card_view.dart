import 'package:fairpytasker/Component/readmore.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomVehicleHistoryCardView extends StatelessWidget {
  final bool hasParts;
  final bool hasSupplies;
  final bool hasCustom;
  final VoidCallback? onTap;
  final VoidCallback? onParts;
  final VoidCallback? onSupplies;
  final VoidCallback? onCustom;
  final VoidCallback? onUserTap;
  final VoidCallback? onDelete;
  final bool? isCompleted;
  final String? customText;
  final String? cleanCarText;
  final String? userNameText;
  final String? titleText;
  final String? timeText;
  final String? notesText;
  final String? locationText;
  final ConfirmDismissCallback? confirmDismiss;

  const CustomVehicleHistoryCardView({
    super.key,
    this.hasParts = false,
    this.hasSupplies = false,
    this.hasCustom = false,
    this.onTap,
    this.onParts,
    this.onSupplies,
    this.onCustom,
    this.onUserTap,
    this.onDelete,
    this.customText,
    this.cleanCarText,
    this.userNameText,
    this.titleText,
    this.timeText,
    this.notesText,
    this.locationText,
    this.confirmDismiss,
    this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: (hasCustom || hasSupplies || hasParts)
          ? EdgeInsets.zero
          : const EdgeInsets.only(top: 5),
      child: Stack(
        children: [
          Dismissible(
            key: UniqueKey(),
            confirmDismiss: confirmDismiss,
            dragStartBehavior: DragStartBehavior.start,
            direction: DismissDirection.endToStart,
            background: Container(
              padding: 10.padding,
              margin: EdgeInsets.only(
                  top: (hasCustom || hasSupplies || hasParts) ? 20 : 0),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: (isCompleted ?? false) ? AppC.redAccent : AppC.green,
                borderRadius: BorderRadius.circular(Num.borderRadius),
              ),
              child: Text((isCompleted ?? false) ? "InProgress" : "Complete", textAlign: TextAlign.end, style: context.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            child: InkWell(
              onTap: onTap,
              child: Card.filled(
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                    side: const BorderSide(
                        color: AppC.borderColor,
                        width: Num.borderWidthThinField)),
                color: context.theme.cardColor,
                margin: EdgeInsets.only(
                    top: (hasCustom || hasSupplies || hasParts) ? 20 : 0),
                elevation: 2,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Container(),
                    if (userNameText?.isNotEmpty ?? false)
                      InkWell(
                        onTap: onUserTap,
                        borderRadius: BorderRadius.circular(Num.borderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Num.borderRadius),
                              color: AppC.appColor),
                          padding: const EdgeInsets.all(8),
                          child: Text("$userNameText",
                              style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: 10.topPadding,
                            title: ((titleText?.length ?? 0) == 0)
                                ? null
                                : Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: "$titleText")
                                      ]
                                    ),
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w600, color: (isCompleted ?? false) ? AppC.green : null),
                                  ),
                            subtitle: ((cleanCarText?.length ?? 0) != 0)
                                ? Text("(\t$cleanCarText\t)")
                                : null,
                            subtitleTextStyle: context.textTheme.labelSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppC.redAccent),
                            trailing: (onDelete == null)
                                ? null
                                : InkWell(
                                onTap: onDelete,
                                child: const Icon(
                                  Icons.delete_outline_rounded, color: Colors.red,)),
                            minVerticalPadding: 0,
                            horizontalTitleGap: 0,
                            minTileHeight: 0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: ReadMoreText(
                                    (notesText?.isNotEmpty ?? false)
                                        ? '($notesText)'
                                        : '',
                                    preDataText: locationText,
                                    preDataTextStyle: context.textTheme.labelLarge
                                        ?.copyWith(color: AppC.appColor),
                                    trimLength: (((locationText?.length ?? 0) <= 10) || ((locationText?.length ?? 0) == 0)) ? 30 : 7,
                                    titleTextStyle: context.textTheme.labelLarge
                                        ?.copyWith(
                                        color: AppC.green,
                                        fontWeight: FontWeight.w500),
                                    trimMode: TrimMode.Length,
                                    trimCollapsedText: 'more',
                                    trimExpandedText: ' less',
                                    textAlign: TextAlign.start,
                                    style: context.textTheme.labelSmall,
                                    moreStyle: context.textTheme.labelLarge
                                        ?.copyWith(color: AppC.redOpac),
                                    lessStyle: context.textTheme.labelLarge
                                        ?.copyWith(color: AppC.redAccent),
                                  )),
                              if (timeText?.isNotEmpty ?? false)
                                Text("$timeText",
                                    style: context.textTheme.labelMedium)
                            ],
                          ),
                          10.height,
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ),
          if ((hasCustom || hasSupplies || hasParts))
            Positioned(
                top: 7,
                right: 1,
                left: (hasCustom && hasSupplies && hasParts) ? 1 : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (hasParts)
                      InkWell(
                        onTap: onParts,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                              color: Colors.grey),
                          child: Text(
                            "PARTS",
                            style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    if (hasSupplies)
                      InkWell(
                        onTap: onSupplies,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                              color: Colors.lightGreen),
                          child: Text(
                            "SUPPLIES",
                            style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    if (hasCustom && (customText?.isNotEmpty ?? false))
                      InkWell(
                        onTap: onCustom,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                              color: Colors.black),
                          child: Text(
                            "$customText",
                            style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
                ))
        ],
      ),
    );
  }
}
