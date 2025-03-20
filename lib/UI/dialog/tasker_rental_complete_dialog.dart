import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class TaskerRentalCompleteDialog {
  TaskerRentalCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      bool isCheckOut) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => _TaskerRentalCompleteDialogView(
            model: model, isCheckOut: isCheckOut));
  }
}

class _TaskerRentalCompleteDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final bool isCheckOut;

  const _TaskerRentalCompleteDialogView({this.model, required this.isCheckOut});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 16.horizontalPadding,
      insetPadding: 10.padding,
      titlePadding: EdgeInsets.zero,
      title: ListTile(
        title: const Text(""),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      backgroundColor: Colors.white,
      content: const _TaskerRentalCompleteDialogContentView(),
    );
  }
}

class _TaskerRentalCompleteDialogContentView extends StatelessWidget {
  const _TaskerRentalCompleteDialogContentView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: context.width,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: SwitchListTile(
                        value: false,
                        onChanged: (value) {},
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Move To Repair"),
                      )),
                      Expanded(
                          child: SwitchListTile(
                        value: false,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {},
                        title: const Text("Block Calendar"),
                      )),
                    ],
                  ),
                  const Text.rich(TextSpan(
                      text: "Previous Odometer :",
                      children: [TextSpan(text: "92632")])),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child: Utils.getTextFormField(
                              "Odometer", TextEditingController())),
                      Utils.getOutlinedButton("Upload", () {},
                          iconData: const Icon(Icons.cloud_upload_rounded))
                    ],
                  ),
                  const Text("What type of cleaning does this vehicle need?"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      "Vaccum only",
                      "Exterior only",
                      "Light Clean",
                      "Vaccum & wash",
                      "Deep Clean",
                      "No Clean"
                    ]
                        .map((e) => ChoiceChip(
                              label: Utils.getText(
                                e,
                                color: AppC.appColor,
                                weight: FontWeight.bold,
                              ),
                              selected: false,
                              labelPadding: EdgeInsets.zero,
                              selectedColor: AppC.appColor,
                              disabledColor: Colors.blue[50],
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: const BorderSide(
                                  color: AppC.appColor,
                                  width: 0.5,
                                ),
                              ),
                              backgroundColor: Colors.blue[40],
                              onSelected: (bool selected) {},
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCheckboxListTile(
                        value: false,
                        useExpand: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        onChanged: (value) {},
                        title: const Text("Remove Smell"),
                      ),
                      CustomCheckboxListTile(
                        value: false,
                        useExpand: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        onChanged: (value) {},
                        title: const Text("Remove Strains"),
                      ),
                    ],
                  ),
                  const Text("Incidentals"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomCheckboxListTile(
                          title: const Text("Refuel"),
                          value: false,
                          useExpand: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          onChanged: (value) {}),
                      CustomCheckboxListTile(
                        value: false,
                        onChanged: (value) {},
                        useExpand: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        title: const Text("Additional Distance"),
                      ),
                    ],
                  ),
                  const Text("Maintenance"),
                  Wrap(
                    spacing: 2,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      "Oil Change required",
                      "Bad Brakes",
                      "Check Engine light",
                      "Low tire pressure",
                      "Other maintenance"
                    ]
                        .map((e) => CustomCheckboxListTile(
                            title: Text(e),
                            value: false,
                            useExpand: false,
                            mainAxisSize: MainAxisSize.min,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            onChanged: (value) {}))
                        .toList(),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child: Utils.getTextFormField(
                              "Notes", TextEditingController(),
                              inputAction: TextInputAction.done,
                              textType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 6)),
                      Utils.getOutlinedButton("Upload", () {},
                          iconData: const Icon(Icons.cloud_upload_rounded))
                    ],
                  )
                ],
              )),
              Utils.getFilledButton("Submit", () {}),
              const SizedBox.shrink(),
            ]));
  }
}
