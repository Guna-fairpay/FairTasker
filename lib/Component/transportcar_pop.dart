import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_date_time_picker.dart';
import '../Utilities/appC.dart';
import '../Utilities/num.dart';

class TransportcarPopup{
  TransportcarPopup._();
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TransportcarPopView(),
    );
  }

}

class _TransportcarPopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      insetPadding: 10.padding.copyWith(top: 50),
      titlePadding: EdgeInsets.zero,
      contentPadding: 15.padding,
      title: ListTile(leading: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close),
      ),
        dense: true,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getText("Next Task",weight: FontWeight.bold,size: 14.sp),
            Utils.dropdownBox("Select", [{"car": "Transport Car"}, {"car": "Pickup Car"}], (val){}, labelKey: "car"),
            // const CustomDropdown(items: ["Transport Car","Pickup Car"],labelText: "Select...",),
            Utils.getTextFormField("Custom Task",TextEditingController()),
            Row(
              spacing: 10,
              children: [
                Expanded(child: CustomDateTimePicker<DateTime>(
                  controller: TextEditingController(),
                  suffixIcon: Icon(Icons.calendar_month_rounded, size: 15, color: context.theme.hintColor),
                )),
                Expanded(child: CustomDateTimePicker<TimeOfDay>(
                  controller: TextEditingController(),
                  suffixIcon: Icon(Icons.access_time_rounded, size: 15, color: context.theme.hintColor),
                )),
              ],
            ),
            // CustomDropdown<Map<String, dynamic>>(items: [{"car1": "Transport Car"}, {"car2": "Pickup Car"}]),
            Utils.dropdownBox("Select", [{"person": "Hasnath mohammed"}, {"person": "Abdullah khan"}], (val){}, labelKey: "person"),
            Utils.getTextFormField("Vendor / Location",TextEditingController()),
            Utils.getTextFormField("Notes",TextEditingController()),
            const Row(
              spacing: 20,
              children: [
                SuccessButton(text: "Save",),
                SuccessButton(text: "Ignore", backgroundColor: AppC.red,)
              ],
            ),
          ]
        )
      )
    );
  }
}

// class CustomChipDropdown extends StatefulWidget {
//   final List<String> options;
//   final List<String> selected;
//   final Function(List<String>) onChanged;
//   final String hint;
//
//   const CustomChipDropdown({
//     super.key,
//     required this.options,
//     required this.selected,
//     required this.onChanged,
//     this.hint = "Select...",
//   });
//
//   @override
//   State<CustomChipDropdown> createState() => _CustomChipDropdownState();
// }
//
// class _CustomChipDropdownState extends State<CustomChipDropdown> {
//   late List<String> _selected;
//
//   @override
//   void initState() {
//     super.initState();
//     _selected = List.from(widget.selected);
//   }
//
//   void _openSelectionDialog() async {
//     final available = widget.options.where((o) => !_selected.contains(o)).toList();
//     final selectedItem = await showDialog<String>(
//       context: context,
//       builder: (_) => SimpleDialog(
//         title: const Text("Select Task"),
//         children: available.map((task) {
//           return SimpleDialogOption(
//             onPressed: () => Navigator.pop(context, task),
//             child: Text(task),
//           );
//         }).toList(),
//       ),
//     );
//
//     if (selectedItem != null && !_selected.contains(selectedItem)) {
//       setState(() {
//         _selected.add(selectedItem);
//       });
//       widget.onChanged(_selected);
//     }
//   }
//
//   void _removeItem(String task) {
//     setState(() {
//       _selected.remove(task);
//     });
//     widget.onChanged(_selected);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _openSelectionDialog,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade400),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Wrap(
//           spacing: 6,
//           runSpacing: -8,
//           children: _selected.isNotEmpty
//               ? _selected
//               .map((task) => Chip(
//             label: Text(task),
//             onDeleted: () => _removeItem(task),
//           ))
//               .toList()
//               : [
//             Text(widget.hint, style: TextStyle(color: Colors.grey.shade600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
