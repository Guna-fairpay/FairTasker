
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class AutoCompleteWidget {
  Widget getAutoComplete(BuildContext context, List<dynamic> list,
      {TextEditingValue? textEditingValue,
      String? Function(String)? onSelectionCallBack,
      String label = '',
      String hint = '',
      Widget Function(
              BuildContext, TextEditingController, FocusNode, VoidCallback)?
          fieldViewBuilderL}) {
    return Autocomplete<String>(
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        const double itemHeight = 30.0; // Set the height of each item
        const int maxVisibleItems = 5; // Limit the maximum visible items
        final double optionsHeight = (options.length <= maxVisibleItems
                ? options.length
                : maxVisibleItems) *
            itemHeight;
        // Customize the appearance of the options
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: AppC.white,
            elevation: 1.0,
            child: SizedBox(
              height: optionsHeight,
              width: MediaQuery.of(context).size.width * 0.72,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Utils.getText(option),
                      ));
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: fieldViewBuilderL!,
      initialValue: textEditingValue,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        List<String> searchList = [];
        for (int i = 0; i < list.length; i++) {
          if (list[i]
              .trim()
              .toLowerCase()
              .contains(textEditingValue.text.trim().toLowerCase())) {
            searchList.add(list[i]);
          }
        }
        return searchList;
      },
      onSelected: onSelectionCallBack,
    );
  }

  dynamic sample(BuildContext context, TextEditingController controller,
      FocusNode focusNode, Function(String value) onFieldSubmitted,
      {VoidCallback? onTapCallBack,
      Function(String)? onChangesCallBack,
      String? label,
      String? hint}) {
/*    if(controller.text.isNotEmpty) {
      controller.text += '-';
    }*/
    return SizedBox(
      height: 35,
      width: MediaQuery.of(context).size.width * 8,
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          label: Utils.getText(label ?? ''),
          hintText: hint ?? '',
          hintStyle: const TextStyle(color: AppC.text),
          filled: true,
          fillColor: AppC.white,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppC().base, width: Num.borderWidthThinField),
            borderRadius: BorderRadius.circular(Num.subradiusButton),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppC().base, width: Num.borderWidthThinField),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        onTap: onTapCallBack,
        onChanged: onChangesCallBack,
        onFieldSubmitted: (String value) {
          onFieldSubmitted(value);
        },
        style: Utils.getTextStyle(
          size: 12,
          color: AppC.text,
          weight: FontWeight.normal,
        ),
      ),
    );
  }
}
