import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomMultiSelectionChipsField<T> extends StatelessWidget {
  final List<T> selectedPartsList;
  final List<T> suggestionsList;
  final ItemAsString<T>? itemAsString;
  final TextEditingController? controller;
  final String? hintText, labelText, emptyText;
  final VoidCallback? onEmptyTap;
  final bool controllerAutoClear;
  final Suggestion suggestionState;
  CustomMultiSelectionChipsField({super.key, required this.selectedPartsList, required this.suggestionsList, this.itemAsString, this.controller, this.emptyText, this.hintText, this.labelText, this.onEmptyTap, this.controllerAutoClear = true, this.suggestionState = Suggestion.expand}) {
    isSelected.value = (selectedPartsList.isNotEmpty);
  }
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  final FocusNode _focusNode = FocusNode();

  void doSetState() {
    isSelected.value = (selectedPartsList.isNotEmpty);
    isSelected.notifyListeners();
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  void removeFocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var commonBorderSide = const BorderSide(color: AppC.fieldBase,
        width: Num.borderWidthField);
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border(
            top: commonBorderSide,
            right: commonBorderSide,
            left: commonBorderSide,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(Num.subradiusButton))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          ValueListenableBuilder(valueListenable: isSelected, builder: (context, value, child) => Wrap(
            children: List<Widget>.generate(
              selectedPartsList.length,
                  (int idx) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0),
                    child: Chip(
                      onDeleted: () {
                        selectedPartsList.removeAt(idx);
                        doSetState();
                      },
                      side: const BorderSide(color: AppC.trans),
                      deleteIcon: const Icon(
                        Icons.close,
                        color: AppC.red,
                        size: 18,
                      ),
                      backgroundColor: const Color(0xffb5d2bb),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      // side: BorderSide(),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utils.getText(
                              itemAsString?.call(selectedPartsList[idx]) ?? "",
                              color: AppC.text),
                        ],
                      ),
                    ));
              },
            ).toList(),
          ),),
          CustomSearchField<T>(
            focusNode: _focusNode,
              suggestions: suggestionsList,
              itemAsString: itemAsString,
              onSuggestionTap: (val) {
              if (!selectedPartsList.contains(val)) selectedPartsList.add(val);
                doSetState();
                requestFocus();
              },
              controller: controller,
              autoControllerClear: controllerAutoClear,
              suggestionState: suggestionState,
              labelText: labelText,
              hintText: hintText,
              // emptyText: emptyText,
              onEmptyTap: onEmptyTap),
        ],
      ),
    );
  }
}
