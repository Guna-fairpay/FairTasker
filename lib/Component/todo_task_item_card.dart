import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoTaskItemCard extends StatelessWidget {
  const TodoTaskItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 5,
        children: [
          Container(
            padding: 10.padding,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        width: context.width,
                        height: context.height,
                        "https://images.unsplash.com/photo-1578475901193-c2ae2b3cd710?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0OTkyNDR8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NDE4NzYwMDN8&ixlib=rb-4.0.3&q=80&w=1080",
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            (loadingProgress?.cumulativeBytesLoaded ==
                                    loadingProgress?.expectedTotalBytes)
                                ? child
                                : const CustomLoading(),
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          Assets.noImages,
                          fit: BoxFit.cover,
                          width: context.width,
                          height: context.height,
                        ),
                      ),
                    ),
                  ),
                ),
                Utils.getText(
                  "No plate",
                  size: 10.sp,
                  weight: FontWeight.w900,
                  color: AppC.red,
                )
              ],
            ),
          ),
          Expanded(
              child: Dismissible(
            key: UniqueKey(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.4), width: 1.2),
                ),
                color: AppC.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  ListTile(
                    dense: true,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Toaster.showInfo("TASK TITLE TAPPED");
                          },
                          child: Utils.getText("TASK NAME",
                              color: true ? AppC.red : AppC().base,
                              weight: FontWeight.w800,
                              overFlow: TextOverflow.ellipsis,
                              size: 12.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Toaster.showInfo("CUSTOM LINK TAPPED");
                          },
                          child: Utils.getText(
                            "T",
                            color:
                                false ? const Color(0xFFA608C0) : Colors.black,
                            weight: FontWeight.w700,
                            size: 14.sp,
                          ),
                        ),
                        Visibility(
                            visible: true,
                            child: GestureDetector(
                              onTap: () {
                                Toaster.showInfo("ATTACHMENT TAPPED");
                              },
                              child: Icon(
                                Icons.remove_red_eye_sharp,
                                size: 14.sp,
                                color: AppC.appColor,
                              ),
                            )),
                      ],
                    ),
                    trailing: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Toaster.showInfo("CALENDAR TAPPED");
                          },
                          child: Icon(
                            Icons.calendar_month_outlined,
                            size: 13.sp,
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: () {
                              Toaster.showInfo("COMPLETED TIME TAPPED");
                            },
                            child: Utils.getText('00:15', size: 12.sp),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Toaster.showInfo("HOUR TAPPED");
                          },
                          child: Utils.getText(
                              Utils.convertString24HTo12H('05:30:00'),
                              size: 12.sp),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: true,
                          child: InkWell(
                            onTapDown: (TapDownDetails? details) async {
                              Toaster.showInfo("VEHICLE TAPPED");
                            },
                            child: Utils.getText(
                              "2019 HYUNDAI SONATA RED",
                              size: 12.sp,
                              overFlow: TextOverflow.ellipsis,
                              weight:
                                  true ? FontWeight.w900 : FontWeight.normal,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: InkWell(
                            onTap: () {
                              Toaster.showInfo("VEHICLE HISTORY TAPPED");
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: AppC.blue,
                              size: 16.sp,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: InkWell(
                              onTapDown: (TapDownDetails? details) {
                                Toaster.showInfo("PARTS TAPPED");
                              },
                              child: Utils.getText("P",
                                  weight: FontWeight.bold, size: 14.sp)),
                        ),
                        Visibility(
                          visible: true,
                          child: GestureDetector(
                              onTapDown: (TapDownDetails? details) {
                                Toaster.showInfo("SUPPLIES TAPPED");
                              },
                              child: Utils.getText("S",
                                  weight: FontWeight.bold, size: 14.sp)),
                        )
                      ],
                    ),
                    trailing: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: true,
                          child: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 17.sp,
                              )),
                        ),
                        Utils.getText("9",
                            weight: FontWeight.bold, size: 13.sp),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: true,
                            child: InkWell(
                                onTapDown: (TapDownDetails? details) async {
                                  Toaster.showInfo("VENDOR / LOCATION TAPPED");
                                },
                                child: Utils.getText("Vendor / Location Name",
                                    size: 12.sp)),
                          ),
                          Visibility(
                            visible: true,
                            child: GestureDetector(
                              onTap: () {
                                Toaster.showInfo("VENDOR INFO TAPPED");
                              },
                              child: Icon(
                                Icons.info,
                                size: 14.sp,
                                color: Colors
                                    .blue, // Replace with AppC.appColor if defined
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: InkWell(
                                onTapDown: (TapDownDetails? details) async {
                                  Toaster.showInfo("NOTES TAPPED");
                                },
                                child: Utils.getText(
                                    "ABCD",
                                    size: 11.sp,
                                    overFlow: TextOverflow.ellipsis,
                                    color: AppC().base)),
                          ),
                          Visibility(
                            visible: true,
                            child: InkWell(
                                onTapDown: (TapDownDetails? details) {
                                  Toaster.showInfo("ADDRESS TAPPED");
                                },
                                child: Utils.getText("A",
                                    weight: FontWeight.bold, size: 13.sp)),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: true,
                            child: InkWell(
                                onTap: () {
                                  Toaster.showInfo("RESOURCE TAPPED");
                                },
                                child: Utils.getText("HM",
                                    weight: FontWeight.bold,
                                    size: 13.sp,
                                    color: AppC().base)),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
