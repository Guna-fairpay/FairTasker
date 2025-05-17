
import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';

class CustomMultiSelectionChipsField<T extends Object> extends StatelessWidget {
  final List<T> selectedPartsList;
  final List<T> suggestionsList;
  final ItemAsString<T>? itemAsString;
  final TextEditingController? controller;
  final String? hintText, labelText, emptyText;
  final VoidCallback? onEmptyTap;
  final bool controllerAutoClear;
  final Suggestion suggestionState;
  final bool showEmpty;
  final void Function(bool isChecked, T value)? onChanged;

  CustomMultiSelectionChipsField(
      {super.key,
      required this.selectedPartsList,
      required this.suggestionsList,
      this.itemAsString,
      this.controller,
      this.emptyText,
      this.hintText,
      this.labelText,
      this.onEmptyTap,
      this.showEmpty = true,
      this.controllerAutoClear = true,
      this.suggestionState = Suggestion.expand,
      this.onChanged});

  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<bool> _isShowEmptyNotifier = ValueNotifier<bool>(false);

  void requestFocus() {
    _focusNode.requestFocus();
  }

  void removeFocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var commonBorderSide = const BorderSide(
        color: AppC.borderColor, width: Num.borderWidthThinField);
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(top: 10),
      decoration: selectedPartsList.isEmpty
          ? null
          : BoxDecoration(
              border: Border(
                top: commonBorderSide,
                right: commonBorderSide,
                left: commonBorderSide,
              ),
              borderRadius: BorderRadius.circular(Num.borderRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: selectedPartsList.isEmpty ? 0 : 5,
        children: [
          Wrap(
            children: List<Widget>.generate(
              selectedPartsList.length,
              (int idx) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Chip(
                      onDeleted: () =>
                          onChanged?.call(false, selectedPartsList[idx]),
                      side: const BorderSide(color: AppC.trans),
                      color: const WidgetStatePropertyAll(AppC.lowGreen),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      deleteIcon: const Icon(
                        Icons.close,
                        color: AppC.red,
                        size: 18,
                      ),
                      backgroundColor: const Color(0xffb5d2bb),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      // side: BorderSide(),
                      label: Utils.getText(
                          itemAsString?.call(selectedPartsList[idx]) ?? "",
                          color: AppC.text),
                    ));
              },
            ).toList(),
          ),
          if (controller != null)
            ValueListenableBuilder(
              valueListenable: _isShowEmptyNotifier,
              builder: (context, value, child) => CustomAutoSearchField<T>(
                controller: controller!,
                optionsBuilder: (textEditingValue) =>
                    _onSearch(textEditingValue),
                autoClear: true,
                showEmptyWidget: value,
                onSelected: (val) {
                  onChanged?.call(true, val);
                  Future.microtask(() => Utils.dismissKeyboard(context));
                },
                itemAsString: itemAsString,
                labelText: labelText,
                hintText: hintText,
                onEmptyWidgetTap: onEmptyTap,
              ),
            ),
          /*CustomSearchField<T>(
              focusNode: _focusNode,
              suggestions: suggestionsList,
              itemAsString: itemAsString,
              isDense: true,
              contentPadding: 10.padding,
              style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
              onSuggestionTap: (val) {
                onChanged?.call(true, val);
                requestFocus();
              },
              controller: controller,
              autoControllerClear: controllerAutoClear,
              suggestionState: suggestionState,
              labelText: labelText,
              hintText: hintText,
              onEmptyTap: onEmptyTap),*/
        ],
      ),
    );
  }

  Future<Iterable<T>> _onSearch(TextEditingValue editValue) async {
    var val = editValue.text.toLowerCase();
    if (val.isEmpty) {
      return [];
    }
    var data = suggestionsList.where((element) =>
        itemAsString?.call(element).toLowerCase().contains(val) ?? false);
    _isShowEmptyNotifier.value = (showEmpty) ? data.isEmpty : false;
    return data;
  }
}
