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
  final LayerLink _layerLink = LayerLink();
  List<T> _filtered = [];
  OverlayEntry? _overlayEntry;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;

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
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_isMounted) return;
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    } else if (widget.searchController.text.isNotEmpty && _filtered.isNotEmpty) {
      _showOverlay();
    }
  }

  void _onTextChanged() {
    if (!_isMounted) return;
    final query = widget.searchController.text.toLowerCase();
    if (widget.onChanged != null) widget.onChanged!(query);

    setState(() {
      _filtered = widget.suggestions
          .where((item) => widget.displayString(item).toLowerCase().contains(query))
          .toList();
    });

    _removeOverlay();
    if (query.isNotEmpty && _filtered.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (!_isMounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    const itemHeight = 48.0;
    const maxHeight = 200.0;
    final itemCount = _filtered.length;
    final calculatedHeight = (itemHeight * itemCount).clamp(0.0, maxHeight);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5,
              width: size.width,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: calculatedHeight,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: itemCount,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      return GestureDetector(
                        onTap: () {
                          if (!_isMounted) return;
                          widget.searchController.text = widget.displayString(item);
                          widget.onSelected(item);
                          _removeOverlay();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          color: AppC.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          height: itemHeight,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.displayString(item),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (!_isMounted) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _isMounted = false;
    widget.searchController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppC.grey, fontSize: 14),
          suffixIcon: GestureDetector(
            onTap: widget.onIconTap,
            child: Padding(
              padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, right: 1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  color: AppC.blue50,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Icon(Icons.add, color: AppC.appColor),
                ),
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