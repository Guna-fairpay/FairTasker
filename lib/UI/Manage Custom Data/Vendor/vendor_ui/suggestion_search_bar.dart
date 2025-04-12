
import 'package:flutter/material.dart';

import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';

class SuggestionSearchBar<T> extends StatefulWidget {
  final List<T> suggestions;
  final String Function(T) displayString;
  final dynamic selectedId;
  final dynamic Function(T) getId;
  final TextEditingController searchController;
  final String hintText;
  final Function(String)? onChanged;
  final Function(T) onSelected;
  final VoidCallback? onIconTap;

  const SuggestionSearchBar({
    super.key,
    required this.suggestions,
    required this.displayString,
    required this.getId,
    required this.searchController,
    required this.onSelected,
    this.selectedId,
    this.hintText = 'Search...',
    this.onChanged,
    this.onIconTap,
  });

  @override
  State<SuggestionSearchBar<T>> createState() => _SuggestionSearchBarState<T>();
}

class _SuggestionSearchBarState<T> extends State<SuggestionSearchBar<T>> {
  final FocusNode _focusNode = FocusNode();
  List<T> _filtered = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.selectedId != null) {
      final matched = widget.suggestions.firstWhere(
            (item) => widget.getId(item) == widget.selectedId,
        orElse: () => null as T,
      );
      if (matched != null) {
        widget.searchController.text = widget.displayString(matched);
      }
    }

    widget.searchController.addListener(_onTextChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _removeOverlay();
    });
  }

  void _onTextChanged() {
    final query = widget.searchController.text.toLowerCase();
    if (widget.onChanged != null) widget.onChanged!(query);

    _filtered = widget.suggestions
        .where((item) => widget.displayString(item).toLowerCase().contains(query))
        .toList();

    _removeOverlay();
    if (query.isNotEmpty && _filtered.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final item = _filtered[index];
                return ListTile(
                  title: Text(widget.displayString(item)),
                  onTap: () {
                    widget.searchController.text = widget.displayString(item);
                    widget.onSelected(item);
                    _removeOverlay();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _focusNode.requestFocus(),
      child: TextField(
        controller: widget.searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppC.grey, fontSize: 14),
          suffixIcon:
          // IconButton(
          //   icon: const Icon(Icons.add, color: AppC.appColor),
          //   onPressed: widget.onIconTap,
          // ),
          InkWell(
            onTap: widget.onIconTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                color: AppC.blue50,
                border:  const Border(
                  top: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
                  bottom: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
                  right: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8,),
                child: Icon(Icons.add,color: AppC.blue,),
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: Num.borderWidthField),
            borderRadius: BorderRadius.circular(Num.subradiusButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppC.appColor, width: Num.borderWidthField),
            borderRadius: BorderRadius.circular(Num.subradiusButton),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
      ),
    );
  }
}


