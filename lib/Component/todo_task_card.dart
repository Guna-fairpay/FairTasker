import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class TodoTaskCard extends StatelessWidget {
  final int index;

  const TodoTaskCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      margin: 5.padding,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: 10.padding,
        decoration: const BoxDecoration(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Directionality(
                textDirection:
                    (index % 2 == 0) ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox.shrink(),
                    Expanded(
                      flex: 3,
                      child: Column(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Maintenance Check",
                            style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Lato"),
                          ),
                          Text(
                            "2019 NISSAN ALTIMA GRAY",
                            style: context.textTheme.labelLarge
                                ?.copyWith(fontFamily: "Lato"),
                          ),
                          Text(
                            "ZAM ZAM Supermarket",
                            style: context.textTheme.labelMedium?.copyWith(
                                fontFamily: "Lato",
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "(04:30 PM-03/08)",
                            style: context.textTheme.labelSmall?.copyWith(
                                fontFamily: "Lato",
                                fontStyle: FontStyle.normal,
                                color: AppC().base),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppC.appColor,
                            borderRadius:
                                BorderRadius.circular(Num.borderRadius)),
                        child: Column(
                          children: [
                            Container(
                              // padding: 40.padding,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(Num.borderRadius)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0OTkyNDR8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NDE4NjU0MDh8&ixlib=rb-4.0.3&q=80&w=1080",
                                fit: BoxFit.contain,
                                gaplessPlayback: true,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    (loadingProgress?.cumulativeBytesLoaded ==
                                            loadingProgress
                                                ?.cumulativeBytesLoaded)
                                        ? child
                                        : const CustomLoading(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(Assets.noImages),
                              ),
                            ),
                            Padding(
                                padding: 5.padding,
                                child: Text("TTX7559",
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "Lato")))
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Row(
              children: [
                Expanded(child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                  Chip(
                    label: const Text("Turo"),
                    padding: 10.horizontalPadding,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    labelPadding: 10.horizontalPadding,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    labelStyle: context.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    color: WidgetStatePropertyAll(AppC.blue50),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Chip(
                    label: const Text("Parts"),
                    padding: 10.horizontalPadding,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    labelPadding: 10.horizontalPadding,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    labelStyle: context.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    color: const WidgetStatePropertyAll(Color(0xffF2EDFF)),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Chip(
                    label: const Text("Supplies"),
                    padding: 10.horizontalPadding,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    labelPadding: 10.horizontalPadding,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    labelStyle: context.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    color: WidgetStatePropertyAll(
                        Colors.amberAccent.withValues(alpha: 0.3)),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Chip(
                    label: const Text("Address"),
                    padding: 10.horizontalPadding,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    labelPadding: 10.horizontalPadding,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    labelStyle: context.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    color: WidgetStatePropertyAll(
                        Colors.green.withValues(alpha: 0.3)),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Chip(
                    label: const Text("Groups"),
                    padding: 10.horizontalPadding,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    labelPadding: 10.horizontalPadding,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    labelStyle: context.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    color: WidgetStatePropertyAll(
                        Colors.blue.withValues(alpha: 0.3)),
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ],)),
                const Text.rich(TextSpan(children: [
                  WidgetSpan(
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppC.green,
                      )),
                  TextSpan(text: "9")
                ]))
              ],
            ),
            const Divider(height: 0.5),
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  alignment: Alignment.centerLeft,
                  fit: StackFit.passthrough,
                  children: [
                    const CircleAvatar(
                      child: CircleAvatar(
                        child: Text("IA"),
                      ),
                    ),
                    Padding(
                      padding: 20.leftPadding,
                      child: CircleAvatar(
                        backgroundColor: AppC.blue50,
                        child: CircleAvatar(
                          backgroundColor: AppC.blue50,
                          child: const Text("SA"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: 40.leftPadding,
                      child: const CircleAvatar(
                        backgroundColor: AppC.fieldBase,
                        child: CircleAvatar(
                          backgroundColor: AppC.fieldBase,
                          child: Text("HM"),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 5,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("00:15"),
                        Text("11:40 AM"),
                      ],
                    ),
                    IconButton.outlined(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Num.borderRadiusLarge))),
                            iconColor: const WidgetStatePropertyAll(AppC.appColor),
                            side: const WidgetStatePropertyAll(BorderSide())),
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_month_rounded))
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
